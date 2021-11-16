class BulkDiscount < ApplicationRecord
  belongs_to :merchant

  validates :percentage_discount, numericality: { only_integer: true }, presence: true
  validates :quantity_threshold, numericality: { only_integer: true }, presence: true
end
