class Visit < ActiveRecord::Base
	validates :submitter_id, :shortened_url_id, presence: true

	belongs_to(
		:submitter,
		class_name: "User",
		foreign_key: :submitter_id,
		primary_key: :id
	)

	belongs_to(
		:shortened_url,
		class_name: "ShortenedUrl",
		foreign_key: :shortened_url_id,
		primary_key: :id
	)

	def self.record_visit!(user, shortened_url)
		Visit.create!(
			submitter_id: user.id,
			shortened_url_id: shortened_url.id
		)
	end
end