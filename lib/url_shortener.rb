require 'net/http'

module UrlShortener
  def self.shorten url
    http = Net::HTTP.new("www.googleapis.com", 443)
    http.use_ssl = true
    
    params = {'longUrl' => url}.to_json
    resp, body = http.post("/urlshortener/v1/url?key=#{GOOGLE_API_KEY}",
                           params,
                           {'Content-Type' => 'application/json'})
    
    return JSON.parse(body)['id']
  end
end