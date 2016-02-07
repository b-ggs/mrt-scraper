module Utility
  class Logger 
    def initialize(id, directory = "")
      @id = id
      @directory = directory
    end

    def log(str)
      stamp = DateTime.now.to_s.gsub('+', ' ').gsub(':', '-').gsub('T', ' ')
      File.open("#{@directory}log-#{@id}", 'a') { |f|
        f.puts("#{stamp} - #{str}")
      }
    end

    def log_start
      log("Attempting scrape on #{@id}.")
    end

    def log_end
      log("Ending scrape on #{@id}.")
    end

    def log_failed(error)
      log("FAIL: Scrape failed on #{@id}. (#{error})")
    end

    def log_success(path)
      log("SUCCESS: Scraped #{path}.")
    end
  end
  class Comparator
    def check_if_within_scrape_time
      response = false
      within_scrape = SCRAPE_TIMES.each { |scrape_time|
        from = scrape_time[0]
        to = scrape_time[1]
        hour = Time.now.hour
        if from <= hour && hour < to
          response = true
        end
      }
      response
    end
  end
end
