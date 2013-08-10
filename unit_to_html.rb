require "nokogiri"

######################### UTILITY METHODS / OBJECTS #########################
#
#

# Turn Descriptions into CSS IDs, or Classes
# WARNING: Don't change these as it gets used for calling methods
@strings = {
  :modificationhistory => "modification-history",
  :unitdescriptor => "unit-descriptor",
  :applicationoftheunit => "application",
  :licensingregulatoryinformation => "licencing",
  :prerequisites => "pre-requisites",
  :employabilityskillsinformation => "employability-skills",
  :elementsandperformancecriteriaprecontent => "elements-pre",
  :elementsandperformancecriteria => "elements",
  :requiredskillsandknowledge => "skills-knowledge",
  :evidenceguide => "evidence-guide",
  :rangestatement => "range-statement",
  :unitsectors => "unit-sectors",
  :essentialknowledge => "essential-knowledge",
  :essentialskills => "essential-skills"
}
@headings = {
  "essential-knowledge" => "Essential Knowledge",
  "essential-skills" => "Essential Skills",
  "other-skills-knowledge" => "Other Skills / Knowledge",
  "critical-aspects" => "Critical Aspects for Assessment and Evidence", 
  "contexts" => "Context and Resources for Assessment",
  "accessibility" => "Access and Equity Considerations", 
  "methods" => "Methods of Assessment",
  "guides" => "Guides for Assessment"
}

# Dynamic method calling
def call_method string, node
  if @strings.values.include? string
    method_name = "process"
    string.split("-").each do |s|
      method_name += s.slice(0,1).capitalize + s.slice(1..-1)
    end
    send(method_name, string, node)
  end
end

# Replace a string from @strings hash (or return original)
def sym_string string
  sym = strip_special(string).to_sym
  if @strings.include? sym
    return @strings[sym]
  else
    return strip_special(string)
  end
end

# Strip strings of spaces and symbols
def strip_special text, replacement = '', downcase = 'false', to_sym = 'false'
  return text.strip.gsub /[\s\t\n\-\/\(\)\:]+/, replacement if !downcase
  return (text.strip.gsub /[\s\t\n\-\/]+/, replacement).downcase.gsub /[\(\)\:]+/, '' if downcase

  return (text.strip.gsub /[\s\t\n\-\/\(\)\:]+/, replacement).to_sym if !downcase && to_sym
  return ((text.strip.gsub /[\s\t\n\-\/]+/, replacement).downcase.gsub /[\(\)\:]+/, '').to_sym if downcase && to_sym
end

def kill_whitespace text
   temp = text.strip.gsub /[\t\n\0]+/, ""
   temp = temp.gsub /[\s]{2,}/, ""
   return temp
end

# Return with no XML declaration
def nodoc xml
 xml.to_xml(:save_with => Nokogiri::XML::Node::SaveOptions::NO_DECLARATION)
end

# Disavowed Keywords
@disavowed = [
  'element', 'performancecriteria', 'requiredskillsandknowledge', 'evidenceguide', 'application', "descriptor", "employabilityskills"
  ]

######################### NODE PROCESSING METHODS #########################
#
#

def processModificationHistory string, node
  xml = Nokogiri::XML.parse "<div id=\"#{string}\"/>"
  xml.xpath("/div")[0].add_child xml.create_element "h2", "Modification History"

  node.xpath(".//Text//p").each do |para|  
    xml.xpath("/div")[0].add_child xml.create_element "p", kill_whitespace(para.content)
    xml.xpath(".//@id").each {|id| id.remove}
  end
  
  xml.xpath("/div").children
end

def processUnitDescriptor string, node
  xml = Nokogiri::XML.parse "<div id=\"#{string}\"/>"
  xml.xpath("/div")[0].add_child xml.create_element "h2", "Unit Descriptor"

  node.xpath(".//Text//p").each do |para|  
    xml.xpath("/div")[0].add_child xml.create_element "p", kill_whitespace(para.content) if !kill_whitespace(para.content).strip.empty? && !(@disavowed.include? strip_special(para.content))
    xml.xpath(".//@id").each {|id| id.remove}
  end
  
  xml.xpath("/div").children
end

def processApplication string, node
  xml = Nokogiri::XML.parse "<div id=\"#{string}\"/>"
  xml.xpath("/div")[0].add_child xml.create_element "h2", "Application of the Unit"

  node.xpath(".//Text//p").each do |para|  
    xml.xpath("/div")[0].add_child xml.create_element "p", kill_whitespace(para.content) if !kill_whitespace(para.content).strip.empty? && !(@disavowed.include? strip_special(para.content))
    xml.xpath(".//@id").each {|id| id.remove}
  end
  
  xml.xpath("/div").children
