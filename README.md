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
dfasdfk
## Usage

Follow the format as specified below:
```
Usage: ruby mrt-scraper.rb [options]
  -s, --station-id STATION_ID      STATION_ID as indicated in `STATION_IDS.md`.
  -l, --list-stations              List all possible STATION_IDs.
  -h, --help                       Show this help message.
```

For example:
```
$ ruby mrt-scraper.rb -s santolan-anapolis
```
