require "net/http"
require "uri"
require 'pry'
require 'json'
require 'base64'

print "What is the name of the file? (cfdog.pdf, cfbig.pdf, etc:\n"
banner_file = gets.chomp

content = File.read(banner_file)
encoded = Base64.encode64(content)

confirm = ""

until confirm == "Y"
  print "Recipient name:\n"
  name = gets.chomp
  print "Business Name:\n"
  business = gets.chomp
  print "Address Street:\n"
  address = gets.chomp
  print "City:\n"
  city = gets.chomp
  print "State:\n"
  state = gets.chomp
  print "Zip code:\n"
  zip = gets.chomp

  puts "-----------\n"
  print "Full Mailing Address:\n\n#{name}\n#{business}\n#{address}\n#{city}, #{state} #{zip}\n\nConfirm address? (Y/N): "

  confirm = gets.chomp
end

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

request = Net::HTTP::Post.new(uri.request_uri)
request['Content-Type'] = "application/json"
request['Authorization'] = "TPTESTCF24A7D8095EDF88E3EFD6103C"
request.body = send_data.to_json

response = http.request(request)

