require_relative 'lib/dependencies'
require_relative 'lib/constants'
require_relative 'lib/capybara_init'
require_relative 'lib/scraper'
require_relative 'lib/utility'

logger = Utility::Logger.new
comparator = Utility::Comparator.new
scraper = Scraper.new
filename = DateTime.now.to_s.gsub('+', '-').gsub(':', '-').gsub('T', ' ') + '.jpg'

if comparator.check_if_within_scrape_time
  logger.log('Starting scrape session.')

  STATION_IDS.each.with_index { |station_id, station_index|
    logger.log "Starting scrape on #{station_id}."
    station_dir = "#{station_index} - #{station_id}"
    url = "http://dotcmrt3.gov.ph/cctv/#{station_id}"
    panels = scraper.get_images(url)

    panels.each.with_index { |uri, index|
      directory = "#{station_dir}/#{index}"
      save = "#{directory}/#{filename}"
      if uri != DEFAULT_IMAGE
        FileUtils::mkdir_p("#{directory}")
        File.open(save, 'wb') do |f|
          f.write(Base64.decode64(uri[IMAGE_PREFIX.length .. -1]))
          logger.log("Saved #{station_dir} #{STATION_BASE} #{index} as #{save}.")
        end
      else
        logger.log("Scrape failed on #{station_id}.")
      end
    }
  }

  logger.log('Ending scrape session.')
else
  logger.log('Not within scrape time')
end
