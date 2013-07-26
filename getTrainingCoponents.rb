# Do requires…
require 'open-uri'
require 'nokogiri'

@itemCount = 0

def newXML element, code = ""
  xmldoc = Nokogiri::XML::Document.new()
  
  if code != ""
    root = xmldoc.create_element element, :class => code
  else
    root = xmldoc.create_element element
  end
  
  xmldoc.add_child root
  xmldoc
end

def getQualifications code
  qualXML = newXML "qualifications", code
  begin
  
    qualWeb = open("http://training.gov.au/Training/Details/#{code}") { |f| f.read }

    # Parse it
    qDom = Nokogiri::HTML.parse qualWeb

    # Select it and convert it
    qualifications = qDom.css('#tableQualifications tbody tr')
  
    qualifications.each do |node|
      if node["class"] != "t-grouping-row"
        qCode = node.css('td')[1].css('a')[0]["title"]
        qCode["View details for qualification code"] = ""
        qCode = qCode.strip
            
        ttitle = node.css('a')[0].content
        begin
          ttitle["#{qCode}"] = ""
          ttitle[" - "] = ""
        rescue
        end                  
            
        qual = qualXML.create_element "qualification", :id => qCode, :title => ttitle
        qualXML.css("qualifications")[0].add_child qual
      
        getUnits qCode, qualXML   
      end        
    end  
  rescue # ERROR
    
  ensure
    filename = "xml/#{code}_qualifications.xml"
    File.open(filename, 'w') {|f| f.write(qualXML.to_xml) }
    puts "File: #{code}_qualifications.xml saved."
    return qualXML
  end
end


def getSkillSets code
  ssXML = newXML "skillsets", code
  unitCount = 0
  begin
      ssWeb = open("http://training.gov.au/Training/Details/#{code}") { |f| f.read }

      # Parse it
      ssDom = Nokogiri::HTML.parse ssWeb

     # Select it and convert it
      units = ssDom.css('#tableSkillSets tbody tr')
      begin
        count_pages = 1
        units.each do |node|    
          if node["class"] != "t-grouping-row"
            ssCode = node .css('td')[0].css('a')[0]["title"]
            ssCode["View details for skill set code "] = ""
            ssCode = ssCode.strip
          
            ttitle = node.css('a')[0].content
            begin
              ttitle["#{ssCode}"] = ""
              ttitle[" - "] = ""
            rescue
            end                  

            sSet = ssXML.create_element "skillset", :id => ssCode, :title => ttitle
            ssXML.css("skillsets")[0].add_child sSet          
            unitCount += 1
            getUnits ssCode, ssXML
          end    
        end
      
        pages = ssDom.css('#tableSkillSets .t-pager a:last')[0].text
      rescue
        pages = 0
      end
    
      count_pages = 2  
      while count_pages <= pages.to_i

        ssWeb2 = open("http://training.gov.au/Training/Details/#{code}?tableSkillSets-page=#{count_pages}") { |f| f.read }

        ssDom2 = Nokogiri::HTML.parse ssWeb2

        # Select it and convert it
        units2 = ssDom2.css('#tableSkillSets tbody tr')

        units2.each do |node2|    
          if node2["class"] != "t-grouping-row"
            ssCode = node2.css('td')[0].css('a')[0]["title"]
            ssCode["View details for skill set code "] = ""
            ssCode = ssCode.strip
          
            ttitle = node2.css('a')[0].content
            begin
              ttitle["#{ssCode}"] = ""
              ttitle[" - "] = ""
            rescue
            end                            
          
            sSet = ssXML.create_element "skillset", :id => ssCode, :title => ttitle
            ssXML.css("skillsets")[0].add_child sSet          
          
            getUnits ssCode, ssXML          
          end    
        end    
        count_pages += 1  
      end
  rescue # ERROR
  ensure
    if unitCount > 0
      File.open("xml/#{code}_skillsets.xml", 'w') {|f| f.write(ssXML.to_xml) }
      puts "File: #{code}_skillsets.xml saved."
    end
    return ssXML 
  end
end


def getUnits code, xml
  uWeb = open("http://training.gov.au/Training/Details/#{code}") { |f| f.read }
  
  xml.css("##{code}")[0].add_child xml.create_element "units"
  
  # Parse it
  uDom = Nokogiri::HTML.parse uWeb
  
  # Select it and convert it
  units = uDom.css('#tableUnits tbody tr')
  begin
   
  count_pages = 1
  units.each do |node|    
    if node["class"] != "t-grouping-row"
      uCode = node.css('td')[0].css('a')[0]["title"]
      uCode["View details for unit code "] = ""
      uCode = uCode.strip
          
      ttitle = node.css('a')[0].content
      begin
        ttitle["#{uCode}"] = ""
        ttitle[" - "] = ""
      rescue
      end                            
  
      uUnit = xml.create_element "unit", :id => uCode, :title => ttitle
      xml.css("##{code} units")[0].add_child uUnit                
      
    end    
  end
  
    pages = uDom.css('#tableUnits .t-pager a:last')[0].text
  rescue
    pages = 0
  end  
  
  count_pages = 2  
  while count_pages <= pages.to_i
    
    uWeb2 = open("http://training.gov.au/Training/Details/#{code}?tableUnits-page=#{count_pages}") { |f| f.read }

    xml.css("##{code}")[0].add_child xml.create_element "units"
    
    uDom2 = Nokogiri::HTML.parse uWeb2
    
    # Select it and convert it
    units2 = uDom2.css('#tableUnits tbody tr')
  
    units2.each do |node2|    
      if node2["class"] != "t-grouping-row"
        uCode = node2.css('td')[0].css('a')[0]["title"]
        uCode["View details for unit code "] = ""
        uCode = uCode.strip

        ttitle = node2.css('a')[0].content
        begin
          ttitle["#{uCode}"] = ""
          ttitle[" - "] = ""
        rescue
        end                            

        uUnit = xml.create_element "unit", :id => uCode, :title => ttitle
        xml.css("##{code} units")[0].add_child uUnit                

      end    
    end    
    count_pages += 1  
  end  

end


### MAIN PROGRAM STARTS HERE ###

# Prepare
xmlDir = "xml"
Dir.mkdir(xmlDir) unless File.exists?(xmlDir)

# Load the site
# ** Sneaky way to get a list of all TrainingPackages, grab it from a populated combo box **
web = open("http://training.gov.au/Reporting/ReportInfo?reportName=QualificationsandOccupationandSectors") { |f| f.read }

xml = newXML "trainingComponents"

# Parse it
dom = Nokogiri::HTML.parse web

# Select it and convert it
training_packages = dom.css('#p_ParamTrainingPackage option')

description = ""
begin
  training_packages.each do |node|
    @itemCount += 1
    description = node.text
    description["#{node["value"]} "] = ""
  
    trainingPackage = xml.create_element "trainingPackage", :id => node["value"], :title => description
    xml.css('trainingComponents')[0].add_child trainingPackage

    quals = getQualifications node["value"]
    xml.css("##{node['value']}")[0].add_child quals.children

    ssets = getSkillSets node["value"]
    xml.css("##{node['value']}")[0].add_child ssets.children
  end
rescue
  xml.css('trainingComponents')[0].add_child xml.create_element "EPICFAIL", :title => description
ensure
  File.open("xml/TrainingComponents.xml", 'w') {|f| f.write(xml.to_xml) }
  puts "File: TrainingComponents.xml saved."
  puts "======== ALL DONE ========"
end

