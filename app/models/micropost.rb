class Micropost < ActiveRecord::Base
	belongs_to :user

	validates :user_id, presence: true
	validates :content, presence: true, length: { maximum: 140 }

	default_scope -> { order('created_at DESC') }

	def self.from_users_followed_by(user)
		# following_ids = user.followed_users.map(&:id).join(', ')
		# where("user_id IN (?) OR user_id = ?", user.followed_user_ids, user.id)
		followed_user_ids = "SELECT followed_id FROM relationships
													WHERE follower_id = :user_id"
		where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", user_id: user.id )
	end
end
