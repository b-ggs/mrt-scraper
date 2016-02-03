module Utility
  class Logger 
    def log(str)
      stamp = DateTime.now
      File.open('log', 'a') { |f|
        f.puts("#{stamp} - #{str}")
      }
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
