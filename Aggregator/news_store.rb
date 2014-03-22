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
    http = Net::HTTP.new(uri.host)
    JSON.parse(http.get(uri.path).body)
  end

end
