require "rubygems"
%w{active_record
   mechanize
   hpricot}.each {|lib| require lib}

agent = Mechanize.new
agent.get("http://mspaintadventures.com") do |page|
  first_link_in_list = page.links[21]
  # if this is new, continue through page.links until the link already seen, and show every
  # link in that subset, excluding of course the one already seen. otherwise, simply wait until
  # cron runs again. also update the DB with the latest value for most recent link.
end

