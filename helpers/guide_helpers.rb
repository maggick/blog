module GuideHelpers
  def page_title
    title = "Keller: "
    if data.page.title
      title << data.page.title
    else
      title << "Personal website"
    end
    title
  end
  
  def pages_for_group(group_name)
    group = data.nav.find do |g|
      g.name == group_name
    end
      
    pages = []
    
    return pages unless group
    
    if group.directory
      pages << sitemap.resources.select { |r|
        r.path.include?(group.directory) && !r.data.hidden
      }.map do |r|
        ::Middleman::Util.recursively_enhance({
          :title => r.data.title,
          :path  => r.url 
        })
      end.sort_by { |p| p.title }
    end
    
    pages << group.pages if group.pages
    
    pages.flatten
  end
end
