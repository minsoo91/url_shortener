class ShortenedUrl < ActiveRecord::Base
	validates :long_url, :submitter_id, presence: true
	validates :short_url, presence: true, uniqueness: true

	belongs_to(
		:submitter,
		class_name: "User",
		foreign_key: :submitter_id,
		primary_key: :id
	)

	has_many(
		:visits,
		class_name: "Visit",
		foreign_key: :shortened_url_id,
		primary_key: :id
	)

	has_many(
		:visitors,
		-> { distinct },
		through: :visits,
		source: :submitter
	)

	def self.random_code
		while true	
			code = SecureRandom::urlsafe_base64
			break unless ShortenedUrl.exists?(short_url: code)
		end

		code
	end

	def self.create_for_user_and_long_url!(user, long_url)
		code = self.random_code
		ShortenedUrl.create!(
			submitter_id: user.id,
			long_url: long_url,
			short_url: code
		)
	end

	def num_clicks
		visits.count
	end

	def num_uniques
		visitors.count
	end

	def num_recent_uniques
		Visit.distinct.where('created_at >  ?', 10.minutes.ago).count
	end
end	