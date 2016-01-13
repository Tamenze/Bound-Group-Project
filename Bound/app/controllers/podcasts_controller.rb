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
      
      
      if (params[:durax] != nil) && (@genre_term != "commit") && @podcasts != []
      
      @triptime = params[:durax]
      @results = ITunesSearchAPI.search(:term=> @genre_term, :country => "US", :entity=> "podcast", :media => "podcast", :limit => 15)
      # @durations = []
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
                    rss_feed: object["feedUrl"],
                    collection_view: object["collectionViewUrl"],
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