package kgl

import grails.plugin.springsecurity.annotation.Secured

class MapController {

    def index() {}

    def explore() {

        def lat = session['geolocation']?.lat
        def lon = session['geolocation']?.lon
        def zoom = 15

        if (lat == null || lon == null) {
            lat = message(code: 'default.location.lat').toDouble()
            lon = message(code: 'default.location.lon').toDouble()
            zoom = 12
        }

        if (params.center) {
            def latlon = params.center.split(',')

            lat = latlon[0].toString().toDouble()
            lon = latlon[1].toString().toDouble()
        }

        [
                lat: lat,
                lon: lon,
                zoom: zoom
        ]
    }
	
	def content(Content content) {
		[
			lat: (content.location?.lat)?:25,
			lon: (content.location?.lon)?:121,
			zoom: 15,
			content: content
		]
	}
}
