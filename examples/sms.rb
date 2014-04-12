#!/usr/bin/env ruby
# This quickstart guide requires the Ruby codekit, which can be found at:
# https://github.com/attdevsupport/codekit-ruby

# Make sure the att-codekit has been installed then require the class
require 'att/codekit'

# Include the name spaces to reduce the code required (Optional)
include Att::Codekit

# Uncomment to set a proxy if required
# Transport.proxy("http://proxyaddress.com:port")

# Use the app settings from developer.att.com for the following values.
# Make sure SMS is enabled for the app key/secret.

# Enter the value from 'App Key' field
client_id = 'ENTER VALUE!'

# Enter the value from 'Secret' field
client_secret = 'ENTER VALUE!'

# Set the fqdn to default of https://api.att.com
fqdn = 'https://api.att.com'

# Create service for requesting an OAuth token
clientcred = Auth::ClientCred.new(fqdn, 
                                  client_id,
                                  client_secret)

# Get OAuth token using the SMS scope
token = clientcred.createToken('SMS')

# Create service for interacting with the SMS api
sms = Service::SMSService.new(fqdn, token)

# Setup the addresses that we want to send 
addresses = "555-555-5555,444-555-5555"

# Alternatively we can use an array
# addresses = [5555555555,"444-555-5555"]

# Send an sms message to the addresses specified
begin

  response = sms.sendSms(addresses, "Message from att's codekit sms example")


rescue Service::ServiceException => e

  # There was an error in execution print what happened
  puts "There was an error, the api returned the following error code:"
  puts "#{e.message}"

else

  puts "Sent SMS with id: #{response.id}"
  puts "Resource url: #{response.resource_url}"

end

puts

# Check the status of the sent message
begin 

  status = sms.smsStatus(response.id)

rescue Service::ServiceException => e

  # There was an error in execution print what happened
  puts "There was an error, the api returned the following error code:"
  puts "#{e.message}"

else

  puts "Status response:"
  puts "\tResource URL: #{status.resource_url}"
  puts "\tDelivery Info:"

  status.delivery_info.each do |info|
    puts "\t\t------------------------"
    puts "\t\tMessage ID: #{info.id}"
    puts "\t\tAddress: #{info.address}"
    puts "\t\tStatus: #{info.status}"
    puts "\t\t------------------------"
  end

end
