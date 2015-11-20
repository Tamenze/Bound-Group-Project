class Podcast < ActiveRecord::Base
	# has_many :genres


	def self.search(category, trip_time)
		Podcast.where("genre = ?", category).where(duration: ((trip_time).to_i - 5)..((trip_time).to_i - 10))
		#http://guides.rubyonrails.org/active_record_querying.html sec 15
	end

end
