%w{rubygems
   active_record
   mechanize
   hpricot}.each {|lib| require lib}

# http://oreil.ly/jtowCf
ActiveRecord::Base.establish_connection(:adapter  => "sqlite3",
                                        :database => "links.sqlite3")

class Link < ActiveRecord::Base
end

agent = Mechanize.new
agent.get("http://mspaintadventures.com") do |page|
  first_link_in_list = page.links[21]

  # if this is new, continue through page.links until the link already seen, and show every
  # link in that subset, excluding of course the one already seen. otherwise, simply wait until
  # cron runs again. also update the DB with the latest value for most recent link.

  known_link = Link.where(:href => first_link_in_list.href).first
  unless known_link
    Link.create!(:href => first_link_in_list.href,
                 :title => first_link_in_list.title)
    # continue for all the links in the list, until you find one that's been seen (this bit is
    # probably recursive) and then open those links in a browser, or send me an e-mail, or
    # ping me on Twitter, or something.

    # Link.delete_all (but latest) (or something) -- it'd be cool to here to just throw out all
    # but the most current link, since the only reason to retain that information is to know if
    # links on the site are new or not.
  end
end

