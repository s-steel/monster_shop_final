class Merchant::DiscountsController < Merchant::BaseController

  def index
    @merchant = current_user.merchant
    @discounts = current_user.merchant.discounts
  end

  def new
  end 

end
