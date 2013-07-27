# Background #

When I first started this project I did not yet have access to Training.gov.au web services.
This meant that my original approach was based on website scraping. This is likely to produce a sub-par result
that can be greatly improved on by rewriting using SOAP processes. 

However, the non-SOAP approach makes this a bit more accessible. That said, when I produced the
**getUnitsFromSource.rb** script I did use SOAP.

# Improvements #

Improvements to these two scripts in particular could include:  

* Combine scripts into one script resulting in fever SOAP calls or page loads  
* Rewrite the original **getTrainingResources.rb** using SOAP  
* Rewrite **getUnitsFromSource.rb** to only use 'open-uri' and drop SOAP completely - making it all more accessible
* Rewrite scraping methods with threading - greatly improving the overall performance of the scrips

# Actions #

Because I only need the data produced by these scripts once, I am not likely to rewrite the code anytime soon. The reason for this
is so that I can focus on the projects that result from this data. 