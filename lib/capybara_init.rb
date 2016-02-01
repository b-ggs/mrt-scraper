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
