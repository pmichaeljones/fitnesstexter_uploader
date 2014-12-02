require "net/http"
require "uri"
require 'pry'
require 'json'
require 'base64'

print "What is the name of the file? (cfdog.pdf, cfbig.pdf, etc"
banner_file = gets.chomp

content = File.read(banner_file)
encoded = Base64.encode64(content)

print "Recipient name:"
name = gets.chomp
print "Business Name:"
business = gets.chomp
print "Address Street:"
address = gets.chomp
print "City:"
city = gets.chomp
print "State:"
state = gets.chomp
print "Zip code:"
zip = gets.chomp


send_data = {
  "ReturnAddressId" => "southbroadway",
  "Content" => encoded,
  "Recipient" => {
    "Name" => name,
    "Organization" => business,
    "AddressLineOne" => address,
    "City" => city,
    "Province" => state,
    "PostalCode" => zip
  }
}

uri = URI.parse("https://api.trypaper.com/Mailing")

# Full control
http = Net::HTTP.new(uri.host, uri.port)
http.set_debug_output $stdout
http.use_ssl = true

request = Net::HTTP::Post.new(uri)
request['Content-Type'] = "application/json"
request['Authorization'] = "TPTESTCF24A7D8095EDF88E3EFD6103C"
request.body = send_data.to_json

response = http.request(request)

