require'open-uri'
require 'Nokogiri'
require 'chronic_duration'

class PodcastsController < ApplicationController

  def test_empty
  @empty = ""
  @page = HTTParty.get("https://itunes.apple.com/search?term=" + @empty + "&country=US&media=podcast&entity=podcast&genreID=1303&sort=recent")
  end
  
  def index
      #create rakefile that prepopulates an amount of available podcasts in each genre (maybe 50 from each?)
        #but then i would have to create records in the database, and change the search method to look through the database. 
        #I THINK THAT'S TOO MUCH WORK FOR SOMETHING THAT DOESNT WORK WELL ANYWAY, SO  I THINK I'LL JUST CLEAN UP THE UX, FIX THE GENRES THAT DONT WORK, AND GO FROM THERE. 
          #TO FIX THOSE GENRES.....? genre id comes to mind but i dont remember if that works in the regular search api (the non lookup one)
  end

# https://itunes.apple.com/search?term=round&country=US&media=podcast&entity=podcast&genreID=1303&sort=recent

  # def search
  #   @initial_genre = params.keys[2]
  #   @genre_term = @initial_genre.gsub("_"," ").split(" ").map(&:capitalize).join(" ")
  #   if (params[:durax] !=nil) && (@genre_term != "commit")
  #     @triptime = params[:durax]
  #     @results = ITunesSearchAPI.search(:term=> "%20%", :country => "US", :entity=> "podcast", :media => "podcast", :limit => 15)

#OK I CAN SEARCH USING GENREID. SO ADD CODES OF SUBGENRES TO THE CHECKLIST, GET AND USE IT FROM THE PARAMS
#REMAINING ISSUE:
  # GETTING SEARCH TO WORK WITH AN EMPTY TERM SPACE. %20% DOESNT WORK, A SIMPLE SPACE DOESN'T WORK, A QUOTED SPACE DOESN'T WORK, A COMMON LETTER STRING DOESN'T WORK. 

  def search
    @genre_term = params.keys[2]
    # p @genre_term
      # if @genre_term.include? "_" 
        @genre_term = @genre_term.gsub("_"," ").split(" ").map(&:capitalize).join(" ")
      # end
    # p @genre_term 
      if (params[:durax] != nil) && (@genre_term != "commit")
      
      @triptime = params[:durax]
      @results = ITunesSearchAPI.search(:term=> @genre_term, :country => "US", :entity=> "podcast", :media => "podcast", :limit => 15) #if this is more than 15 for tech, it breaks.. for comedy 25 works. need to figure out why & fix. 

        #MUST BE RETURNING NIL WHEN IT DOESNT WORK, IF ELSE STATEMENT:
          # if @results != nil 
            #do below 

            #thinking of replacing term symbol with a genre_id symbol (:genreId) => 1402 
              #check this in irb first
              #to implement, i would need to change the text part in the checklist where it used to get fed into @genreterm to the right numbers (according to itunes )
                  #ISSUEEEE: TERM IS A REQUIRED ATTRIBUTE OF THE SEARCH, NEED TO FIGURE OUT HOW TO MAKE IT EMPTY OR apply to alll


      #plan a) work out the splits and substitutions on lines 13-15, likely in comparison to the itunes podcast genre list(?)
      #plan b) maybe just put different terms in the checklist, that are more searchable
      @results_to_display = []
      @results_to_sort = []

        if @results != nil
          @results.each_with_index do |object, index|
          @cool = object['feedUrl'] + "?format=xml"
          @doc = Nokogiri::XML(open(@cool))
          # @doc = Nokogiri::XML(@cool)

          @podtime = ((ChronicDuration.parse(@doc.xpath('//itunes:duration', 'itunes'=> 'http://www.itunes.com/dtds/podcast-1.0.dtd').first.content))/60)+1

      
          #make a hash out of above info, and compare it to @triptime. if less than triptime, delete current results object from the results array 

          #this is different from the other method because before, i was making an instance variable of time for each podcast, and then comparing each time to triptime, and then trying to delete the result at the same index in the results array as the time (in the time/durations array)

          #NEED TO CONVERT THE TIMES TO INTEGERS SO I CAN DO A COMPARISON 
              if @podtime.to_i < @triptime.to_i
                # @results.delete_at(index) 
                  #@results_to_display << Hash[ #an array of hashes
                  @results_to_sort << Hash[
                    track_name: object["trackName"],
                    artist_name: object["artistName"],
                    podcast_time: @podtime,
                    track_view: object["trackViewUrl"],
                    release_date: object["releaseDate"], #format the time on this 
                    rss_feed: object["feedUrl"],
                    genre: object["primaryGenreName"],
                    icon: object["artworkUrl100"]
                  ]
                  
                  # @durations << @podtime #only adds the podtime to the durations array if it is less than the triptime
              # else
                    #IF PODTIME IS NOT LESS THAN TRIPTIME, I WOULD WANT TO REMOVE THE ASSOCIATED RESULT FROM THE LIST
                # @results.delete_at(index) 
              end
              @results_to_display = @results_to_sort.sort_by{|x| x[:podcast_time] }.reverse! 
          end 


        else
          @failed_match = "No podcasts match your query :("
        end #end of @results if/else

      end
  
  end #search method end

end