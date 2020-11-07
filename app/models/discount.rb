class Discount < ApplicationRecord
  validates_presence_of :number_of_items, :discount

  belongs_to :merchant
  has_many :items, through: :merchant
end
