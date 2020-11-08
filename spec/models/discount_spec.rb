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
end 
