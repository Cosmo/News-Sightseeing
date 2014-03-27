require './news_store'

tag = NewsStore::config['storyful']['tag']
url = "http://api.storyful.com/tags/#{tag}/stories?limit=100"
if NewsStore::config['storyful']['access_token'] then
  url += "&access_token=" + NewsStore::config['storyful']['access_token']
end
puts "Retrieving stories for tag #{tag}..."
data = NewsStore.get(url)
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
