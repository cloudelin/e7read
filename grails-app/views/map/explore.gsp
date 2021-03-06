<!DOCTYPE html>
<html>
<head>
<meta name="layout" content="jqm14" />
<script src="https://maps.googleapis.com/maps/api/js?v=3.exp&libraries=places"></script>
<script src="http://google-maps-utility-library-v3.googlecode.com/svn/tags/markerwithlabel/1.1.9/markerwithlabel/src/markerwithlabel_packed.js"></script>
<!--<script type="text/javascript" src="http://maps.googleapis.com/maps/api/js?key=${grailsApplication.config.google.api.key}&sensor=false"></script>-->
<meta name="e7read-default-icon" content="${assetPath(src: 'e7logo-marker-icon1-48x48.png', absolute: true)}" />
<meta name="e7read-search-content-api-url" content="${createLink(controller: 'search', action: 'content')}" />
<link href="//maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css" rel="stylesheet" />
<link href="/jquery-mobile-theme/themes/e7read.min.css" rel="stylesheet" />
<style type="text/css">
body { overflow: hidden; }
.ui-panel-wrapper, .map-container { width: 100%; height: 100%; padding: 0; }
#map-page {width: 100%; height: 100%; }
#map-canvas { width: 100%; height: 100%; }
.controls {
    margin-top: 25px;
    border: 1px solid transparent;
    border-radius: 2px 0 0 2px;
    box-sizing: border-box;
    -moz-box-sizing: border-box;
    height: 24px;
    outline: none;
    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.3);
}

#pac-input {
    background-color: #fff;
    padding: 0 7px 0 7px;
    width: 260px;
    font-family: Roboto;
    font-size: 11px;
    font-weight: 300;
    text-overflow: ellipsis;
    opacity: .7;
}

#pac-input:focus {
    border-color: #4d90fe;
    margin-left: -1px;
    padding-left: 8px;  /* Regular padding-left + 1. */
    width: 261px;
    opacity: 1;
}

.pac-container {
    font-family: Roboto;
}

#type-selector {
    color: #fff;
    background-color: #4d90fe;
    padding: 5px 11px 0px 11px;
}

#type-selector label {
    font-family: Roboto;
    font-size: 13px;
    font-weight: 300;
}

#nav-panel {
    box-shadow: none;
}

.ui-btn-flat {
    border: none !important;
    box-shadow: none !important;
}
.labels {
    color: #333;
    background-color: white;
    font-family: "Lucida Grande", "Arial", sans-serif;
    font-size: 11px;
    font-weight: bold;
    text-align: center;
    width: auto;
    max-width: 100px;
    text-overflow: ellipsis;
    border: none;
    white-space: nowrap;
    opacity: .75;
}

.extra-map-options {
    color: #333;
    padding: 5px;
}
</style>
</head>
<body>
<div data-role="page" data-theme="c" id="map-page" class="ui-responsive-panel">
    <div data-role="header" data-position="fixed" class="map-header">
        <g:link uri="/" data-icon="home" rel="external" class="btnBack">Back</g:link>
        <h1>E7READ Explore</h1>
        <a href="#nav-panel" data-icon="bullets" rel="external" class="ui-btn ui-btn-icon-notext ui-corner-all">
            <i class="fa fa-play"></i>
        </a>
    </div>
    <div data-role="main" class="ui-content map-container">
        <div id="map-canvas"></div>
    </div>
    <!--
    <div data-role="footer" data-position="fixed" class="map-footer">
        <input id="pac-input" class="controls" type="text" placeholder="Search Box"/>
    </div>
    -->
    <div data-role="panel" id="nav-panel" data-position="right">
        <ul data-role="listview" data-icon="false">
            <li data-icon="delete">
                <a href="#" data-rel="close">分類</a>
            </li>
            <g:each in="${categories}" var="category">
                <li>
                    <a href="#" class="category-menu-item" data-category="${category.name}">
                        <i class="fa fa-map-marker"></i>&nbsp;&nbsp;
                        <g:message code="category|${category.name}" default="${category.name}" />
                    </a>
                </li>
            </g:each>
        </ul>
    </div><!-- /panel -->
