require'open-uri'
require 'nokogiri'
require 'chronic_duration'

class PodcastsController < ApplicationController
  def search
    @genre_term = params.keys[2]
      if @genre_term.include? "_" 
      @genre_term = @genre_term.gsub("_"," ").split(" ")[0]
      end
  # p @genre_term 

    if (params[:triptime] != nil) && (@genre_term != "commit")
        @triptime = params[:triptime]
        @results = ITunesSearchAPI.search(:term=> @genre_term, :country => "US", :entity=> "podcast", :media => "podcast", :limit => 15) 
        @results_to_display = []
        @results_to_sort = []

        if @results != nil
          @results.each_with_index do |object, index|
          @rss = object['feedUrl']
          #insert logic that if feedurl contains "feed.theplatform", don't add format
          if @rss.match('feed.theplatform') || @rss.match('feed=podcast')
            @rss = object['feedUrl']
          else
            @rss = object['feedUrl'] + "?format=xml"
          end
  # p @rss
          @doc = Nokogiri::XML(open(@rss))
          @raw_duration_parse = @doc.xpath('//itunes:duration', 'itunes'=> 'http://www.itunes.com/dtds/podcast-1.0.dtd')
          if @raw_duration_parse && !(@raw_duration_parse.empty?) && @raw_duration_parse.first 
            @raw_content = @raw_duration_parse.first.content
          else
            @raw_duration_parse = "" 
            @raw_content = ""
          end
  # puts "raw dur parse:"       
  # p @raw_duration_parse
  # puts "raw content of first node"
  # p @raw_content
          if !(@raw_duration_parse.empty?) && !(@raw_content.empty?) 
          @raw_time = ChronicDuration.parse((@raw_duration_parse).first.content)
  # puts "chroniced content:"
  # p @raw_time
            if @raw_time != nil
            @podtime = (@raw_time)/60 + 1
            end 

          else
          @podtime = nil
          end
           # @podtime = ChronicDuration.parse(@doc.xpath('//itunes:duration', 'itunes'=> 'http://www.itunes.com/dtds/podcast-1.0.dtd').first.content)

           # issue: sometimes there is no duration tag in an xml feed, so then there is nothing to call .first or .content on. 
           # solution: make xpath results a variable, and then only if that variable is not nil, do the .first.content and chronic dur parsing
  # puts "podtime:"
  # p @podtime

      
          #make a hash out of above info, and compare it to @triptime. if less than triptime, delete current results object from the results array 

          #this is different from the other method because before, i was making an instance variable of time for each podcast, and then comparing each time to triptime, and then trying to delete the result at the same index in the results array as the time (in the time/durations array)

          #NEED TO CONVERT THE TIMES TO INTEGERS SO I CAN DO A COMPARISON 
              if @podtime !=nil && @podtime.to_i < @triptime.to_i
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
  # p @results_to_display
              if @results_to_display.empty?
                  @failed_match = "No podcasts match your query :("
              end

        else
          @failed_match = "No podcasts match your query :("
          @genre_term = nil
        end #end of @results if/else

    end #params check end

    respond_to do |format|
      format.js #for rendering search results in same page using js partial
    end

  end #search method end

end