class SearchQuery < ApplicationRecord
  validates :query, presence: true
  validates :user_ip, presence: true
end
