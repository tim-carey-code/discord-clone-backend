class Message < ApplicationRecord
  belongs_to :chatroom
  validates :text, presence: true
  belongs_to :user
end
