ActionController::Routing::Routes.draw do |map|
  # map.namespace :admin, :member => { :remove => :get } do |admin|
  #   admin.resources :translate
  # end 
  
  # map.translated_admin_pages 'admin/pages/locale/:locale', :controller => 'admin/pages', :action => 'index'  
  # map.translated_edit_admin_page 'admin/pages/:id/:action/:locale', :controller => 'admin/pages', :id => /[0-9]+/, :action => /[a-z]+/  
  
  begin
    Radiant::Config['translate.site_languages'].split(',').collect{ |l| l.strip }.each do |code|
      map.connect "#{code.to_s}/*url", :controller => 'site', :action => 'show_page', :locale => code
    end
  rescue
    #raise SiteLanguageError, "Migrations not ran yet.."
  end
                                                                            
end