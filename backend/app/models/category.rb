class Category < ApplicationRecord
  has_many :expenses, dependent: :destroy

  # case_sensitive: false ensures uniqueness is enforced at the Rails layer
  # regardless of database collation (e.g. "food" and "Food" are duplicates).
  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
