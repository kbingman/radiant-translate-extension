module Translate::SiteControllerExtensions
  def self.included(base)
    base.class_eval do
      before_filter :set_language
      
      private

      def set_language 
        if params[:locale]
          I18n.locale = params[:locale].to_sym   
        else  
          # I18n.locale = Radiant::Config['translate.default_site_language']      
          # locale = location_map.include?(languages.first) ? languages.first : Radiant::Config['translate.default_site_language']
          locale = Radiant::Config['translate.default_site_language']
          # path = params[:url] unless params[:url] == '/'
          # redirect_to :locale => locale, :url => path, :status => 301   
          # languages.first
        end
      end   
      
    end  
    
    protected

      def languages
        langs = (request.env["HTTP_ACCEPT_LANGUAGE"] || "").split(/[,\s]+/)
        langs_with_weights = langs.map do |ele|
          both = ele.split(/;q=/)
          lang = both[0].split('-').first
          weight = both[1] ? Float(both[1]) : 1
          [-weight, lang]
        end.sort_by(&:first).map(&:last) 
        langs_with_weights
      end

      def location
        path = location_map.include?(languages.first) ? languages.first : nil
        path ||= "/#{Radiant::Config['translate.default_site_language']}/"
        path += request.request_uri
        path.gsub!(%r{([^:])//}, '\1/')
        if path =~ %r{[:][/][/]}
          path
        else
          path.sub!(%r{^([^/])}, '/\1')
          # @request.protocol + @request.host_with_port + path
        end
      end

      def location_map
        @location_map ||= Radiant::Config['translate.site_languages'].split(',').collect{ |l| l.strip }
      end
  end
  
end