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
    # p "object #{index}"
          if object['feedUrl']
    # p object['feedUrl']
            @rss = object['feedUrl']
            #insert logic that if feedurl contains "feed.theplatform", don't add format
            if @rss.match('feed.theplatform') || @rss.match('feed=podcast')
              @rss = object['feedUrl']
            else
              @rss = object['feedUrl'] + "?format=xml"
            end
          
          else
            next
          end
          # @rss = object['feedUrl']
          # #insert logic that if feedurl contains "feed.theplatform", don't add format
          # if @rss.match('feed.theplatform') || @rss.match('feed=podcast')
          #   @rss = object['feedUrl']
          # else
          #   @rss = object['feedUrl'] + "?format=xml"
          # end
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
                  
              end
              @results_to_display = @results_to_sort.sort_by{|x| x[:podcast_time] }.reverse! 

          end 
  # p @results_to_display
              if @results_to_display.empty? 
                  @failed_match = "No podcasts match your query :("
                  @genre_term = nil
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