require 'date'
require 'time'
require 'rubygems'
require 'phantomjs'
require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'
require 'base64'
require 'fileutils'
# require 'pry-byebug'

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

module Scraper
  class WebScraper
    include Capybara::DSL

    def get_images(url)
      visit(url)
      sleep(VISIT_WAIT)
      doc = Nokogiri::HTML(page.html)
      panels = {}
      for panel_index in MIN_CAMERA_PANELS..MAX_CAMERA_PANELS
        id = "#{ID_BASE}#{panel_index}"
        path = "//*[@id=\"#{id}\"]/@src"
        panels[id] = doc.xpath(path).to_s
      end
      panels
    end
  end

  class ActionLogger
    def log(str)
      stamp = DateTime.now
      File.open('log', 'a') { |f|
        f.puts "#{stamp} - #{str}"
      }
    end
  end
end

logger = Scraper::ActionLogger.new
filename = DateTime.now.to_s.gsub('+', '-').gsub(':', '-').gsub('T', ' ') + '.jpg'
logger.log "Starting scrape session." 

for station_index in MIN_STATION_INDEX..MAX_STATION_INDEX
  logger.log "Starting scrape on #{STATION_NAMES[station_index]}."
  station_dir = "#{station_index} - #{STATION_NAMES[station_index]}"
  url = "http://dotcmrt3.gov.ph/cctv.php?stationId=#{station_index}"
  scraper = Scraper::WebScraper.new
  panels = scraper.get_images(url)

  panels.map { |key, image|
    directory = "#{station_dir} #{STATION_BASE}/#{key}"
    save = "#{directory}/#{filename}"
    if image != "assets/img/default.gif"
      FileUtils::mkdir_p "#{directory}"
      File.open(save, 'wb') do|f|
        f.write(Base64.decode64(image[IMAGE_PREFIX.length .. -1]))
        logger.log "Saved #{key} as #{save}."
      end
    else
      logger.log "Scrape failed on #{key}."
    end
  }
end

logger.log "Ending scrape session." 
