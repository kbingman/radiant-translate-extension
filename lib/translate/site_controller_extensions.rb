module Translate::SiteControllerExtensions
  def self.included(base)
    base.class_eval do
      before_filter :set_language
      
      def show_page
        url = params[:url]
        locale = current_locale(params[:locale])
        
        if Array === url
          url = url.join('/')
        else
          url = url.to_s
        end
        if @page = find_page(url) && params[:locale]
          batch_page_status_refresh if (url == "/" || url == "")
          process_page(@page)
          set_cache_control
          @performed_render ||= true
        elsif @page = find_page(url)
          redirect_to :locale => locale, :url => @page.path, :status => 301   
        else
          render :template => 'site/not_found', :status => 404
        end
      rescue Page::MissingRootPageError
        redirect_to welcome_url
      end
      
      private

      def set_language 
        I18n.locale = current_locale(params[:locale]).to_sym   
      end   
      
      def current_locale locale
        if locale_included?(locale)
          locale
        else
          Radiant::Config['translate.default_site_language']
        end
      end
      
      def locale_included? locale
        if Radiant::Config['translate.site_languages'].split(',').include?(locale)
      end
      
    end  
    
  end
  
end