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
          @results.each do |r|
          # r = @results.first
          @cool = r['feedUrl']
           # @xpage = HTTParty.get(@cool)["rss"]["channel"]
           @doc = Nokogiri::HTML(open(@cool))
           @duration = @doc.xpath('//duration')
          end
        end
    # else
    # @failed_match = "No podcasts match your query :("

    @okayy = @results[0]
    @info = @results[0]["trackName"] + " " +  @results[0]["feedUrl"]
      end

  end

end