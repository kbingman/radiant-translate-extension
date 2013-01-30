Radiant.config do |config| 
  
  config.namespace 'translate', :allow_display => true do |translate|     
    translate.define 'default_site_language', :default => 'en'
    translate.define 'site_languages', :default => 'en'
  end     
  
end
       

