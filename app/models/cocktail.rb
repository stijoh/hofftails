class Cocktail < ApplicationRecord
  has_many :doses, dependent: :destroy
  has_many :ingredients, through: :doses
  belongs_to :user
  validates :name, presence: true, uniqueness: true
  has_one_attached :photo
  accepts_nested_attributes_for :doses, reject_if: :all_blank, allow_destroy: true
#   scope :with_name_or_ingredient, lambda { |query|
#     ingredient = Ingredient.where('lower(name) ILIKE ?', "%#{query.downcase}%")
#     return where('name ILIKE ?', "%#{query}%") unless ingredient

#     eager_load(:doses).merge(Dose.where(ingredient: ingredient))
#
  include PgSearch::Model
  pg_search_scope :global_search,
  against: [:name],
    associated_against: {
      ingredients: [:name]
    },
  using: {
    tsearch: { prefix: true }
  }

  def self.search(query)
    if query.present?
      global_search(query)
    else
      all
    end
  end
end
