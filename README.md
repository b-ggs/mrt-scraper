# MRT Scraper
This was made to collect images from the DOTC MRT Line 3 live feed.

## Dependencies
Install the required gems.

```
$ bundle install
```

Make sure `libfontconfig` or your distro's equivalent is installed.

```
# apt-get install libfontconfig
```

## Usage

### Single usage
Follow the format as specified below in order to grab a single frame of from the live feed.
```
Usage: ruby mrt-scraper.rb [options]
    -s, --station-id STATION_ID      STATION_ID as indicated in `STATION_IDS.md`.
    -d, --directory DIRECTORY        Directory to save the images in.
    -l, --list-stations              List all possible STATION_IDs.
    -h, --help                       Show this help message.
```

For example:
```
$ ruby mrt-scraper.rb -s santolan-anapolis -d ~/foo
```

### Run as a cron job
Using the [whenever](https://github.com/javan/whenever) gem:

```
$ whenever --update-crontab
```

You can edit the default scheduling and directories at `config/schedule.rb`.
