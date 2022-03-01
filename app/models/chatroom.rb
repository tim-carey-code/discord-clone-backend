class Chatroom < ApplicationRecord
    has_many :messages, dependent: :destroy
    belongs_to :user
    validates :room_name, presence: true
end
