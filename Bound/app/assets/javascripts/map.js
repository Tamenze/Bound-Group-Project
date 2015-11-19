$(document).ready(function(){
 //-html form for start and end point
//-get elements from those places and use them in the google function



// I NEED A BEGINNING MAP TO SHOW ON THE PAGE-THEN WHEN THE USER ENTERS INFO, 
// THE MAP BECOMES THE NEW ISH

//right now it's running on the window load. want my stuff to run when the user 
//clicks submit. so have a default map, and then change the listener to submit //button, click, initialize. 

var subby = document.getElementById("sub_butt");

function initialize() {
var start = document.getElementsByName("start_point")[0].value;
var end = document.getElementsByName("end_point")[0].value;


var directionsService = new google.maps.DirectionsService();
var directionsDisplay = new google.maps.DirectionsRenderer();


var myOptions = {
 zoom:7,
 mapTypeId: google.maps.MapTypeId.ROADMAP
}

var map = new google.maps.Map(document.getElementById("map"), myOptions);
directionsDisplay.setMap(map);

var request = {
   // origin: '185 Wortman Avenue, Brooklyn NY', 
   // destination: '90 John Street',
   origin: start,
   destination: end,
   travelMode: google.maps.DirectionsTravelMode.TRANSIT
};

directionsService.route(request, function(response, status) {
  if (status == google.maps.DirectionsStatus.OK) {

     // Display the distance:
     document.getElementById('distance').innerHTML += 
        ((response.routes[0].legs[0].distance.value)*.000621371).toFixed(2) + " miles";

    var duration_in_minutes =Math.floor((response.routes[0].legs[0].duration.value)*.0166667)
     // Display the duration:
     document.getElementById('duration').innerHTML += 
        duration_in_minutes + " minutes";

     directionsDisplay.setDirections(response);
  }
})
};

google.maps.event.addDomListener(subby, "click", initialize);


function replace_with_duration(){
var transfer = document.getElementById("duration").innerHTML.split(": ")[1];
// console.log(transfer);
var number = transfer.split(" ")[0];
// console.log(number);
document.getElementsByName("durax")[0].value = number;
// console.log(document.getElementsByName("durax")[0].value);

}

$("#bound_butt").click(replace_with_duration);
// on click of bound, form gets repopulated with duration AND changes from hidden to displayed
  


});