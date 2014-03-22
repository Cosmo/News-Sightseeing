require './news_store'

data = NewsStore.get("http://api.mh.storyful.com/tags/berlin/stories?access_token=f90c68293243a072ddbfb5256553f60b&limit=100")
puts "Found #{data['total_items']} storie(s)"
i = 0
data['tag']['stories'].each { |article| 
  if article['location'] != nil and article['location'] != "" then
    doc = {
      :_id => 'storyful_' + article['id'].to_s,
      :url => article['html_resource_url'],
      :title => article['title_clean'],
      :body => article['summary'],
      :location => article['location'].split(/,/).reverse().map {|l| l.to_f },
      :imageUrl => article['lead_image']['variants']['large'],
      :publishedAt => article['published_at']
    }
    NewsStore.save(doc)
    i += 1
  end
}
puts "Saved #{i} documents"