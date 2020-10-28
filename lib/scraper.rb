require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url) #return value should be an array of hashes each hash including :name, :location, :profile_url
    students = []
    html = open(index_url)
    html_parsed_to_elements = Nokogiri::HTML(html)
    html_parsed_to_elements.css("div.student-card").each do |student|
      student_details = {}
      student_details[:name] = student.css(".student-name").text
      student_details[:location] = student.css(".student-location").text
      student_details[:profile_url] = student.css("a").attribute("href").value
      students << student_details
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    student_social = {}
    html = open(profile_url)
    html_parsed_to_elements_second_scrape = Nokogiri::HTML(html)
    html_parsed_to_elements_second_scrape.css("div.main-wrapper.profile .social-icon-container a").each do |social|
      if social.attribute("href").value.include?("twitter")
        student_social[:twitter] = social.attribute("href").value
      elsif social.attribute("href").value.include?("linkedin")
        student_social[:linkedin] = social.attribute("href").value
      elsif social.attribute("href").value.include?("github")
        student_social[:github] = social.attribute("href").value
      else
        student_social[:blog] = social.attribute("href").value
      end
    end
    
    student_social[:profile_quote] = html_parsed_to_elements_second_scrape.css("div.main-wrapper.profile .vitals-text-container .profile-quote").text
    student_social[:bio] = html_parsed_to_elements_second_scrape.css("div.main-wrapper.profile .description-holder p"). text

    student_social
    
  end

end

