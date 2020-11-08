require 'rails_helper'

RSpec.describe 'Merchant Discount show' do
  describe 'As a Merchant employee' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @discount_1 = @merchant_1.discounts.create!(discount: 5, number_of_items: 10)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
      visit '/merchant/discounts'
    end

    it 'click discount link and it takes me to that discounts show page' do
      within "#discount-#{@discount_1.id}" do
        click_link("Discount #{@discount_1.id}")
      end

      expect(current_path).to eq("/merchant/discounts/#{@discount_1.id}")
    end

    it 'shows info about the discount' do
      visit "/merchant/discounts/#{@discount_1.id}"

      expect(page).to have_content("Discount #{@discount_1.id}")
      expect(page).to have_content("Percent to be discounted: #{@discount_1.discount}")
      expect(page).to have_content("When a customer orders #{@discount_1.number_of_items} or more of a particular item")
    end
  end
end
