module Translate::TranslateTags
  include Radiant::Taggable  
  include LocalTime

  class TagError < StandardError; end
  class RequiredAttributeError < StandardError; end

  tag 'localized_slug' do |tag|
    tag.locals.page.localized_slug(tag.attr['locale'] || I18n.locale.to_s)
  end   
  
  tag 'localized_url' do |tag|
    tag.locals.page.localized_url(tag.attr['locale'] || I18n.locale.to_s)
  end 
  
  tag 'localized_title' do |tag|
    tag.locals.page.localized_title(tag.attr['locale'] || I18n.locale.to_s)
  end 
  
  tag 'localized_breadcrumb' do |tag|
    tag.locals.page.localized_breadcrumb(tag.attr['locale'] || I18n.locale.to_s)
  end
  
  tag 'locale' do |tag|
    I18n.locale.to_s
  end
  
  tag 'if_locale' do |tag|
    tag.expand if I18n.locale.to_s == tag.attr['locale']
  end
  
  # Hacked standard_tags
  
  desc %{ 
    Renders a link to the page. When used as a single tag it uses the page's title
    for the link name. When used as a double tag the part in between both tags will
    be used as the link text. The link tag passes all attributes over to the HTML
    @a@ tag. This is very useful for passing attributes like the @class@ attribute
    or @id@ attribute. If the @anchor@ attribute is passed to the tag it will
    append a pound sign (<code>#</code>) followed by the value of the attribute to
    the @href@ attribute of the HTML @a@ tag--effectively making an HTML anchor.
    
    *Usage:*
    <pre><code><r:link [anchor="name"] [other attributes...] /></code></pre>
    or
    <pre><code><r:link [anchor="name"] [other attributes...]>link text here</r:link></code></pre>
  }
  tag 'link' do |tag|
    options = tag.attr.dup
    anchor = options['anchor'] ? "##{options.delete('anchor')}" : ''
    attributes = options.inject('') { |s, (k, v)| s << %{#{k.downcase}="#{v}" } }.strip
    attributes = " #{attributes}" unless attributes.empty?
    text = tag.double? ? tag.expand : tag.render('title')
    if Radiant::Config['translate.site_languages'].split(',').length > 1
      %{<a href="/#{(I18n.locale.to_s)}#{tag.render('url')}#{anchor}"#{attributes}>#{text}</a>}
    else
      %{<a href="#{tag.render('url')}#{anchor}"#{attributes}>#{text}</a>}
    end
  end
  
  desc %{
    Renders a trail of breadcrumbs to the current page. The separator attribute
    specifies the HTML fragment that is inserted between each of the breadcrumbs. By
    default it is set to @>@.
    
    *Usage:* 
    <pre><code><r:breadcrumbs [separator="separator_string"] /></code></pre>
  }
  tag 'breadcrumbs' do |tag|
    page = tag.locals.page
    breadcrumbs = [page.breadcrumb]
    page.ancestors.each do |ancestor|
      if SiteLanguage.count > 0
        breadcrumbs.unshift %{<a href="/#{I18n.locale.to_s}#{ancestor.url}">#{ancestor.breadcrumb}</a>}
      else
        breadcrumbs.unshift %{<a href="#{ancestor.url}">#{ancestor.breadcrumb}</a>}
      end
    end
    separator = tag.attr['separator'] || ' &gt; '
    breadcrumbs.join(separator)
  end   
  
  
end