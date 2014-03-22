require './news_store'

data = NewsStore.get("http://interaktiv.morgenpost.de/gesprengte-geldautomaten/data.json")
data['storymap']['slides'].each { |article| 
  if article['type'] == nil then
    doc = {
      :_id => 'bankomat_' + article['date'],
      :url => "http://interaktiv.morgenpost.de/gesprengte-geldautomaten/",
      :title => article['text']['headline'],
      :body => article['text']['text'],
      :location => [article['location']['lon'], article['location']['lat']],
      :imageUrl => "http://interaktiv.morgenpost.de/gesprengte-geldautomaten/" + article['media']['url']
    }
    match = /\d\d\.\d\d\.\d\d\d\d/.match(article['media']['caption'])
    if match then
      doc['publishedAt'] = DateTime.parse(match[0]).iso8601()
    end
    NewsStore.save(doc)
  end
}
