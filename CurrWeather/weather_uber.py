#!/usr/bin/env python

import urllib2
import json


URL = "http://freegeoip.net/json/"

json_raw = urllib2.urlopen(URL).read()
json_parsed = json.loads(json_raw)


for k,v in json_parsed.items():
	if str(k) == "zipcode":
		postal = str(v)
		
#postal = json_encoded.zipcode.text

#print postal

# curl --silent "http://weather.yahooapis.com/forecastrss?p=$postal&u=f" curl -s http://freegeoip.net/json/ | awk '/zipcode/{print $2}' |

# Get weather forecast for location

YURL = "http://weather.yahooapis.com/forecastrss?p=%s&u=f"

site = urllib2.urlopen(YURL % (postal))
xml = site.read()
site.close()

print xml