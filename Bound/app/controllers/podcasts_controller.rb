class PodcastsController < ApplicationController
  def index	
  end

  def search
  	if (params[:durax]) && (params.keys[2] != "commit")
  	@match = params.keys[2]
  	@podcasts = Podcast.search((params.keys[2].capitalize),params[:durax]).order("created_at DESC")
  	else
  	@failed_match = "No podcasts match your query :("
  	# @podcasts = Podcast.order("created_at DESC")
  	end
    # ITunesSearchAPI.search(:term => "The Killers", :country => "US", :media => "music")

  end



end


