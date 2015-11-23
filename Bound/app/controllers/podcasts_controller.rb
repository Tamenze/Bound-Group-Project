class PodcastsController < ApplicationController
  def index	
  end

  def search
  	@look = Podcast.search((params.keys[2].capitalize),params[:durax]).order("created_at DESC")
    if (params[:durax] != nil) && (@genre_term != "commit") && @look != []
        @podcasts = Podcast.search((params.keys[2].capitalize),params[:durax]).order("created_at DESC")
  	else
  	@failed_match = "No podcasts match your query :("
  	# @podcasts = Podcast.order("created_at DESC")
    end
    # if (params[:durax] != nil) && (@genre_term != "commit")
    #  @genre_term = params.keys[2] #use gsub and possibly also url encoder for genres with _ . like...if they contain _, replace with a space, and then test to see if encoding is needed

    # @results = ITunesSearchAPI.search(:term=> @genre_term, :country => "US", :entity=> "podcast", :media => "podcast" )
    #     @results.each do |r|
    #       @cool = r['feedUrl']
    #        @xpage = HTTParty.get(@cool)
    #        # @xpage = HTTParty.get(@cool + "?fmt=xml")
    # # else
    # # @failed_match = "No podcasts match your query :("
    #     end



    # @okayy = @results[0]
    # @info = @results[0]["trackName"] + " " +  @results[0]["feedUrl"]
    # end

  end



end


