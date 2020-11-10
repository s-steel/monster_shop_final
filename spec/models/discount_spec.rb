require 'rails_helper'

RSpec.describe Discount do
  describe 'Relationships' do
    it {should belong_to :merchant}
    it {should have_many(:items).through(:merchant)}
  end

  describe 'Validations' do
    it { should validate_presence_of :number_of_items }
    it { should validate_presence_of :discount }
  end

  describe 'Instance methods' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @discount_1 = @megan.discounts.create!(discount: 5, number_of_items: 3)
      @discount_2 = @megan.discounts.create!(discount: 7, number_of_items: 5)
      @discount_3 = @megan.discounts.create!(discount: 6, number_of_items: 10)
    end

    it '.discount_to_decimal' do
      expect(@discount_1.discount_to_decimal.round(2)).to eq(0.95)
      expect(@discount_2.discount_to_decimal.round(2)).to eq(0.93)
      expect(@discount_3.discount_to_decimal.round(2)).to eq(0.94)
    end
  end
end
