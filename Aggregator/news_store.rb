require 'mongo'
require "json"
require "net/http"
require "date"

include Mongo

module NewsStore

  # connecting to the database
  @client = MongoClient.new('ds031088.mongolab.com', 31088)
  @db     = @client['newssightseeing']
  @db.authenticate('newssightseeing', 'XIj3lGlApxQsA4KdsDKbT4RAaB2Psk8Lvmfb0LbA.IQ-')
  @coll   = @db['articles']

  # inserting documents
  #10.times { |i| coll.insert({ :count => i+1 }) }

  # finding documents
  puts "There are #{@coll.count} total documents."
  
  def self.save(document)
    @coll.save(document)
  end
  
  def self.get(url)
    uri = URI.parse(url)
    req = Net::HTTP::Get.new(uri)
    res = Net::HTTP.start(uri.hostname, uri.port) { |http|
      http.request(req)
    }
    body = res.body    
    #http = Net::HTTP.new(uri.host)
    #body = http.get(uri.path).body
    JSON.parse(body)
  end

end
