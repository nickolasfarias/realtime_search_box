class MovieInfo < ApplicationRecord
  validates :title, presence: true
  validates :title, uniqueness: true
  validates :quote, presence: true

  include PgSearch::Model
  pg_search_scope :search_by_title,
                  against: [:title],
                  using: {
                    tsearch: { prefix: true }
                  }
end
