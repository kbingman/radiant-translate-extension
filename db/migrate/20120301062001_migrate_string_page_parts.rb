class MigrateStringPageParts < ActiveRecord::Migration
  def self.up   
    StringPagePart.find(:all).each do |part|
      %w(string_content).each do |attrib|
        part.send("#{attrib}=", part.read_attribute(attrib))
      end
      part.save
    end
  end

  def self.down
  end
end
