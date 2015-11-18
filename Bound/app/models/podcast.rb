class Podcast < ActiveRecord::Base
	has_many :genres
	validates_presence_of :genre, presence: true
end
