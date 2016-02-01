URL_BASE = 'https://dotcmrt3.gov.ph/cctv'
IMAGE_PREFIX = 'data:image/jpeg;base64,'
PATH = '//div[@class=\'cctv-thumbnail\']/img/@src'
STATION_BASE = 'Station'
STATION_IDS = [
  'north-avenue',
  'quezon-avenue',
  'gma-kamuning',
  'cubao',
  'santolan-anapolis',
  'ortigas',
  'shaw-boulevard',
  'boni-avenue',
  'guadalupe',
  'buendia',
  'ayala-avenue',
  'taft-avenue',
]
DEFAULT_IMAGE = '/assets/svg/cctv-not-accessible.svg'
VISIT_WAIT = 5
SCRAPE_TIMES = [
  [5, 25],
]
SCRAPE_INTERVAL = 120
