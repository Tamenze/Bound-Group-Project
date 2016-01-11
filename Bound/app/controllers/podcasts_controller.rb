# require 'rubygems'
require'open-uri'
require 'Nokogiri'

class PodcastsController < ApplicationController

  def index
  end

  def search
    @genre_term = params.keys[2]
    
      if @genre_term.include? "_" 
        @genre_term = @genre_term.gsub("_"," ").split(" ").map(&:capitalize).join(" ")
      end
      # @podcasts = Podcast.search((@genre_term),params[:durax]).order("created_at DESC")  
      
      if (params[:durax] != nil) && (@genre_term != "commit") && @podcasts != []
     #      @podcasts 
    	# else
    	# @failed_match = "No podcasts match your query :("
     #  end

      @results = ITunesSearchAPI.search(:term=> @genre_term, :country => "US", :entity=> "podcast", :media => "podcast", :limit => 10)

        if @results
          @results.each do |x|
          
          @cool = x['feedUrl'] + "?format=xml"
              @doc = Nokogiri::XML(open(@cool))
           @duration = @doc.xpath('//itunes:duration', 'itunes'=> 'http://www.itunes.com/dtds/podcast-1.0.dtd').first.content
           # @doc.xpath('//duration').each do |duration|

           #write if/else that grabs dates from <pubDate> tags and gets the duration from only the most recent one(s?)

            #if i change @doc to open in html, then the duration query works even though i don't see them on the page 
          end
        end
    # else
    # @failed_match = "No podcasts match your query :("

    @okayy = @results[0]
    @info = @results[0]["trackName"] + " " +  @results[0]["feedUrl"]
      end

  end

end