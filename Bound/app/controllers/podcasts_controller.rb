class PodcastsController < ApplicationController

  def index
  	#iterate podcast by genre
  	# @podcast = Podcast.where(genre:'sports', duration: 30..45)
  	@podcast = Podcast.where(genre:'sports', duration: 30..45)
  end

  def search
    @genre_term = params.keys[2]
    if @genre_term.include? "_" 
      @genre_term = @genre_term.gsub("_"," ").split(" ").map(&:capitalize).join(" ")
      #.map(&:capitalize).join(" ")
    end

    @look = Podcast.search((@genre_term),params[:durax]).order("created_at DESC")
  	# @look = Podcast.search((params.keys[2].capitalize),params[:durax]).order("created_at DESC")
    if (params[:durax] != nil) && (@genre_term != "commit") && @look != []
        @podcasts = Podcast.search((@genre_term),params[:durax]).order("created_at DESC")
  	else
  	@failed_match = "No podcasts match your query :("
  	# @podcasts = Podcast.order("created_at DESC")
    end

    # if (params[:durax] != nil) && (@genre_term != "commit")
    #  @genre_term = params.keys[2]
    #  if @genre_term.include? "_" 
    #   @genre_term.gsub("_"," ")
    #  end

      #use gsub and possibly also url encoder for genres with _ . like...if they contain _, replace with a space, and then test to see if encoding is needed

    # @results = ITunesSearchAPI.search(:term=> @genre_term, :country => "US", :entity=> "podcast", :media => "podcast" )
    #     @results.each do |r|
    #       @cool = r['feedUrl']
    #        @xpage = HTTParty.get(@cool)
    #        # @xpage = HTTParty.get(@cool + "?fmt=xml")
    # # # else
    # # # @failed_match = "No podcasts match your query :("
    #     end



    # @okayy = @results[0]
    # @info = @results[0]["trackName"] + " " +  @results[0]["feedUrl"]
    # end

  end

end