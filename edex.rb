# eDex API Example (For Infor / AMSI / eSite)
# This code is released to the public domain and is
# provided by Will Bradley, unaffiliated with Infor or AMSI
# and with no warranty whatsoever.

# See README for usage info.

debug = 2    # Change from 2, to 1, to 0 as you verify things appear sane.
user_id = "YOUR_EDEX_USERID_HERE"
password = "YOUR_EDEX_PASSWORD_HERE"
portfolio_name = "YOUR_COMPANY_NAME_HERE|YOUR_PORTAL_NAME_HERE"
property_id = "YOUR_PROPERTY_ID_HERE"

require "savon"
require 'nokogiri'

# Silence silly warnings and info. Make these true if you want to see HTTP/SOAP debug info.
HTTPI.log = false
Savon.configure do |config|
  config.log = false
end

client = Savon.client("http://amsi.saas.infor.com/AMSIWEBG003/edexweb/esite/leasing.asmx?wsdl")

if debug == 2 then 
  puts client.wsdl.soap_actions 
  puts "If the above looks good, set debug=1"
end

if debug < 2 then
  response = client.request(:get_property_units) do
#WARNING: <?xml must be the first character on the second line below, no indenting allowed.
    soap.xml = <<-eos
<?xml version="1.0" encoding="utf-8"?>
  <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
    <soap:Body>
      <GetPropertyUnits xmlns="http://tempuri.org/">
        <UserID>#{user_id}</UserID>
        <Password>#{password}</Password>
        <PortfolioName>#{portfolio_name}</PortfolioName>
        <XMLData>
          <![CDATA[<edex>
            <propertyid>#{property_id}</propertyid>
            <includeamenities>0</includeamenities>
          </edex>]]>
        </XMLData>
      </GetPropertyUnits>
    </soap:Body>
  </soap:Envelope>
eos
  end

  if debug > 0 then
    puts response
    puts "If the above looks good, set debug=0"
  else
    property_data = response.to_hash[:get_property_units_response][:get_property_units_result]
    doc = Nokogiri::XML(property_data)
    view = doc.css('Unit')[0]['UnitId']
    
    puts "Success! The first unit's ID is #{view}"
  end
end

