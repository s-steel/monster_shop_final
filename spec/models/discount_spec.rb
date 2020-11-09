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
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @discount_1 = @merchant_1.discounts.create!(discount: 3, number_of_items: 5)
      @discount_2 = @merchant_1.discounts.create!(discount: 5, number_of_items: 10)
      @discount_3 = @merchant_1.discounts.create!(discount: 8, number_of_items: 15)
      @discount_4 = @merchant_1.discounts.create!(discount: 10, number_of_items: 20)
      @ogre = @merchant_1.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 50 )
    end

    # it '.discount_to_decimal' do
    #   expect(@discount_1.discount_to_decimal.round(2)).to eq(0.97)
    # end
  end

  describe 'Class methods' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @discount_1 = @merchant_1.discounts.create!(discount: 3, number_of_items: 5)
      @discount_2 = @merchant_1.discounts.create!(discount: 2, number_of_items: 10)
      @discount_3 = @merchant_1.discounts.create!(discount: 25, number_of_items: 15)
      @discount_4 = @merchant_1.discounts.create!(discount: 10, number_of_items: 20)
      @ogre = @merchant_1.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 50 )
    end

    # it '#discount_to_use' do
    #   expect(@ogre.discounts.discount_to_use(4)).to eq([@discount_1])
    #   expect(@ogre.discounts.discount_to_use(6)).to eq([@discount_1])
    #   expect(@ogre.discounts.discount_to_use(11)).to eq([@discount_1])
    #   expect(@ogre.discounts.discount_to_use(19)).to eq([@discount_3])
    #   expect(@ogre.discounts.discount_to_use(100)).to eq([@discount_3])
    # end
  end
end
