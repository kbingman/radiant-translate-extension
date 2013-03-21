module Translate::PagePartExtensions
  
  def self.included(base)
    base.class_eval {
      has_many :page_part_translations
    }
  end
  
end