require './news_store'

#data = NewsStore.get("http://208.80.153.172/api?q=claim[131:64,1134:64]%20AND%20noclaim[31:313301,31:561431]%20AND%20claim[18]%20AND%20claim[625]")
data = NewsStore.get("http://208.80.153.172/api?q=claim[131:1726,1134:1726]%20AND%20noclaim[31:313301,31:561431]%20AND%20claim[18]%20AND%20claim[625]")
puts "Found #{data['items'].length} items(s)"
i = 0
data['items'].each { |id| 
  item_id = "Q#{id}"
  item = NewsStore.get("http://www.wikidata.org/w/api.php?action=wbgetentities&ids=#{item_id}&format=json")
  item = item['entities'][item_id]
  if item['claims']['P18']
    doc = {
      :_id => 'wikidata_' + item_id
    }
    if item['labels'] and item['labels']['de']
      doc[:title] = item['labels']['de']['value']
    end
    if item['sitelinks']['dewiki']
      doc[:url] = "http://de.wikipedia.org/wiki/" + item['sitelinks']['dewiki']['title'].gsub(/ /, '_')
    end
    if item['descriptions'] and item['descriptions']['de']
      doc[:body] = item['descriptions']['de']['value']
    end
    if item['claims']['P18']
      image = NewsStore.get("http://commons.wikimedia.org/w/api.php?action=query&prop=imageinfo&iiprop=url&titles=File:#{URI::encode(item['claims']['P18'][0]['mainsnak']['datavalue']['value'])}&iiurlwidth=640&format=json")
      image['query']['pages'].each { |page_id, page|
        if page['imageinfo'] and page['imageinfo'][0]
          doc[:imageUrl] = page['imageinfo'][0]['thumburl']
        end
      }
    end
    if item['claims']['P571']
      publishedAt = item['claims']['P571'][0]['mainsnak']['datavalue']['value']['time']
      doc[:publishedAt] = DateTime.parse(publishedAt).iso8601()
    end
    loc = item['claims']['P625'][0]['mainsnak']['datavalue']['value']
    if loc
      doc[:location] = [loc['longitude'], loc['latitude']]
    end
    puts doc
    puts
    NewsStore.save(doc)
    i += 1
  end
}
puts "Saved #{i} documents"
