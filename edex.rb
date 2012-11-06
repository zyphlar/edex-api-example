# eDex API Example (For Infor / AMSI / eSite)
# This code is released to the public domain and is
# provided by Will Bradley, unaffiliated with Infor or AMSI
# and with no warranty whatsoever.

# See README for usage info.

class UnitsController < ApplicationController
require 'savon'
require 'nokogiri'
 
  # GET /units
  def index
    client = Savon::Client.new "http://amsi.saas.infor.com/AMSIWEBG003/edexweb/esite/leasing.asmx?wsdl"
    response = client.get_property_units do |soap|
      soap.xml = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">  <soap:Body>    <GetPropertyUnits xmlns="http://tempuri.org/">      <UserID>YOUR_EDEX_USERID_HERE</UserID>      <Password>YOUR_EDEX_PASSWORD_HERE</Password>      <PortfolioName>YOUR_COMPANY_NAME_HERE|YOUR_PORTAL_NAME_HERE</PortfolioName>      <XMLData><![CDATA[<edex><propertyid>YOUR_PROPERTY_ID_HERE</propertyid><includeamenities>0</includeamenities></edex>]]></XMLData>    </GetPropertyUnits>  </soap:Body></soap:Envelope>'
    end
    property_data = response.to_hash[:get_property_units_response][:get_property_units_result]
    doc = Nokogiri::XML(property_data)
    @view = doc.css('Unit')[0]['UnitId']
  end
 
end