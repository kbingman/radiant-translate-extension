# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application_controller'
require 'radiant-translate-extension/version'
class TranslateExtension < Radiant::Extension
  version RadiantTranslateExtension::VERSION
  description "Adds translate to Radiant."
  url "http://yourwebsite.com/translate"
  
  extension_config do |config|
    # config.gem 'globalize2'
    # config.after_initialize do
    #   run_something
    # end
  end

  # See your config/routes.rb file in this extension to define custom routes
  
  def activate 
    require "i18n/backend/fallbacks" 
    I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
     
    Admin::PagesController.send :include, Translate::ResourceControllerExtensions
    Admin::SnippetsController.send :include, Translate::ResourceControllerExtensions
    SiteController.send :include, Translate::SiteControllerExtensions 
    
    Page.send :include, Translate::PageExtensions   
    Page.send :include, Translate::TranslateTags    
    
    admin.configuration.show.add :config, 'admin/configuration/show_translate', :after => 'defaults'
    admin.configuration.edit.add :form,   'admin/configuration/edit_translate', :after => 'edit_defaults'
    
    Page.class_eval do
      translates :title, :slug, :breadcrumb    
    end   
    
    PagePart.class_eval do
      translates :content  
    end
    
    Snippet.class_eval do
      translates :content
    end  

  end   
  
  private
  
    # def update_sass_each_request
    #   ApplicationController.class_eval do
    #     prepend_before_filter :update_assets_sass
    #     def update_assets_sass
    #       radiant_assets_sass = "#{RAILS_ROOT}/public/stylesheets/sass/admin/translate.sass"
    #       extension_assets_sass = "#{TranslateExtension.root}/public/stylesheets/sass/admin/translate.sass"
    #       FileUtils.mkpath File.dirname(radiant_translaste_sass)
    #       if (not File.exists?(radiant_translaste_sass)) or (File.mtime(extension_assets_sass) > File.mtime(radiant_assets_sass))
    #         FileUtils.cp extension_assets_sass, radiant_assets_sass
    #       end
    #     end
    #   end
    # end
end
