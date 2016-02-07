RUBY_EXECUTABLE = "/usr/bin/ruby"
PROJECT_DIRECTORY = "~/dev/mrt-scraper"
STORAGE_DIRECTORY = "~/dev/mrt-scraper/foobar"
STATION_IDS = [
  "taft-avenue",
  "santolan-anapolis",
  "shaw-boulevard",
]

STATION_IDS.each { |station_id|
  every 1.minute do
    command "#{RUBY_EXECUTABLE} #{PROJECT_DIRECTORY}/mrt-scraper.rb -s #{station_id} -d #{STORAGE_DIRECTORY}"
  end

  every 1.minute do
    command "sleep 30 && #{RUBY_EXECUTABLE} #{PROJECT_DIRECTORY}/mrt-scraper.rb -s #{station_id} -d #{STORAGE_DIRECTORY}"
  end
}
