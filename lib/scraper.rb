require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    # individual cards
    doc.css(".student-card").map do |card|
      card_hash = {}
      card_hash[:name] = card.css(".student-name").text
      card_hash[:location] = card.css(".student-location").text
      card_hash[:profile_url] = card.css('a').attribute('href').text
      card_hash
    end
  end
  
  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    student_hash = {}
    # Question: How to handle data that doesn't exist?
    # Asking a Nokogiri object to look for css that doesn't
    # exist just returns an empty array
    # So we just need to have our selectors work for a given
    # student who has everything we care about
    # and then check for empty arrays on every data point
    
    
    
    # social
    schema = {
      twitter: 'twitter.com',
      github: 'github.com',
      linkedin: 'linkedin.com',
      youtube: 'youtube.com'
    }
    # puts doc.css('.profile-name').text
    social_links = []
    doc.css('.social-icon-container a').each do |icon|
      link = icon.attribute('href').value
      link_type = schema.find { |k,v| link.include?(v) }
      if link_type
        student_hash[link_type[0]] = link
      else
        student_hash[:blog] = link
      end
    
    end
    
    # profile_quote
    student_hash[:profile_quote] = doc.css('.profile-quote').text
    
    # bio
    student_hash[:bio] = doc.css('.bio-block .description-holder').text.gsub!(/\s+/, ' ').strip!
    student_hash
  end

end
index_page = "./fixtures/student-site/index.html"
profile_url = "./fixtures/student-site/students/joe-burgess.html"
profile_list = Dir["./fixtures/student-site/students/*"]
# binding.pry