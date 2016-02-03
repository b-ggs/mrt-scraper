require_relative 'lib/dependencies'
require_relative 'lib/option_parser'

options = OptionParser.parse(ARGV)
unless options.empty?
  require_relative 'lib/constants'
  require_relative 'lib/capybara_init'
  require_relative 'lib/scraper'
  require_relative 'lib/utility'

  # TODO: Add support for multiple station ids.
  station_ids = [ 
    options[:station_id]
  ]

  logger = Utility::Logger.new
  comparator = Utility::Comparator.new
  scraper = Scraper.new
  timestamp = DateTime.now
  filename = timestamp.to_s.gsub('+', '-').gsub(':', '-').gsub('T', ' ') + '.jpg'

  if comparator.check_if_within_scrape_time
    logger.log("Starting scrape session at #{station_ids}.")

    station_ids.each.with_index { |station_id|
      logger.log "Starting scrape on #{station_id}."
      url = "#{URL_BASE}#{station_id}"
      panels = scraper.get_images(url)

      panels.each.with_index { |uri, panel_index|
        directory = "out/#{station_id}/#{panel_index}/#{timestamp.hour}"
        save = "#{directory}/#{filename}"
        if uri != DEFAULT_URI
          FileUtils::mkdir_p("#{directory}")
          File.open(save, 'wb') do |f|
            f.write(Base64.decode64(uri[IMAGE_PREFIX.length .. -1]))
            logger.log("Saved #{station_id}/#{panel_index} as #{save}.")
          end
        else
          logger.log("Scrape failed on #{station_id}.")
        end
      }
    }
    logger.log('Ending scrape session.')
  else
    logger.log('Not within scrape time.')
  end
end
