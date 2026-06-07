class Expense < ApplicationRecord
  belongs_to :category

  validate :date_not_in_future

  private

  # Prevents recording expenses for dates that haven't happened yet,
  # since you cannot spend money in the future.
  def date_not_in_future
    errors.add(:date, "cannot be in the future") if date.present? && date > Date.today
  end
end
