require "json"
require "net/http"
require "net/https"

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

def post_json(request)
    #You may wish to replace this code with your preferred library for posting and receiving JSON data.
    
    uri = URI.parse("https://connect.gettyimages.com/oauth2/token/")
    http = Net::HTTP.new(uri.host, 443)
    http.use_ssl = true

    response = http.post(uri.path, request.to_json, {'Content-Type' =>'application/json'}).body
    JSON.parse(response)
 end
 
def search_for_images(phrase)
  request = {
      :RequestHeader => { :Token => @credentials['access_token'] },
      :SearchForImages2RequestBody => {
          :Query => { :SearchPhrase => phrase},
          :ResultOptions => {
              :ItemCount => 25,
              :ItemStartNumber => 1
          },
          :Filter => { :ImageFamilies => ["creative"] }
      }
  }
  post_json(request)
end

login
puts @credentials.inspect
puts search_for_images("tree").inspect
