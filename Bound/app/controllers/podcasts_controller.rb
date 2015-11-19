class PodcastsController < ApplicationController
  def index
  	#iterate podcast by genre
  	@podcast = Podcast.where(genre:'sports', duration: 30..45)
  end
  # def results
  # end
end
