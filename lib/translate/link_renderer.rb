module Translate::LinkRenderer
  
  def self.included(base)
    base.class_eval {
      
      def page_link(page, text, attributes = {})
        linkclass = %{ class="#{attributes[:class]}"} if attributes[:class]
        linkrel = %{ rel="#{attributes[:rel]}"} if attributes[:rel]
        param_name = WillPaginate::ViewHelpers.pagination_options[:param_name]
        %Q{<a href="/#{I18n.locale}#{@url_stem}?#{param_name}=#{page}"#{linkrel}#{linkclass}>#{text}</a>}
      end
      
    }
  end
  
end