end

def processLicencing string, node
  xml = Nokogiri::XML.parse "<div id=\"#{string}\"/>"
  xml.xpath("/div")[0].add_child xml.create_element "h2", "Licensing/Regulatory Information"

  node.xpath(".//Text//p").each do |para|  
    xml.xpath("/div")[0].add_child xml.create_element "p", kill_whitespace(para.content) if !kill_whitespace(para.content).strip.empty? && !(@disavowed.include? strip_special(para.content))
    xml.xpath(".//@id").each {|id| id.remove}
  end
  
  xml.xpath("/div").children
end

def processPreRequisites string, node
  xml = Nokogiri::XML.parse "<div id=\"#{string}\"/>"
  xml.xpath("/div")[0].add_child xml.create_element "h2", "Pre-Requisites"

  node.xpath(".//Text//p").each do |para|  
    xml.xpath("/div")[0].add_child xml.create_element "p", kill_whitespace(para.content) if !kill_whitespace(para.content).strip.empty? && !(@disavowed.include? strip_special(para.content))
    xml.xpath(".//@id").each {|id| id.remove}
  end
  
  xml.xpath("/div").children
end

def processEmployabilitySkills string, node
  xml = Nokogiri::XML.parse "<div id=\"#{string}\"/>"
  xml.xpath("/div")[0].add_child xml.create_element "h2", "Employability Skills"

  node.xpath(".//Text//p").each do |para|  
    xml.xpath("/div")[0].add_child xml.create_element "p", kill_whitespace(para.content) if !kill_whitespace(para.content).strip.empty? && !(@disavowed.include? strip_special(para.content))
    xml.xpath(".//@id").each {|id| id.remove}
  end
    
  xml.xpath("/div").children
end

def processElementsPre string, node
  xml = Nokogiri::XML.parse "<div id=\"#{string}\"/>"
  xml.xpath("/div")[0].add_child xml.create_element "h2", "Elements and Performance Criteria Pre-Content"

  node.xpath(".//Text//p").each do |para|  
    xml.xpath("/div")[0].add_child xml.create_element "p", kill_whitespace(para.content) if !kill_whitespace(para.content).strip.empty? && !(@disavowed.include? strip_special(para.content))
    xml.xpath(".//@id").each {|id| id.remove}
  end
    
  xml.xpath("/div").children
end

## PROCESS ELEMENTS AND PERFORMANCE CRITERIA ##
def processElements string, node
      xml = Nokogiri::XML.parse "<div id=\"#{string}\"/>"
      xml.xpath("/div")[0].add_child xml.create_element "h2", "Elements and Performance Criteria"
 
  elementCount = 0
  criteriaCount = 0
  node.xpath(".//Text//p").each do |para|
      para.xpath("./@id")[0].remove
  
      para.xpath(".//text()").each do |text|
        text.content = "#{text.content.strip} "
        text.content = text.content.gsub /\t+/, " "
        text.remove if text.content.empty?
      end
      para.remove if (para.content.strip.empty?)||(@disavowed.include? strip_special(para.content))
  
      para.xpath(".//cs").each {|cs| cs.name = "em"; cs.xpath("./@id")[0].remove;  }
        
      bAdd = !(para.content.strip.empty?) && !(@disavowed.include? strip_special(para.content))
    
      if bAdd
        # Is it an Element or Criterion?
        bElement = para.content.split(' ')[0].include? "."
        bCriteria = para.text.split(' ')[0].split('.').size > 1
        if bCriteria ; bElement = false; end

        # Add a new Element
        if bElement
          elementCount += 1 if bElement
          criteriaCount = 0 if bElement

          newElement = xml.create_element "div", :class => "element element-#{elementCount}"
          newElement.add_child para.children
          newDiv = xml.create_element "div", :class => "performance-criteria"

#          node.remove
          newElement.add_child newDiv
          xml.xpath('/div')[0].add_child newElement
        end

        # Add a new Criterion
        if bCriteria
          criteriaCount += 1
          newElement = xml.create_element "div", :class => "criterion criterion-#{elementCount}-#{criteriaCount}"
          newElement.add_child para.children
      
          para.remove
          xml.css(".element-#{elementCount} .performance-criteria")[0].add_child newElement
        end
      
      end
  end
  xml.xpath("/div").children
end
## // PROCESS ELEMENTS AND PERFORMANCE CRITERIA ##

