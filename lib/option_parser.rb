class OptionParser
  def self.parse(options)
    args = {}
    is_valid = false
    option_parser = OptionParser.new do |parser|
      parser.banner = "Usage: ruby mrt-scraper.rb [options]"
      parser.on("-s", "--station-id STATION_ID", "STATION_ID as indicated in `STATION_IDS.md`.") { |v| 
        args[:station_id] = v 
        is_valid = true
      }
      parser.on("-l", "--list-stations", "List all possible STATION_IDs.") {
        puts File.read('STATION_IDS.md')
        is_valid = true
      }
      parser.on("-h", "--help", "Show this help message.") {
        puts(parser)
        is_valid = true
      }
    end
    option_parser.parse!

    unless is_valid
      option_parser.parse("-h")
    end
    
    args
  end
end
