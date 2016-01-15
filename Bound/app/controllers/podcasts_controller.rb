require'open-uri'
require 'Nokogiri'
require 'chronic_duration'

class PodcastsController < ApplicationController

  def index
  end

  def search
    @genre_term = params.keys[2]
    
      if @genre_term.include? "_" 
        @genre_term = @genre_term.gsub("_"," ").split(" ").map(&:capitalize).join(" ")
      end
      
      if (params[:durax] != nil) && (@genre_term != "commit")
      
      @triptime = params[:durax]
      @results = ITunesSearchAPI.search(:term=> @genre_term, :country => "US", :entity=> "podcast", :media => "podcast", :limit => 15) #if this is more than 15 for tech, it breaks.. for comedy 25 works. need to figure out why & fix. 

            #thinking of replacing term symbol with a genre_id symbol (:genreId) => 1402 
              #check this in irb first
              #to implement, i would need to change the text part in the checklist where it used to get fed into @genreterm to the right numbers (according to itunes )
                  #ISSUEEEE: TERM IS A REQUIRED ATTRIBUTE OF THE SEARCH, NEED TO FIGURE OUT HOW TO MAKE IT EMPTY OR apply to alll


      #plan a) work out the splits and substitutions on lines 13-15, likely in comparison to the itunes podcast genre list(?)
      #plan b) maybe just put different terms in the checklist, that are more searchable
      @results_to_display = []
      @results_to_sort = []

        if @results
          @results.each_with_index do |object, index|
          @cool = object['feedUrl'] + "?format=xml"
          @doc = Nokogiri::XML(open(@cool))
          

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