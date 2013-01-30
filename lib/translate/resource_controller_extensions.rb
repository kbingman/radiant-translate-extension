module Translate::ResourceControllerExtensions
    
  def self.included(base)
   base.class_eval do 
     
     def update
       I18n.locale = @locale                                 
       model.update_attributes!(params[model_symbol])    
       I18n.locale = current_user.locale 
       response_for :update                          
     end
     
     protected

       def continue_url(options)
         options[:redirect_to] || (params[:continue] ? {:action => 'edit', :id => model.id, :locale => @locale} : translated_index_page_for_model)
       end   
       
       def set_model_locale
         @locale = (params[:locale] || Radiant::Config['translate.default_site_language']).to_sym
       end 
       
       def translated_index_page_for_model
         parts = {:action => "index"}
         if paginated? && model && i = model_class.all.index(model)
           p = (i / pagination_parameters[:per_page].to_i) + 1
           parts[:p] = p if p && p > 1
         end    
        
         parts[:locale] = @locale
         parts
       end
     
    end
    base.before_filter :set_model_locale
  end
  
end