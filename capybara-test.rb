require 'date'
require 'time'
require 'rubygems'
require 'phantomjs'
require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'
require 'base64'
require 'fileutils'
require 'pry-byebug'

URL_BASE = 'http://dotcmrt3.gov.ph/cctv.php?stationId='
IMAGE_PREFIX = "data:image/jpeg;base64,"
ID_BASE = 'cameraPanel'
STATION_BASE = 'Station'
STATION_NAMES = [
  "",
  "North Ave.",
  "Quezon Ave.",
  "Kamuning",
  "Cubao",
  "Santolan",
  "Ortigas",
  "Shaw Blvd.",
  "Boni Ave.",
  "Guadalupe",
  "Buendia",
  "Ayala",
  "Magallanes",
  "Taft Ave."
]
VISIT_WAIT = 5
MIN_CAMERA_PANELS = 1
MAX_CAMERA_PANELS = 4
MIN_STATION_INDEX = 1
MAX_STATION_INDEX = 13

# PhantomJS initialization
Phantomjs.path
Capybara.register_driver :poltergeist do |app|
  capybara_options = {
    phantomjs: Phantomjs.path, 
    timeout: 120
  }
  Capybara::Poltergeist::Driver.new(app, capybara_options)
end

Capybara.default_driver = :poltergeist
Capybara.run_server = false

module GetImage
  class WebScraper
    include Capybara::DSL

    def get_images(url)
      puts "Visiting #{url}."
      visit(url)
      puts "Waiting for #{VISIT_WAIT} seconds."
      sleep(VISIT_WAIT)
      puts "Parsing."
      doc = Nokogiri::HTML(page.html)
      panels = {}
      for panel_index in MIN_CAMERA_PANELS..MAX_CAMERA_PANELS
        id = "#{ID_BASE}#{panel_index}"
        puts "Getting id #{id}."
        path = "//*[@id=\"#{id}\"]/@src"
        panels[id] = doc.xpath(path).to_s
        puts "Retrieved id #{id}."
      end
      panels
    end
  end
end

station_id = 13
station_dir = "#{station_id} - #{STATION_NAMES[station_id]}"
url = 'http://dotcmrt3.gov.ph/cctv.php?stationId=13'
scraper = GetImage::WebScraper.new
panels = scraper.get_images(url)
filename = DateTime.now.to_s.gsub('+', '-').gsub(':', '-') + '.jpg'

panels.map{ |key, image|
  directory = "#{station_dir} #{STATION_BASE}/#{key}"
  save = "#{directory}/#{filename}"
  if image != "assets/img/default.gif"
    FileUtils::mkdir_p "#{directory}"
    File.open(save, 'wb') do|f|
      f.write(Base64.decode64(image[IMAGE_PREFIX.length .. -1]))
      puts "Saved #{key} as #{save}."
    end
  else
    puts "Scrape failed on #{key}."
  end
}
