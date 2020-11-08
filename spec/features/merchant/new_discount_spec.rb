require 'rails_helper'

RSpec.describe 'New Discount' do
  describe 'As a Merchant employee' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @merchant_2 = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @ogre = @merchant_1.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @nessie = @merchant_1.items.create!(name: 'Nessie', description: "I'm a Loch Monster!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @merchant_1.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: false, inventory: 3 )
      @hippo = @merchant_2.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 1 )
      @order_1 = @m_user.orders.create!(status: "pending")
      @order_2 = @m_user.orders.create!(status: "pending")
      @order_3 = @m_user.orders.create!(status: "pending")
      @order_item_1 = @order_1.order_items.create!(item: @hippo, price: @hippo.price, quantity: 2, fulfilled: false)
      @order_item_2 = @order_2.order_items.create!(item: @hippo, price: @hippo.price, quantity: 2, fulfilled: true)
      @order_item_3 = @order_2.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2, fulfilled: false)
      @order_item_4 = @order_3.order_items.create!(item: @giant, price: @giant.price, quantity: 4, fulfilled: false)

      @discount_1 = @merchant_1.discounts.create!(discount: 5, number_of_items: 10)
      @discount_2 = @merchant_1.discounts.create!(discount: 10, number_of_items: 20)
      @discount_3 = @merchant_2.discounts.create!(discount: 3, number_of_items: 5)
      @discount_4 = @merchant_2.discounts.create!(discount: 6, number_of_items: 15)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
      visit '/merchant/discounts/new'
    end


    it 'there is a button to create a new discount' do
      visit '/merchant/discounts'
      expect(page).to have_button("Create a New Discount")
    end

    it 'click button for a new discount and you see a form to fill in' do
      visit '/merchant/discounts'
      click_button("Create a New Discount")
      expect(current_path).to eq("/merchant/discounts/new")
      expect(page).to have_content("Enter New Discount Information")
      expect(page).to have_field("discount[discount]")
      expect(page).to have_field("discount[number_of_items]")
      expect(page).to have_button('Create Discount')
    end

    it 'filing in form and submitting takes you back to the index page and you see a flash message confiming it' do
      fill_in "discount[discount]", with: 7
      fill_in "discount[number_of_items]", with: 13
      click_button("Create Discount")

      expect(current_path).to eq("/merchant/discounts")
      expect(page).to have_content("Discount created successfully!")

      new_discount = Discount.last
      within "#discount-#{new_discount.id}" do
        expect(page).to have_content("Discount #{new_discount.id}: #{new_discount.discount}%, on #{new_discount.number_of_items} or more items")
      end
    end

    it 'you must fill in the form completely otherwise you get a flash error' do
      fill_in "discount[discount]", with: ""
      fill_in "discount[number_of_items]", with: 13
      click_button("Create Discount")

      expect(current_path).to eq("/merchant/discounts/new")
      expect(page).to have_content("Discount can't be blank")

      fill_in "discount[discount]", with: 7
      fill_in "discount[number_of_items]", with: ""
      click_button("Create Discount")

      expect(current_path).to eq("/merchant/discounts/new")
      expect(page).to have_content("Number of items can't be blank")
    end

    it 'discount or number of itmes fields cannot be 0' do
      fill_in "discount[discount]", with: 0
      fill_in "discount[number_of_items]", with: 13
      click_button("Create Discount")

      expect(current_path).to eq("/merchant/discounts/new")
      expect(page).to have_content("Discount must be greater than 0")

      fill_in "discount[discount]", with: 10
      fill_in "discount[number_of_items]", with: 0
      click_button("Create Discount")

      expect(current_path).to eq("/merchant/discounts/new")
      expect(page).to have_content("Number of items must be greater than 0")
    end
  end
end
