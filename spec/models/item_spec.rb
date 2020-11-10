require 'rails_helper'

RSpec.describe Item do
  describe 'Relationships' do
    it {should belong_to :merchant}
    it {should have_many(:discounts).through(:merchant)}
    it {should have_many :order_items}
    it {should have_many(:orders).through(:order_items)}
    it {should have_many :reviews}
  end

  describe 'Validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :description}
    it {should validate_presence_of :image}
    it {should validate_presence_of :price}
    it {should validate_presence_of :inventory}
  end

  describe 'Instance Methods' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @merchant_2 = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @hippo = @merchant_2.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 1 )
      @review_1 = @ogre.reviews.create(title: 'Great!', description: 'This Ogre is Great!', rating: 5)
      @review_2 = @ogre.reviews.create(title: 'Meh.', description: 'This Ogre is Mediocre', rating: 3)
      @review_3 = @ogre.reviews.create(title: 'EW', description: 'This Ogre is Ew', rating: 1)
      @review_4 = @ogre.reviews.create(title: 'So So', description: 'This Ogre is So so', rating: 2)
      @review_5 = @ogre.reviews.create(title: 'Okay', description: 'This Ogre is Okay', rating: 4)
      @discount_1 = @megan.discounts.create!(discount: 5, number_of_items: 3)
      @discount_2 = @megan.discounts.create!(discount: 7, number_of_items: 5)
      @discount_3 = @megan.discounts.create!(discount: 6, number_of_items: 10)
      @discount_4 = @megan.discounts.create!(discount: 10, number_of_items: 15)
      @discount_5 = @megan.discounts.create!(discount: 3, number_of_items: 20)
      @discount_6 = @megan.discounts.create!(discount: 5, number_of_items: 25)
      @discount_7 = @megan.discounts.create!(discount: 20, number_of_items: 26)
    end

    it '.sorted_reviews()' do
      expect(@ogre.sorted_reviews(3, :desc)).to eq([@review_1, @review_5, @review_2])
      expect(@ogre.sorted_reviews(3, :asc)).to eq([@review_3, @review_4, @review_2])
      expect(@ogre.sorted_reviews).to eq([@review_3, @review_4, @review_2, @review_5, @review_1])
    end

    it '.average_rating' do
      expect(@ogre.average_rating.round(2)).to eq(3.00)
    end

    it '.merchant_has_discount?' do
      expect(@ogre.merchant_has_discount?).to be_truthy
      expect(@giant.merchant_has_discount?).to be_truthy
      expect(@hippo.merchant_has_discount?).to be_falsy
    end

    it '.discount_to_use' do
      expect(@ogre.discount_to_use(2)).to be_nil
      expect(@hippo.discount_to_use(30)).to be_nil

      expect(@ogre.discount_to_use(3).id).to be(@discount_1.id)
      expect(@ogre.discount_to_use(5).id).to be(@discount_2.id)
      expect(@ogre.discount_to_use(9).id).to be(@discount_2.id)
      expect(@ogre.discount_to_use(13).id).to be(@discount_2.id)
      expect(@ogre.discount_to_use(15).id).to be(@discount_4.id)
      expect(@ogre.discount_to_use(21).id).to be(@discount_4.id)
      expect(@ogre.discount_to_use(25).id).to be(@discount_4.id)
      expect(@ogre.discount_to_use(26).id).to be(@discount_7.id)
      expect(@ogre.discount_to_use(4009).id).to be(@discount_7.id)
      expect(@ogre.discount_to_use(4).id).to be(@discount_1.id)
    end
  end

  describe 'Class Methods' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @nessie = @brian.items.create!(name: 'Nessie', description: "I'm a Loch Monster!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: false, inventory: 3 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Loch Monster!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: false, inventory: 3 )
      @gator = @brian.items.create!(name: 'Gator', description: "I'm a Loch Monster!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: false, inventory: 3 )
      @review_1 = @ogre.reviews.create(title: 'Great!', description: 'This Ogre is Great!', rating: 5)
      @review_2 = @ogre.reviews.create(title: 'Meh.', description: 'This Ogre is Mediocre', rating: 3)
      @review_3 = @ogre.reviews.create(title: 'EW', description: 'This Ogre is Ew', rating: 1)
      @review_4 = @ogre.reviews.create(title: 'So So', description: 'This Ogre is So so', rating: 2)
      @review_5 = @ogre.reviews.create(title: 'Okay', description: 'This Ogre is Okay', rating: 4)
      @user = User.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @order_1 = @user.orders.create!
      @order_2 = @user.orders.create!
      @order_3 = @user.orders.create!
      @order_1.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2)
      @order_1.order_items.create!(item: @hippo, price: @hippo.price, quantity: 3)
      @order_2.order_items.create!(item: @hippo, price: @hippo.price, quantity: 5)
      @order_3.order_items.create!(item: @nessie, price: @nessie.price, quantity: 7)
      @order_3.order_items.create!(item: @gator, price: @gator.price, quantity: 1)
    end

    it '.active_items' do
      expect(Item.active_items).to eq([@ogre, @giant])
    end

    it '.by_popularity()' do
      expect(Item.by_popularity).to eq([@hippo, @nessie, @ogre, @gator, @giant])
      expect(Item.by_popularity(3, "ASC")).to eq([@giant, @gator, @ogre])
      expect(Item.by_popularity(3, "DESC")).to eq([@hippo, @nessie, @ogre])
    end
  end
end
