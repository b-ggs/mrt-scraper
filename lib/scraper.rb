class Scraper 
  include Capybara::DSL

  def get_images(url)
    visit(url)
    sleep(VISIT_WAIT)
    doc = Nokogiri::HTML(page.html)
    panels = doc.xpath(PATH).map { |uri| uri.to_s }
    panels
  end
end
