require 'net/http'
require 'nokogiri'
#require 'pry'

#data =

#def new_query
 # apt_listings_html.sub!("division", "hawthorne")
#end



def search_listings_return_urls(query)
  url = "/search/apa?min_price=700&max_price=800&query=+#{query}"
  apt_listings_html = Net::HTTP.get('portland.craigslist.org', url)
  #new_query
  # Parse the HTML

  html_doc = Nokogiri::HTML(apt_listings_html)

  #puts html_doc

  # For each listing, store in array

  rows = html_doc.css("p[class=row]").css("span[class=pl]").css("a")
  #.css("a[data-category=news]")
  # pl a href
  #puts rows.length

  hrefs = []
  base_url = 'http://portland.craigslist.org'


  rows.each do |row|
    #puts row.keys
    #puts row.values
    href = row["href"]
    unless href =~ /\/\/.+/
      hrefs << base_url + href
    end
  end

  hrefs

end

# Display the data nicely in console

listing_urls = []
["hawthorne", "division"].each do |query|
  listing_urls << search_listings_return_urls(query)
end

listing_urls.flatten!
listing_urls.uniq!



puts listing_urls
puts listing_urls.length

listing_urls.each do |url|
  `open "#{url}"`
end