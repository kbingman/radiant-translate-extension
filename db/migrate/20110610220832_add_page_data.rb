class AddPageData < ActiveRecord::Migration
  def self.up 
    Page.find(:all).each do |page|
      %w(title slug breadcrumb).each do |attrib|
        page.send("#{attrib}=", page.read_attribute(attrib))
      end
      page.save
    end
  end

  def self.down
  end
end
