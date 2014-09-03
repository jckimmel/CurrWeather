command: "python CurrWeather/weather_uber.py"

refreshFrequency: 300000

style: """
  
	position: absolute
  	top: 0%
  	left: 0%
	color: #000
	font-size: 48px
	font-family: Mistral

	.icon   	
   		height = 80px
   		width = 50px

	.output, .now, .tomorrow
		padding: 10px
		position: Relative
		width: 1000px
		top: -40px
		left: 10%
    	font-weight: lighter
	  		font-smoothing: antialiased

  

"""

render: (output) -> """
	<div class="icon"></div>
	<div class="output">
		<div class="now"></div>
		<div class="tomorrow"></div>

		</div>
   
"""

update: (output, domEl,imageURL) ->

	dom = $(domEl)
	xml = jQuery.parseXML(output)
	$xml = $(xml)	
	# description = jQuery.parseHTML($xml.find('description').eq(1).text())
	description = jQuery.parseHTML($xml.find('description').eq(1).text())
	$description = $(description)

	# -------------------------------------------------------------
	# current conditions
		
	$condition = $xml.find('yweather\\:condition,condition')
	
	$text = $condition.attr('text')
	$temp = $condition.attr('temp')
	
	report = $text + ", " + $temp + "F"

	#--------------------------------------------------------------
	# Tomorrow Forecast
	
	item = $xml.find('item')
	$item = $(item)

	$forecast = $item.find('yweather\\:forecast,forecast').eq(0)
	
	$day = $forecast.attr('day')
	$cond = $forecast.attr('text')
	$high = $forecast.attr('high')
	$low = $forecast.attr('low')
	
	tomorrow = $day + ": " + $cond + ", " + $high + " | " + $low

	
	# -------------------------------------------------------------
	# Get current date. Prep for Sunrise and Sunset
	
	now = new Date()
	
	today = (now.getMonth() + 1) + "/" + now.getDate() + "/" + now.getFullYear()
	
	$astronomy = $xml.find('yweather\\:astronomy,astronomy')

	
	# -------------------------------------------------------------
	# Get Sunrise time into date format
	
	$sunrisetime = $astronomy.attr('sunrise')
	pos = $sunrisetime.indexOf ":",0
	
	hours = $sunrisetime.charAt pos-1
	if (pos > 1) then hours = $sunrisetime[0..1]	
	
	len = $sunrisetime.length
	AMPM = $sunrisetime[len-2..len]
	
	if (AMPM == "pm") then hours = hours + 12
	
	sHours = String(hours)
	
	if (hours < 10) then sHours = "0" + sHours		
	
	minutes = $sunrisetime[pos+1..pos+2]
	sMinutes = String(minutes)
	temp = today + " " + sHours + ":" + sMinutes
	
	start = new Date(temp)

	#------------------------------------------------------------
	# Get Sunset time into date format
	
	$sunsettime = $astronomy.attr('sunset')

	pos = $sunsettime.indexOf ":",0
	hours = $sunsettime.charAt pos-1
	
	if (pos > 1) then hours = $sunsettime[0..1]	
	len = $sunrisetime.length
	AMPM = $sunsettime[len-2..len]
	
	if (AMPM == "pm") then hours = Number(hours) + 12
	
	sHours = String(hours)
	
	if (hours < 10) then sHours = "0" + sHours		
	
	minutes = $sunsettime[pos+1..pos+2]
	sMinutes = String(minutes)
	temp = today + " " + sHours + ":" + sMinutes
	end = new Date(temp)

			
	#--------------------------------------------------------------
	# get imagecode
	
	$imagecode = $condition.attr('code')

	
	dt = "n"
	
	if (now > start and now < end)	then dt = "d"
	
	imageURL = "http://l.yimg.com/a/i/us/nws/weather/gr/#{$imagecode}#{dt}.png"
		
	imagehtml = "<img src='"+imageURL+"'/>"
	# -------------------------------------------------------------
	# set output		
	dom.find('.icon').html imagehtml
	dom.find('.now').html report
	dom.find('.tomorrow').html tomorrow
