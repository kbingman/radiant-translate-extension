module Translate::PageExtensions
  
  def self.included(base)
    # base.class_eval do
    #   translates :title, :slug
    # end  
    base.class_eval do
      # These are needed for the Search Extension
      has_many :page_translations
      has_many :page_part_translations, :through => :parts    
    end
  end
  
  def localized_path(langcode)
    cur_lang = I18n.locale.to_s
    if self.class_name.eql?("RailsPage") # (from the share_layouts extension)
      r = "/#{langcode}/#{self.path[3..-1]}"
    else
      I18n.locale = langcode
      r = "/#{langcode}#{path}"
      I18n.locale = cur_lang
    end
    r
  end  
  alias :localized_url :localized_path
  
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