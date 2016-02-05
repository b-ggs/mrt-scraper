RUBY_EXECUTABLE = "/usr/bin/ruby"
PROJECT_DIRECTORY = "~/dev/mrt-scraper"
STORAGE_DIRECTORY = "~/dev/mrt-scraper/foobar"
STATION_ID = "taft-avenue"

every 1.minute do
  command "#{RUBY_EXECUTABLE} #{PROJECT_DIRECTORY}/mrt-scraper.rb -s #{STATION_ID} -d #{STORAGE_DIRECTORY}"
end

every 1.minute do
  command "sleep 30 && #{RUBY_EXECUTABLE} #{PROJECT_DIRECTORY}/mrt-scraper.rb -s #{STATION_ID} -d #{STORAGE_DIRECTORY}"
end
