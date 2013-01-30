class TranslateParts < ActiveRecord::Migration
  def self.up
    PagePart.create_translation_table! :content => :text
    PagePart.find(:all).each do |part|
      %w(content).each do |attrib|
        part.send("#{attrib}=", part.read_attribute(attrib))
      end
      part.save
    end
  end

  def self.down 
    PagePart.drop_translation_table! :migrate_data => true
  end
end