## PROCESS ESSENTIAL KNOWLEDGE AND SKILL ##
@skillsknowledge = ["essential-knowledge", "essential-skills", "other-skills-knowledge"]
def processSkillsKnowledge string, node
  
  # Setup the XML structure
  xml = Nokogiri::XML.parse "<div id=\"#{string}\" name=\"e0\"/>"
  xml.xpath("/div")[0].add_child xml.create_element "h2", "Skills and Knowledge"
  xml.xpath("/div")[0].add_child xml.create_element "div", :id=>@skillsknowledge[0]
  xml.xpath("/div")[0].add_child xml.create_element "div", :id=>@skillsknowledge[1]
  xml.xpath("/div")[0].add_child xml.create_element "div", :id=>@skillsknowledge[2]
  
  # Setup node tracking variables
  parentNode = ""
  hierarchy = -1
  preID = -1
  preLevel = 0
  sectioncount = 1
  prepointer = []
  pointer = ""
  counter = 0
  
  node.xpath(".//Text//p").each do |para|  
    # Establish the appropriate hierarchy
     theID = para.xpath("./@id")[0].content.to_i
     hierarchy = 0 if hierarchy < 0
     hierarchy = hierarchy if preID == para.xpath("./@id")[0].content.to_i

    # Add the headings (Skills / Knowledge)
    if para.xpath('.//cs').children.size > 0 && !(@disavowed.include? strip_special(para.content))
        keystring = sym_string(para.content.strip)
        bHeading = true
        xml.css("##{keystring}")[0].add_child xml.create_element "h3",@headings[sym_string(para.content.strip)]            
        parentNode = keystring

    # Add the content
    else

      counter += 1
      # Move down the hierarchy
      if preID < para.xpath("./@id")[0].content.to_i
        hierarchy += 1
        prepointer.push pointer
        pointer = "e#{counter-1}" if counter > 1
        if hierarchy > 1
          xml.css("[@name=#{pointer}]")[0].add_child xml.create_element "ul"
        end
      end

      # Move up the hierarchy
      if preID > para.xpath("./@id")[0].content.to_i
        hierarchy -= 1 
        sectioncount +=1  if hierarchy == 1
        pointer = prepointer.pop
        # If there is an "Other" section
        if hierarchy == 1 && sectioncount ==3
          keystring = "other-skills-knowledge"
          bHeading = true
          xml.css("##{keystring}")[0].add_child xml.create_element "h3",@headings[keystring]
          parentNode = keystring
        end
      end  # /move up
  
      # Attempt to add child node in the right spot
      if !para.content.strip.empty? && "e#{counter}" != pointer && !(@disavowed.include? strip_special(para.content)) && !bHeading
        
        theElement = xml.create_element "li", para.children, :name => "e#{counter}", :class => "level-#{hierarchy}"  if hierarchy > 1
        theElement = xml.create_element "div", para.children, :name => "e#{counter}", :class => "level-#{hierarchy}"  if hierarchy < 2
        
        xml.css("[@name=#{pointer}] ul")[0].add_child theElement if hierarchy > 1
       xml.css("##{parentNode}")[0].add_child theElement if hierarchy < 2 && !parentNode.strip.empty?

      end

    ## Keep the ID and level for the next iteration
    preID = theID         
    preLevel = hierarchy
      
    end
      
  end # Loop paragraphs
  
  xml.xpath("//@name").each {|el| el.remove}
  
  xml.xpath("/div").children
end
## // PROCESS ESSENTIAL KNOWLEDGE AND SKILL ##

