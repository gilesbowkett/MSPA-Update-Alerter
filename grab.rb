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
  def self.sorted
    all.sort_by &:page_number
  end
end

def gather_new_links(links)
  link = links.shift
  unless Link.where(:href => link.href).first
    Link.create!(:href => link.href, :text => link.text)
    gather_new_links(links)
  end
end

def check_web_page
  agent = Mechanize.new
  agent.get("http://mspaintadventures.com") do |page|
    # magic numbers! links[21..65] represent all the "Latest Pages" links in the MSPA UI
    gather_new_links(page.links[21..65])
  end
end

check_web_page
Link.sorted.reverse.each {|l| puts l.page_number}

