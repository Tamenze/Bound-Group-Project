$(document).ready(function(){



$("#walk").click(function(){
  if ( $("#walk").css("display") == "inline-block");
    // $("#walk").css("opacity",0.3);
    document.getElementById("mode").innerHTML = "WALKING"
  });

$("#bus").click(function(){
  if ( $("#bus").css("display") == "inline-block");
    // $("#bus").css("opacity",0.3);
    document.getElementById("mode").innerHTML = "TRANSIT"
  });

$("#car").click(function(){
  if ( $("#car").css("display") == "inline-block");
    // $("#car").css("opacity",0.3);
    document.getElementById("mode").innerHTML = "DRIVING"
  });

$("#bike").click(function(){
  if ( $("#bike").css("display") == "inline-block");
    // $("#bike").css("opacity",0.3);
    document.getElementById("mode").innerHTML = "BICYCLING"
  });

$(".abc li a").click(function () {
    var t = $(this);
    var ul = t.closest('ul.abc');
    var selected = t.hasClass('selected');
    ul.find('li a').removeClass('selected');
    if (!selected)
        t.addClass('selected');
});

//BEGINNING MAP TO SHOW ON THE PAGE 
var map = new google.maps.Map(document.getElementById("map"), {
center: {lat: 40.7079502, lng: -74.0066584},
  zoom: 13
});


var subby = document.getElementById("sub_butt");

function map_out() {
var selectedMode = document.getElementById("mode").innerHTML;
console.log(selectedMode);
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
   origin: start, 
   destination: end,
   travelMode: google.maps.DirectionsTravelMode[selectedMode] //make this term a variable
};




directionsService.route(request, function(response, status) {
  if (status == google.maps.DirectionsStatus.OK) {
    var my_route = new google.maps.DirectionsRenderer({
    panel: document.getElementById("directions"),
    directions: response
    });

         // Display the distance:
     document.getElementById('distance').innerHTML += 
        ((response.routes[0].legs[0].distance.value)*.000621371).toFixed(2) + " miles";

     // Display the duration:
    var duration_in_minutes =Math.floor((response.routes[0].legs[0].duration.value)*.0166667)
     document.getElementById('duration').innerHTML += 
        duration_in_minutes + " minutes";

     directionsDisplay.setDirections(response);
     document.getElementsByName("durax")[0].value = duration_in_minutes
     // $("#duration").trigger("mapSucceed", duration_in_minutes)
  }
})

};

google.maps.event.addDomListener(subby, "click", map_out);

// $("input:checkbox").on('click',function(){
//   var $box = $this;
//   if ($box.is(":checked")){
//     var group = "input:checkbox[name='" + $box.attr("name") + "']";
//     $(group).prop("checked",false);
//     $box.prop("checked",true);
//   } else {
//     $box.prop("checked",false);
//   }  
//   });
var $check_boxes = $('input[type=checkbox]');

$check_boxes.click(function() {
  $check_boxes.prop('checked', false);
  $(this).prop('checked', true);
});
//http://stackoverflow.com/questions/10602576/rails-issue-with-using-jquery-to-select-only-one-checkbox-from-multiple

// function replace_with_duration(e, duration_in_minutes){
//   // alert("dflkgdlkgjs:" + duration_in_minutes)
// // var transfer = document.getElementById("duration").innerHTML.split(": ")[1];
// // // console.log(transfer);
// // var number = transfer.split(" ")[0];
// // // console.log(number);
// document.getElementsByName("durax")[0].value = duration_in_minutes
// // console.log(document.getElementsByName("durax")[0].value);
// }

// $("#duration").on("mapSucceed", replace_with_duration);
// on click of bound, form gets repopulated with duration AND changes from hidden to displayed
 

});
