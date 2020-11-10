require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'Order Show Page' do
  describe 'As a Registered User' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @sal = Merchant.create!(name: 'Sals Salamanders', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 1 )
      @user = User.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan_1@example.com', password: 'securepassword')
      @order_1 = @user.orders.create!(status: "packaged")
      @order_2 = @user.orders.create!(status: "pending")
      @order_item_1 = @order_1.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2, fulfilled: true)
      @order_item_2 = @order_2.order_items.create!(item: @giant, price: @hippo.price, quantity: 2, fulfilled: true)
      @order_item_3 = @order_2.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2, fulfilled: false)

      @troll = @megan.items.create!(name: 'Troll', description: "I'm an Troll!", price: 25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 20 )
      @hobbit = @megan.items.create!(name: 'Hobbit', description: "I'm a Hobbit!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 20 )
      @dwarf = @brian.items.create!(name: 'Dwarf', description: "I'm a Drarf!", price: 75, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 20 )
      @discount_1 = @megan.discounts.create!(discount: 5, number_of_items: 4)
      @discount_2 = @megan.discounts.create!(discount: 10, number_of_items: 6)
      @discount_3 = @megan.discounts.create!(discount: 15, number_of_items: 15)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    it 'I can link from my orders to an order show page' do
      visit '/profile/orders'

      click_link @order_1.id

      expect(current_path).to eq("/profile/orders/#{@order_1.id}")
    end

    it 'I see order information on the show page' do
      visit "/profile/orders/#{@order_2.id}"

      expect(page).to have_content(@order_2.id)
      expect(page).to have_content("Created On: #{@order_2.created_at}")
      expect(page).to have_content("Updated On: #{@order_2.updated_at}")
      expect(page).to have_content("Status: #{@order_2.status}")
      expect(page).to have_content("#{@order_2.count_of_items} items")
      expect(page).to have_content("Total: #{number_to_currency(@order_2.grand_total)}")

      within "#order-item-#{@order_item_2.id}" do
        expect(page).to have_link(@order_item_2.item.name)
        expect(page).to have_content(@order_item_2.item.description)
        expect(page).to have_content(@order_item_2.quantity)
        expect(page).to have_content(@order_item_2.price)
        expect(page).to have_content(@order_item_2.subtotal)
      end

      within "#order-item-#{@order_item_3.id}" do
        expect(page).to have_link(@order_item_3.item.name)
        expect(page).to have_content(@order_item_3.item.description)
        expect(page).to have_content(@order_item_3.quantity)
        expect(page).to have_content(@order_item_3.price)
        expect(page).to have_content(@order_item_3.subtotal)
      end
    end

    it 'I see a link to cancel an order, only on a pending order show page' do
      visit "/profile/orders/#{@order_1.id}"

      expect(page).to_not have_button('Cancel Order')

      visit "/profile/orders/#{@order_2.id}"

      expect(page).to have_button('Cancel Order')
    end

    it 'I can cancel an order to return its contents to the items inventory' do
      visit "/profile/orders/#{@order_2.id}"

      click_button 'Cancel Order'

      expect(current_path).to eq("/profile/orders/#{@order_2.id}")
      expect(page).to have_content("Status: cancelled")

      @giant.reload
      @ogre.reload
      @order_item_2.reload
      @order_item_3.reload

      expect(@order_item_2.fulfilled).to eq(false)
      expect(@order_item_3.fulfilled).to eq(false)
      expect(@giant.inventory).to eq(5)
      expect(@ogre.inventory).to eq(7)
    end

    it 'I see any discounts applied to respective items and order total reflects these discounts' do
      visit item_path(@troll)
      click_button 'Add to Cart'
      visit item_path(@hobbit)
      click_button 'Add to Cart'
      visit item_path(@dwarf)
      click_button 'Add to Cart'
      visit "/cart"
      within "#item-#{@troll.id}" do
        click_button('More of This!')
        click_button('More of This!')
        click_button('More of This!')
      end
      within "#item-#{@hobbit.id}" do
        click_button('More of This!')
        click_button('More of This!')
        click_button('More of This!')
        click_button('More of This!')
        click_button('More of This!')
      end
      within "#item-#{@dwarf.id}" do
        click_button('More of This!')
        click_button('More of This!')
        click_button('More of This!')
        click_button('More of This!')
      end

      click_button("Check Out")
      order = @user.orders.last
      item_order_1 = order.order_items[0]
      item_order_2 = order.order_items[1]
      item_order_3 = order.order_items[2]
      visit "/profile/orders/#{order.id}"

      within "#order-item-#{item_order_1.id}" do
        expect(page).to have_content("Your discount has been applied!")
        expect(page).to have_content(@troll.price * @discount_1.discount_to_decimal)
        expect(page).to have_content(@troll.price * item_order_1.quantity * @discount_1.discount_to_decimal)
      end
      within "#order-item-#{item_order_2.id}" do
        expect(page).to have_content("Your discount has been applied!")
        expect(page).to have_content(@hobbit.price * @discount_2.discount_to_decimal)
        expect(page).to have_content(@hobbit.price * item_order_2.quantity * @discount_2.discount_to_decimal)
      end
      within "#order-item-#{item_order_3.id}" do
        expect(page).to_not have_content("Your discount has been applied!")
        expect(page).to have_content(item_order_3.price)
        expect(page).to have_content(item_order_3.subtotal)
      end

      expected = (@troll.price * item_order_1.quantity * @discount_1.discount_to_decimal) +
                  (@hobbit.price * item_order_2.quantity * @discount_2.discount_to_decimal) +
                  (item_order_3.subtotal)
      expect(order.grand_total).to eq(expected)
    end
  end
end