## PROCESS EVIDENCE GUIDE ##
@evidenceguide = ["critical-aspects", "accessibility", "contexts", "methods", "guides"]
def processEvidenceGuide string, node

  # Setup the XML structure
  xml = Nokogiri::XML.parse "<div id=\"#{string}\" name=\"e0\"/>"
  xml.xpath("/div")[0].add_child xml.create_element "h2", "Assessment Evidence Guide"
  @evidenceguide.each { |eg| xml.xpath("/div")[0].add_child xml.create_element "div", :id=>eg, :name=>eg }
  
  # Setup node tracking variables
  parentNode = ""
  hierarchy = -1
  preID = -1
  preLevel = 0
  sectioncount = 1
  prepointer = []
  pointer = ""
  counter = 0
  
  node.xpath(".//Text//p").each do |para|  
    # Establish the appropriate hierarchy
     theID = para.xpath("./@id")[0].content.to_i
     hierarchy = 0 if hierarchy < 0
     hierarchy = hierarchy if preID == para.xpath("./@id")[0].content.to_i

     # Add the headings (Skills / Knowledge)
     if para.xpath('.//cs').children.size > 0 && !(@disavowed.include? strip_special(para.content))
         #keystring = sym_string(para.content.strip)
         test = para.content.strip.downcase
         keystring = @evidenceguide[0] if test.include? "critical"
         keystring = @evidenceguide[1] if test.include? "access"
         keystring = @evidenceguide[2] if test.include? "context"
         keystring = @evidenceguide[3] if test.include? "method"
         keystring = @evidenceguide[4] if test.include? "guide"
         bHeading = true
         xml.css("##{keystring}")[0].add_child xml.create_element "h3",@headings[keystring]            
         parentNode = keystring
         pointer = parentNode
         hierarchy = 1
     # Add the content
     else
  
       counter += 1
       # Move down the hierarchy
       if preID < para.xpath("./@id")[0].content.to_i
         hierarchy += 1
         prepointer.push pointer
         
         pointer = "e#{counter-1}" if hierarchy > 2
          if hierarchy > 1 && !pointer.strip.empty?
            xml.css("[@name=#{pointer}]")[0].add_child xml.create_element "ul"
          end
       end

       # Move up the hierarchy
       if preID > para.xpath("./@id")[0].content.to_i
         hierarchy -= 1 
         sectioncount +=1  if hierarchy == 1
       end  # /move up
  
  
       # Attempt to add child node in the right spot
       if !para.content.strip.empty? && "e#{counter}" != pointer && !(@disavowed.include? strip_special(para.content)) && !bHeading

         theElement = xml.create_element "li", para.children, :name => "e#{counter}", :class => "level-#{hierarchy-1}"  if hierarchy > 1
         theElement = xml.create_element "div", para.children, :name => "e#{counter}", :class => "level-#{hierarchy-1}"  if hierarchy < 2
        
         xml.css("[@name=#{pointer}] ul")[0].add_child theElement if hierarchy > 1
        xml.css("##{parentNode}")[0].add_child theElement if hierarchy < 2 && !parentNode.strip.empty?
        #puts para.content

       end
  
       ## Keep the ID and level for the next iteration
       preID = theID         
       preLevel = hierarchy       
       
     end   # Main IF statement 
  
  end  # Loop paragraphs
  
  xml.xpath("//@name").each {|el| el.remove}
  
  xml.xpath("/div").children
end
## // PROCESS EVIDENCE GUIDE ##


## PROCESS RANGE STATEMENT ##
def processRangeStatement string, node
  
  # Setup the XML structure
  xml = Nokogiri::XML.parse "<div id=\"#{string}\" name=\"e0\"/>"
  xml.xpath("/div")[0].add_child xml.create_element "h2", "Range Statement"
  # 
  # Setup node tracking variables
  parentNode = ""
  hierarchy = -1
  preID = -1
  preLevel = 0
  sectioncount = 0
  prepointer = []
  pointer = ""
  counter = 0
  # 
  node.xpath(".//Text//p").each do |para|  
    # Establish the appropriate hierarchy
     theID = para.xpath("./@id")[0].content.to_i
     hierarchy = 0 if hierarchy < 0
     hierarchy = hierarchy if preID == para.xpath("./@id")[0].content.to_i
  
    # Add the headings (Skills / Knowledge)
    if para.xpath('.//cs').children.size > 0 && !(@disavowed.include? strip_special(para.content))
        keystring = sym_string(para.content.strip)
        bHeading = true
        
        if keystring != "range-statement"
          sectioncount +=1 if keystring != "range-statement"
          xml.css("#range-statement")[0].add_child xml.create_element "div", :class=>"range range-#{sectioncount}", :id=>"#{keystring}" , :name=>"#{keystring}" 
          xml.css("##{keystring}")[0].add_child xml.create_element "h3", kill_whitespace(para.content)
          hierarchy = 1
        end
        parentNode = keystring
        pointer = keystring
  
    # Add the content
    else
  
        counter += 1
        # Move down the hierarchy
        if preID < para.xpath("./@id")[0].content.to_i
          hierarchy += 1
          prepointer.push pointer
          pointer = "e#{counter-1}" if hierarchy > 2
          if hierarchy > 1
            xml.css("[@name=#{pointer}]")[0].add_child xml.create_element "ul", :name=> "e#{counter-1}"
          end
        end

      # Move up the hierarchy
      if preID > para.xpath("./@id")[0].content.to_i
        hierarchy -= 1 
        pointer = prepointer.pop
      end  # /move up

      # Attempt to add child node in the right spot
      if !para.content.strip.empty? && "e#{counter}" != pointer && !(@disavowed.include? strip_special(para.content)) && !bHeading
        
        if hierarchy > 1
          theElement = xml.create_element "li", :name => "e#{counter}", :class => "level-#{hierarchy}"  
          theChild = xml.create_element "p", para.children
          theElement.add_child theChild
        end
        theElement = xml.create_element "div", para.children, :name => "e#{counter}", :class => "level-#{hierarchy}"  if hierarchy < 2
        
       xml.css("[@name=#{pointer}] ul")[0].add_child theElement if hierarchy > 1
       xml.css("##{parentNode}")[0].add_child theElement if hierarchy < 2 && !parentNode.strip.empty?
  
      end
  
    ## Keep the ID and level for the next iteration
    preID = theID         
    preLevel = hierarchy
      
    end
      
  end # Loop paragraphs
  
  xml.xpath("//@name").each {|el| el.remove}
  
  xml.xpath("/div").children
