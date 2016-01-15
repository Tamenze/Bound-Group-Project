class Podcast < ActiveRecord::Base

	# has_many :genres
	# validates_presence_of :genre, presence: true
	# has_many :genres

	def self.search(category, trip_time)
		Podcast.where("genre = ?", category).where(duration: ((trip_time).to_i - (trip_time).to_i)..((trip_time).to_i - 10))
	end
end
