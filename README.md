oktga
=====
> *Pronounced as "okay T G A"*

A series of scripts (mostly Ruby) to extract Training Package data from Training.gov.au and making it more useful.

*oktga* is inspired predominently by [Peter Shanks](https://github.com/botheredbybees/) and the work that he has done over many years (from TrainingPackages Unwrapped to [NTISThis!](https://github.com/botheredbybees/ntisthis) ).

If you are going to use my Ruby scripts make sure that you also install the relevant Ruby Gems. The gems that I have used are:  

* [Savon](http://savonrb.com/) (The Heavy Metal Soap Client)  
* [Nokogiri](http://nokogiri.org/) (An extremely useful and easy HTML/XML parser)

Install using:  

<code>gem install nokogiri</code>
  
<code>gem install savon</code>
  
In some cases you might have to use 'sudo' if permissions cause a problem. 

If you're yet to install Ruby, I highly recommend RVM (Ruby Version Manager) to install Ruby and managing your versions. This has helped me out tremendously.  

To get access to the Training.gov.au SOAP services you will need to request access from <http://training.gov.au/Home/Enquiry>. Thanks Peter for the tip.

Enjoy these scripts and if you end up using it to make something epic (or just something fun), please drop me a line at <rheinard@thekorfs.com>.

### xml folder  
The xml folder contains a tree of Training Packages, Qualifications, Skill Sets and the units each contain. This is already extracted and was generated using **getTrainingComponents.rb**.  
These xml files are the input files for *getUnitsFromSource.rb*.

Example Usage:  
<code>ruby getUnitsFromSource.rb xml/TrainingComponents.xml</code>  
<code>ruby getUnitsFromSource.rb xml/CHC08_qualifications.xml</code>  
