require 'globalize'

class TranslateExtension < Radiant::Extension
  version RadiantTranslateExtension::VERSION
  description "Adds translate to Radiant."
  url "http://yourwebsite.com/translate"

  # See your config/routes.rb file in this extension to define custom routes
  
  def activate 
    require "i18n/backend/fallbacks" 
    I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
     
    Admin::PagesController.send :include, Translate::ResourceControllerExtensions
    Admin::SnippetsController.send :include, Translate::ResourceControllerExtensions
    SiteController.send :include, Translate::SiteControllerExtensions 
    
    Page.send :include, Translate::PageExtensions   
    Page.send :include, Translate::TranslateTags  
    PagePart.send :include, Translate::PagePartExtensions   
    
    Radiant::Pagination::LinkRenderer.send :include, Translate::LinkRenderer
    
    admin.configuration.show.add :config, 'admin/configuration/show_translate', :after => 'defaults'
    admin.configuration.edit.add :form,   'admin/configuration/edit_translate', :after => 'edit_defaults'
    
    Page.class_eval do
      translates :title, :slug, :breadcrumb    
    end   
    
    # PagePart.class_eval do
    #   translates :content  
    # end
    
    # Snippet.class_eval do
    #   translates :content
    # end  

  end   

end
