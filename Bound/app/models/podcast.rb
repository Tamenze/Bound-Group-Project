class Podcast < ActiveRecord::Base

	def self.search(category, trip_time)
		Podcast.where("genre = ?", category).where(duration: ((trip_time).to_i - (trip_time).to_i)..((trip_time).to_i - 10))
	end
end