</div>
<script type="text/javascript">
$( document ).on( "pageinit", "#map-page", function() {

    var myLatlng = new google.maps.LatLng(${lat}, ${lon});

    if (typeof(Storage) != "undefined") {
        var lastCenterLat = parseFloat(localStorage.getItem('map.explorer.center.lat'));
        var lastCenterLon = parseFloat(localStorage.getItem('map.explorer.center.lon'));

        if (lastCenterLat && lastCenterLon) {
            myLatlng = new google.maps.LatLng(lastCenterLat, lastCenterLon);
        }
    }

    var mapStyle = ${raw(mapStyleContent)};

    var mapOptions = {
        center: myLatlng,
        zoom: ${zoom},
        mapTypeId: google.maps.MapTypeId.ROADMAP,
        styles: mapStyle,
        mapTypeControl: true,
        mapTypeControlOptions: {
            style: google.maps.MapTypeControlStyle.DROPDOWN_MENU
        },
        zoomControl: true,
        zoomControlOptions: {
            style: google.maps.ZoomControlStyle.SMALL
        }
    };

    var map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);

    // make content layout for info window display
    var makeHtmlContent = function(content) {

        var box = $('<div class="row" />');

        var left = $('<div class="col-sm-4" />');

        var a = $('<a target="blank" />').attr('href', content.shareUrl);
        a.append($('<img align="left" alt="cover" border="0" class="img-thumbnail img-responsive" style="max-width: 200px; max-height: 200px; padding: 10px;" />').attr('src', content.coverUrl));

        left.append(a);

        box.append(left);

        var right = $('<div class="col-sm-8" />');

        right.append($('<h4 style="color:#333;"/>').text(content.cropTitle));
        right.append($('<p style="color:#333;"/>').text(content.cropText));
        right.append($('<a target="blank" style="font-size: 1.1em;" />').attr('href', content.shareUrl).text('read more...'));

        box.append(right);

        return box.html();
    };

    var searchMarkers = [];

    var clearLatestSearch = function() {
        for (var i = 0, marker; marker = searchMarkers[i]; i++) {
            marker.setMap(null);
        }
        searchMarkers = [];
    };

    var __SEARCH_CONTENT_API_URL = $('meta[name=e7read-search-content-api-url]').attr('content');

    var radar = null;

    var showRadar = function(center) {
        // Clear previous radar
        if (radar != null) {
            radar.setMap(null);
        }

        if (center == null) {
            center = map.getCenter();
        }

        if ($('input#isEnableRadar').is(':checked')) {
            var radarOptions = {
                strokeColor: 'rgb(148, 230, 218)',
                strokeOpacity: 0.45,
                strokeWeight: 1,
                fillColor: 'rgb(148, 230, 218)',
                fillOpacity: 0.2,
                map: map,
                center: center,
                radius: 10 * 1000
            };

            radar = new google.maps.Circle(radarOptions);
        }
    };

    // show marker in google map
    var searchByLocation = function(channel, category) {

        console.log('request for search results...');

        var center = map.getCenter();

        showRadar(center);

        var queryData = {
            channel: channel,
            c: category,
            geo: center.lat() + "," + center.lng(),
            distance: 10
        };

        $.get(__SEARCH_CONTENT_API_URL, queryData).done(function(data) {
            if (!data) { return; }

            // Clear previous search results
            clearLatestSearch();

            var infowindow = new google.maps.InfoWindow();

            var marker;

            for (var i = 0; i < data.length; i++) {

                var content = data[i];

                var markerIcon = {
					url: content.iconUrl?content.iconUrl:$('meta[name=e7read-default-icon]').attr('content'),
					size: new google.maps.Size(38, 38),
					scaledSize: new google.maps.Size(38, 38)
				};

                var config = {
                    position: new google.maps.LatLng(
                            content.location.lat, /* + (Math.random()/500), */
                            content.location.lon  /* + (Math.random()/500)  */
                    ),
                    map: map,
                    title: content.cropTitle,
                    draggable: false,
                    /*animation: google.maps.Animation.DROP,*/
                    icon: markerIcon,
                    labelContent: content.cropTitle,
                    labelAnchor: new google.maps.Point(-10, 15),
                    labelClass: "labels",
                    labelStyle: {opacity: 0.75}
                };

                if ($('input#isEnableCaption').is(':checked')) {
                    // with caption
                    marker = new MarkerWithLabel(config);
                }
                else {
                    // without caption
                    marker = new google.maps.Marker(config);
                }

                searchMarkers.push(marker);

                google.maps.event.addListener(marker, 'click', (function(marker, html) {

                    return function() {
                        infowindow.setContent(html);
                        infowindow.open(map, marker);

                        console.log(marker);
                    };
                })(marker, makeHtmlContent(content)));
            }
        });
    };

    var currentChannel = $('meta[name=params-channel]').attr('content');
    searchByLocation(currentChannel, '*');

    /*
     * re-search with category filter
     */
    $('.category-menu-item').unbind('click').click(function() {
        var category = $(this).data('category');
        searchByLocation(currentChannel, category);
        return false;
    });

    $('.btnBack').unbind('click').click(function() {
        history.back();
        return false;
    });

    var searchBox;

    (function() {
        // add search box
        var elm = $('<input id="pac-input" class="controls" type="text" placeholder="Search Box" style="display: none">');

        elm.appendTo($('#map-canvas'));

        map.controls[google.maps.ControlPosition.TOP_LEFT].push(elm.get(0));

        searchBox = new google.maps.places.SearchBox(elm.get(0));

        setTimeout(function() {
            elm.show(200);
        }, 1000);
    })();

    (function() {
        var elm = $('<label class="extra-map-options"><input id="isEnableRadar" type="checkbox" /> 雷達</label>');

        elm.appendTo($('#map-canvas'));

        elm.click(function() {
            showRadar();
        });

        map.controls[google.maps.ControlPosition.TOP_RIGHT].push(elm.get(0));

    })();

    (function() {
        var elm = $('<label class="extra-map-options"><input id="isEnableCaption" type="checkbox" /> 標題</label>');

        elm.appendTo($('#map-canvas'));

        elm.click(function() {
            searchByLocation(currentChannel, '*');
        });

        map.controls[google.maps.ControlPosition.TOP_RIGHT].push(elm.get(0));

    })();

    var placesMarkers = [];

    google.maps.event.addListener(searchBox, 'places_changed', function() {
        var places = searchBox.getPlaces();

        if (places.length == 0) {
            return;
        }

        for (var i = 0, marker; marker = placesMarkers[i]; i++) {
            marker.setMap(null);
        }

        placesMarkers = [];

        var bounds = new google.maps.LatLngBounds();

        var lastLocation;

        for (var i = 0, place; place = places[i]; i++) {
            var image = {
                url: place.icon,
                size: new google.maps.Size(71, 71),
                origin: new google.maps.Point(0, 0),
                anchor: new google.maps.Point(17, 34),
                scaledSize: new google.maps.Size(25, 25)
            };

            var marker = new google.maps.Marker({
                map: map,
                icon: image,
                title: place.name,
                position: place.geometry.location
            });

            placesMarkers.push(marker);

            bounds.extend(lastLocation = place.geometry.location);
        }

        //map.fitBounds(bounds);

        map.setCenter(lastLocation);

        searchByLocation(currentChannel, '*');
    });

    google.maps.event.addListener(map, 'bounds_changed', function() {
        var bounds = map.getBounds();
        searchBox.setBounds(bounds);

        //searchByLocation(currentChannel, '*');

    });

    google.maps.event.addListener(map, 'dragstart', function() {
        // Clear previous radar
        if (radar != null) {
            radar.setMap(null);
        }
    });

    google.maps.event.addListener(map, 'dragend', function() {
        searchByLocation(currentChannel, '*');

        var center = map.getCenter();
        console.log(center);
        if (typeof(Storage) != "undefined") {
            localStorage.setItem('map.explorer.center', center);
            localStorage.setItem('map.explorer.center.lat', center.lat());
            localStorage.setItem('map.explorer.center.lon', center.lng());
        }
    });

});
</script>
</body>
</html>