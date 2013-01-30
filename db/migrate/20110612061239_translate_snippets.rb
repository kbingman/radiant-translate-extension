class TranslateSnippets < ActiveRecord::Migration
  def self.up
    Snippet.create_translation_table! :content => :text
    Snippet.find(:all).each do |snippet|
      %w(content).each do |attrib|
        snippet.send("#{attrib}=", snippet.read_attribute(attrib))
      end
      snippet.save
    end
  end

  def self.down  
    Snippet.drop_translation_table! :migrate_data => true  
  end
end
