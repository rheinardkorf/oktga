# This script receives an XML source of Training Components
# extracted from TRAINING.GOV.AU using getTrainingComponents.rb
#
# The script will then parse the source for the list of units
# and use SOAP to access available file releases from the
# TRAINING.GOV.AU SOAP web services.
#
# By default it will save any files in a sub directory (./pdf)
# The script can easily be modified to pull the unit XML files.
#
# I chose to pull the PDFs for alternate workflows.
#
# Usage::     ruby getUnitsFromSource.rb [thesource.xml]
#
# Note::      You will need login credentials from training.gov.au
#             Request credentials from:
#             http://training.gov.au/Home/Enquiry
#
# Author::    Rheinard Korf  (mailto:rheinard@thekorfs.com)
# Copyright:: Copyright (c) 2012 Rheinard Korf
# License::   Distributed under the MIT License. See 'LICENSE'
#

require 'savon'
require 'nokogiri'
require 'open-uri'

@pdfurl = 'http://training.gov.au/TrainingComponentFiles/'

# Prepare
pdfDir = "pdf"
Dir.mkdir(pdfDir) unless File.exists?(pdfDir)

@username = [YOUR USERNAME HERE]
@password = [YOUR PASSWORD HERE]

# Setup SOAP Client
@client = Savon.client do
  wsdl "https://ws.sandbox.training.gov.au/Deewr.Tga.WebServices/TrainingComponentService.svc?wsdl"
  wsse_auth(@username, @password)  

  convert_request_keys_to :camelcase 
  env_namespace :soapenv
  
  pretty_print_xml true
  log false
end

# A message to send with the SOAP operation: GetDetails
class TrainingComponent
  def initialize(code)
    @code = code
  end
  def to_s
    unitCode = @code
    builder = Nokogiri::XML::Builder.new do |xml|
      xml['tns'].request('xmlns:tns' => 'http://training.gov.au/services/'){
        xml['tns'].Code unitCode
      }
    end    
    builder.to_xml(:save_with => Nokogiri::XML::Node::SaveOptions::NO_DECLARATION)
  end
end

# Download the Unit's PDF file (Source found using SOAP)
def getPDF code
  begin
    response = @client.call(:get_details, message: TrainingComponent.new(code))
    xmldoc = Nokogiri::HTML.parse response.doc.inner_html

    xmldoc.css('relativepath').each do |path|
      if path.content.include? 'pdf'
        file = path.text.split("\\")[1]
        urlpart = path.text
        urlpart["\\"] = "/"
        if !File.exists? ("pdf/#{file}")
          File.open("pdf/#{file}", "wb") do |file|
            file.write open("#{@pdfurl}#{urlpart}").read
          end
          puts "Downloaded: #{file}"
        end
      end
    end
  rescue # ERROR
  end
end

@countItems = 0
ARGV.each do|a|
  # Replace spaces with %20
  source = a.gsub /\s+/, '%20'

  source_file = open(source) { |f| f.read }
  
  xml = Nokogiri::HTML.parse source_file
  total = xml.css('unit').size
  xml.css('unit').each do |unit|

    puts "Processing #{unit.attr('id')} - #{unit.attr('title')} (#{@countItems} of #{total})."
    getPDF unit.attr('id')

  @countItems+=1
  end

end
