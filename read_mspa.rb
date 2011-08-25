%w{rubygems
   active_record
   mechanize
   hpricot}.each {|lib| require lib}

# http://oreil.ly/jtowCf
ActiveRecord::Base.establish_connection(:adapter  => "sqlite3",
                                        :database => "links.sqlite3")

class Link < ActiveRecord::Base
  def page_number
    self.href.match(/p=([0-9]+)/)[1]
  end
  def absolute_path
    "http://mspaintadventures.com" + self.href
  end

  def self.sorted
    all.sort_by(&:page_number).reverse
  end
  def self.purge
    # delete all except most recent
    keeper = sorted.first
    Link.all.each do |link|
      link.destroy unless keeper == link
    end
  end
end

def gather_new_links(links)
  link = links.shift
  return false unless link
  unless Link.where(:href => link.href).first
    Link.create!(:href => link.href, :text => link.text)
    gather_new_links(links)
  end
end

def check_web_page
  agent = Mechanize.new
  agent.get("http://mspaintadventures.com") do |page|
    # magic numbers! links[13..57] represent all the "Latest Pages" links in the MSPA UI
    gather_new_links(page.links[13..57])
  end
end


check_web_page

# launch links, but only if there's something new
if Link.count > 1
  Link.sorted.each do |link|
    system "open '#{link.absolute_path}'"
  end
end

# delete everything but most recent link
Link.purge

