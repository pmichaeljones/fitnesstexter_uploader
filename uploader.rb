require "net/http"
require "uri"
require 'pry'
require 'json'
require 'base64'

content = File.binread("mac.pdf")
encoded = Base64.encode64(content)

output = File.open( "mac.txt","w" )
output << encoded
output.close

uri = URI.parse("https://api.trypaper.com/Mailing")

send_data = {
  "ReturnAddressId" => "southbroadway",
  "Content" => encoded,
  "Recipient" => {
    "Name" => "John Smith",
    "Organization" => "CrossFit Smith",
    "AddressLineOne" => "209 Dove Ave",
    "City" => "Chilton",
    "Province" => "WI",
    "PostalCode" => "53014"
  }
}


# Full control
http = Net::HTTP.new(uri.host, uri.port)
http.set_debug_output $stdout
http.use_ssl = true

request = Net::HTTP::Post.new(uri)
request['Content-Type'] = "application/json"
request['Authorization'] = "TPTESTCF24A7D8095EDF88E3EFD6103C"
request.body = send_data.to_json

response = http.request(request)

