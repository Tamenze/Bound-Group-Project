##Bound

Bound is a web app built with NYC commuters in mind. When given your trip start and endpoints and your preferred genre of podcast, it gives you 

*   1) Directions (by public transport, bike, car, or foot)
*   2) A list of podcast suggestions that fit your trip time.

You can find a deployed version of this app [here](podbound.herokuapp.com).

## Tech
This app is built in Ruby on Rails, and uses the Google Maps and iTunes APIs. 

##Installation:
1. `git clone https://github.com/Tamenze/Bound-Group-Project.git`  
2. `cd` into Bound Group Project
3. run `bundle install`
4. sign up for a [Google Maps API key](https://developers.google.com/maps/documentation/javascript/get-api-key) and save it to your bash profile as `GOOGLE_MAPS_BOUND_KEY`
5. run `rails s`
6. point your browser to `localhost:3000`
