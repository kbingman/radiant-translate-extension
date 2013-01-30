class AddSingleLinePart < ActiveRecord::Migration
  def self.up
    add_column :page_part_translations, :string_content, :string
  end

  def self.down 
    remove_column :page_translations, :string_content
  end
end