end
## // PROCESS RANGE STATEMENT ##


def processUnitSectors string, node
  xml = Nokogiri::XML.parse "<div id=\"#{string}\"/>"
  xml.xpath("/div")[0].add_child xml.create_element "h2", "Unit Sector(s)"

  node.xpath(".//Text//p").each do |para|  
    xml.xpath("/div")[0].add_child xml.create_element "p", kill_whitespace(para.content) if !kill_whitespace(para.content).strip.empty? && !(@disavowed.include? strip_special(para.content))
    xml.xpath(".//@id").each {|id| id.remove}
  end
    
  xml.xpath("/div").children
end


######################### BOOTSTRAP #########################
#
#


######################### MAIN PROGRAM #########################
#
#
def convert_to_html filename
  doc   = Nokogiri::XML(File.read(filename))
  doc.remove_namespaces!()

  ## Document to be produced
  xml = Nokogiri::XML::Document.new()

  xml.add_child xml.create_element "html"
  #head
  xml.xpath("/html")[0].add_child xml.create_element "head"
  xml.xpath("//head")[0].add_child xml.create_element "title"
  xml.xpath("//head")[0].add_child xml.create_element "meta", :name=>"viewport", :content=>"width=devive-width, initial-scale=1.0"
  xml.xpath("//head")[0].add_child xml.create_element "link", :href=>"http://netdna.bootstrapcdn.com/bootstrap/3.0.0-rc1/css/bootstrap.min.css", :rel=>"stylesheet", :media=>"screen"
  #body
  xml.xpath("/html")[0].add_child xml.create_element "body"
  xml.xpath("//body")[0].add_child xml.create_element "div", :class=>"container"
  xml.xpath("//body//div[@class='container']")[0].add_child xml.create_element "h1", :id=>"unit-header"
  unit_header = ""

  doc.xpath("//Book//VariableAssignment").each do |var|
    # var.xpath("//@id").each {|id| id.remove}
    type = kill_whitespace(var.xpath("./Name")[0].content)
    if type == "Code"    
      unit_header += "<span class=\"unit-code\">#{kill_whitespace(var.xpath("./Value")[0].content)}</span> " if !var.xpath("./Value")[0].content.strip.empty?
    end
    if type == "Title"
      unit_header += "<span class=\"unit-title\">#{kill_whitespace(var.xpath("./Value")[0].content)}</span" if !var.xpath("./Value")[0].content.strip.empty?
    end  
  end

  xml.xpath('//*[@id="unit-header"]')[0].add_child xml.parse unit_header

  doc.xpath("/AuthorIT/Objects/Topic").each do |node|
 
    # Get the Section of the Unit Outline
    id_string = sym_string node.xpath("./Object/Description")[0].content
    xml.xpath("//body//div[@class='container']")[0].add_child xml.create_element "div", :id => id_string, :class=> "section"
 
      xml.css("##{id_string}")[0].add_child call_method(id_string, node)
  end

  # Add Bootstrap Scripts
  xml.xpath("//body")[0].add_child xml.create_element "script", :src=>"http://code.jquery.com/jquery.js"
  xml.xpath("//body")[0].add_child xml.create_element "script", :src=>"http://netdna.bootstrapcdn.com/bootstrap/3.0.0-rc1/js/bootstrap.min.js"
  xml.xpath("//body")[0].add_child xml.create_element "script", :src=> "js/respond.min.js"


  # HTML 5 OUT
  return "<!DOCTYPE html>" + xml.to_xml(:save_with => Nokogiri::XML::Node::SaveOptions::DEFAULT_HTML).to_s
end

#puts convert_to_html('CHCAC317A_R1.xml')