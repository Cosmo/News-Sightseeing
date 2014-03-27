require 'mongo'
require "json"
require "net/http"
require "date"
require 'open-uri'
require 'yaml'

include Mongo

module NewsStore
  extend self
  @config = YAML::load_file('config.yaml')
  attr_reader :config

  # connecting to the database
  @client = MongoClient.new(@config['mongodb']['host'], @config['mongodb']['port'])
  @db     = @client['newssightseeing']
  @db.authenticate(@config['mongodb']['user'], @config['mongodb']['password'])
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
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == 'https'
    res = http.start { |h|
      h.request(Net::HTTP::Get.new(uri.request_uri))
    }
    body = res.body    
    JSON.parse(body)
  end

end
