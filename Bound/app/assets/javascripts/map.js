function initialize() {
var directionsService = new google.maps.DirectionsService();
var directionsDisplay = new google.maps.DirectionsRenderer();

var myOptions = {
 zoom:7,
 mapTypeId: google.maps.MapTypeId.ROADMAP
}

var map = new google.maps.Map(document.getElementById("map"), myOptions);
directionsDisplay.setMap(map);

var request = {
   origin: '185 Wortman Avenue, Brooklyn NY', 
   destination: '90 John Street',
   travelMode: google.maps.DirectionsTravelMode.TRANSIT
};

directionsService.route(request, function(response, status) {
  if (status == google.maps.DirectionsStatus.OK) {

     // Display the distance:
     document.getElementById('distance').innerHTML += 
        ((response.routes[0].legs[0].distance.value)*.000621371) + " miles";

    var dur_time = ((response.routes[0].legs[0].duration.value)*0.000277778)

     // Display the duration:
     document.getElementById('duration').innerHTML += 
        dur_time + " hours";

     directionsDisplay.setDirections(response);
  }
})
};
google.maps.event.addDomListener(window, "load", initialize);



