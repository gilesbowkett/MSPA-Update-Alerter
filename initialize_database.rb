# create_schema.rb - run this file to blow out your existing DB, assuming there is one,
# and populate your DB with the most current link on MSPA

%w{rubygems
   active_record
   sqlite3
   mechanize}.each {|lib| require lib}

system("rm links.sqlite3")

# http://tardigra.de/mcblog/2008/03/standalone-activerecord-and-sq.html
SQLite3::Database.new("links.sqlite3")

# http://oreil.ly/jtowCf
ActiveRecord::Base.establish_connection(
  :adapter  => "sqlite3",
  :database => "links.sqlite3" 
)

ActiveRecord::Schema.define do 
  create_table :links do |t|
    t.string :href, :text
    t.timestamps
  end
end

class Link < ActiveRecord::Base
end

# populate with current top link
Mechanize.new.get("http://mspaintadventures.com") do |page|
  current_top = page.links[21] # magic number! see read_mspa.rb for details
  Link.create!(:href => current_top.href,
               :text => current_top.text)
end

