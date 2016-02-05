require_relative 'lib/dependencies'
require_relative 'lib/option_parser'

options = OptionParser.parse(ARGV)
unless options.empty?
  require_relative 'lib/constants'
  require_relative 'lib/capybara_init'
  require_relative 'lib/scraper'
  require_relative 'lib/utility'

  # TODO: Add support for multiple station ids.
  station_id = options[:station_id]
  working_directory = options[:directory] ? options[:directory] + "/" : ""
  FileUtils::mkdir_p("#{working_directory}") if working_directory != ""

  logger = Utility::Logger.new(station_id, working_directory)
  comparator = Utility::Comparator.new
  scraper = Scraper.new
  timestamp = DateTime.now
  filename = timestamp.to_s.gsub('+', '-').gsub(':', '-').gsub('T', ' ') + '.jpg'

  if comparator.check_if_within_scrape_time
    logger.log_start
    url = "#{URL_BASE}#{station_id}"
    panels = scraper.get_images(url)
    
    if panels.empty?
      logger.log_failed("PANELS_EMPTY")
    else
      panels.each.with_index { |uri, panel_index|
        directory = "#{working_directory}out/#{station_id}/#{panel_index}/#{timestamp.hour}"
        save = "#{directory}/#{filename}"
        if uri != DEFAULT_URI
          FileUtils::mkdir_p("#{directory}")
          File.open(save, 'wb') do |f|
            f.write(Base64.decode64(uri[IMAGE_PREFIX.length .. -1]))
            logger.log_success(save)
          end
        else
          logger.log_failed("#{panel_index},DEFAULT_URI")
        end
      }
    end
    logger.log_end
  else
    logger.log_failed("NOT_IN_TIME")
  end
end
