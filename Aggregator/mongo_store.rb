require 'mongo'
require "json"
require "net/http"
require "date"

include Mongo

# connecting to the database
client = MongoClient.new('ds031088.mongolab.com', 31088)
db     = client['newssightseeing']
db.authenticate('newssightseeing', 'XIj3lGlApxQsA4KdsDKbT4RAaB2Psk8Lvmfb0LbA.IQ-')
coll   = db['articles']

# inserting documents
#10.times { |i| coll.insert({ :count => i+1 }) }

# finding documents
puts "There are #{coll.count} total documents. Here they are:"
coll.find.each { |doc| puts doc.inspect }

def bankomat
    uri = URI.parse("http://interaktiv.morgenpost.de/gesprengte-geldautomaten/data.json")
    http = Net::HTTP.new(uri.host)
    JSON.parse(http.get(uri.path).body)
end

if false
  data = bankomat()
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
      coll.save(doc)
    end
  }
end