module Translate::PageExtensions
  def self.included(base)
    # base.class_eval do
    #   translates :title, :slug
    # end  
    
    def save_page_parts
      if @page_parts   
        puts '********************HEY'
        parts_to_be_saved = []
        @page_parts.each do |p|
          p.save!
          old_part = self.parts_without_pending.select{|op| op.name == p.name}.first
          if old_part
            PagePartTranslation.find_all_by_page_part_id(old_part.id).each do |transl|
              transl.update_attributes(:page_part_id => p.id) unless transl.locale.to_sym == I18n.locale
            end
          end
          parts_to_be_saved << p
        end
        self.parts_without_pending.clear
        parts_to_be_saved.each {|part| self.parts_without_pending << part }
      end
      @page_parts = nil
      true
    end
  end
  
  def localized_url(langcode)
    cur_lang = I18n.locale.to_s
    if self.class_name.eql?("RailsPage") # (from the share_layouts extension)
      r = "/#{langcode}/#{self.url[3..-1]}"
    else
      I18n.locale = langcode
      r = "/#{langcode}#{url}"
      I18n.locale = cur_lang
    end
    r
  end  
  
  def localized_slug(langcode)
    cur_lang = I18n.locale
    I18n.locale = langcode
    r = slug
    I18n.locale = cur_lang
    r
  end  
  
  def localized_title(langcode)
    cur_lang = I18n.locale
    I18n.locale = langcode
    r = self.title
    I18n.locale = cur_lang
    r
  end
  
  def localized_breadcrumb(langcode)
    cur_lang = I18n.locale
    I18n.locale = langcode
    r = self.breadcrumb
    I18n.locale = cur_lang
    r
  end
  
end