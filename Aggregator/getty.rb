require "json"
require "net/http"
require "net/https"
require 'date'
require './news_store'

@client_id      = "fgdrfzcdtypgzdbrf9draghx"
@client_secret  = "gvCCa75Ev2Uk4rfJzRcwv3ubjUaZBVsu86SuSkzHTfJFG"
@credentials    = nil

def login
    uri = URI.parse("https://connect.gettyimages.com/oauth2/token/")
    http = Net::HTTP.new(uri.host, 443)
    http.use_ssl = true
    response = http.post(uri.path, "client_id=#{@client_id}&client_secret=#{@client_secret}&grant_type=client_credentials", {'Content-Type' =>'application/x-www-form-urlencoded'}).body
    @credentials = JSON.parse(response)
end

def search_for_images(phrase, start_item)
  request = {
      :RequestHeader => { :Token => @credentials['access_token'] },
      :SearchForImages2RequestBody => {
          :Query => { :SearchPhrase => phrase},
          :ResultOptions => {
              :ItemCount => 75,
              :ItemStartNumber => start_item
          },
          :Filter => { :ImageFamilies => ["editorial"] }
      }
  }
  uri = URI.parse("https://connect.gettyimages.com/v1/search/SearchForImages")
  http = Net::HTTP.new(uri.host, 443)
  http.use_ssl = true
  response = http.post(uri.path, request.to_json, {'Content-Type' =>'application/json'}).body
  File.open('/tmp/getty.json', "w") { |getty_file|
    getty_file.write(response)
  }
  JSON.parse(response)
end

def get_image_details(image_list)
  request = {
        :RequestHeader => {
            :Token => @credentials['access_token'],
            :CoordinationId => "MyUniqueId"
        },
        :GetImageDetailsRequestBody => {
            :CountryCode => "USA",
            :ImageIds => image_list,
            :Language => "en-us"
        }
    }
    uri = URI.parse("https://connect.gettyimages.com/v1/search/GetImageDetails")
    http = Net::HTTP.new(uri.host, 443)
    http.use_ssl = true
    response = http.post(uri.path, request.to_json, {'Content-Type' =>'application/json'}).body
    File.open('/tmp/getty_detail.json', "w") { |getty_file|
      getty_file.write(response)
    }
    JSON.parse(response)
end

@filtered_ids = {}

def filter(id, threshold)
  if @filtered_ids[id] then
    @filtered_ids[id] += 1
  else
    @filtered_ids[id] = 1
  end
  return @filtered_ids[id] <= threshold
end

@locations = {} #File.read("var/locations.json").to_json()

login
puts "Credentials: #{@credentials.inspect}"
i = 1
while i < 3500 do
  images = search_for_images("Munich", i)
  image_id_list = images['SearchForImagesResult']['Images'].map{ |i| i['ImageId'] }
  puts "Found #{image_id_list.length} images"
  details = get_image_details(image_id_list)  
  details['GetImageDetailsResult']['Images'].each { |img|
    person = nil
    doc = {
      :_id => 'getty_' + img['ImageId'],
      :url => "http://www.gettyimages.de/detail/#{img['ImageId']}",
      :title => img['Title'],
      :body => img['Caption'],
      :imageUrl => img['UrlComp'],
      :event => img['EventId']
    }
    doc['publishedAt'] = DateTime.strptime(img['DateCreated'].slice(6, 10), '%s').iso8601()
    img['Keywords'].each { |kw| 
      if kw['Type'] == 'SpecificPeople' then
        doc[:person] = kw['Text']
      end
    }
    img['Keywords'].each { |kw|
      if kw['Type'] == 'Location' and kw['Text'] != 'Hannover' and kw['Text'] != 'Asia' and kw['Text'] != 'Europe' and kw['Text'] != 'Germany' and kw['Text'] != 'Munich' then
        if filter("#{doc[:event]}-#{doc[:person]}", 1) and filter("#{doc[:event]}", 4) then
          location = kw['Text']
          if @locations.has_key?(location) then
            loc = @locations[location]            
          else
            query = URI::encode("#{location},Munich")
            places_url = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=#{query}&sensor=true&key=AIzaSyBLzJW7tQA7u8G0pZlUet_Mg2A7XEH3r6E"
            puts "Querying #{places_url}"
            data = NewsStore.get(places_url)
            if data['results'] and data['results'][0] then
              loc = [data['results'][0]['geometry']['location']['lng'], data['results'][0]['geometry']['location']['lat']]
            else
              loc = false
            end
            @locations[location] = loc
          end
          if loc then
            doc[:location] = loc
            puts location
            puts doc
            puts
            NewsStore.save(doc)
          end
        end
      end
    }
  }
  i += 75
end

File.open('var/locations.json', "w") { |location_file|
  location_file.write(@locations.to_json)
}
