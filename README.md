# Swarm MRT Scraper
This was made to collect images from the DOTC MRT Line 3 live feed.

# Dependencies
Install the required gems.

    $ gem install capybara phantomjs poltergeist

Specifically for headless instances.

    # apt-get install libfontconfig

# Usage
If you want to have this running in the background, I recommend you use screen or tmux.

    $ screen -S scraper

Run the never-ending shell script.

    $ ./run.sh

Check if everything's running correctly by looking at the logs.

    $ cat log
