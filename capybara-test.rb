require 'rubygems'
require 'phantomjs'
require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'
require 'base64'

Phantomjs.path # Force install on require
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, :phantomjs => Phantomjs.path)
end

Capybara.default_driver = :poltergeist
Capybara.run_server = false

module GetImage
  class WebScraper
    include Capybara::DSL

    def get_image(url)
      visit(url)
      sleep(5)
      doc = Nokogiri::HTML(page.html)
      doc.xpath('//*[@id="cameraPanel2"]/@src')
    end
  end
end

url = 'http://dotcmrt3.gov.ph/cctv.php?stationId=13'
scraper = GetImage::WebScraper.new
image64 = scraper.get_image(url).to_s

filename = DateTime.now.to_s.gsub('+', '-').gsub(':', '-') + '.jpg'

if image64 != "assets/img/default.gif"
  File.open(filename, 'wb') do|f|
    f.write(Base64.decode64(image64['data:image/jpeg;base64,'.length .. -1]))
    puts "Saved as " + filename
  end
else
  puts "Scrape failed."
end
