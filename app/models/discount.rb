class Discount < ApplicationRecord
  validates_presence_of :number_of_items, :discount

  belongs_to :merchant
  has_many :items, through: :merchant
  validates_numericality_of :discount, greater_than: 0
  validates_numericality_of :number_of_items, greater_than: 0
end
