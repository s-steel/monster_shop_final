class Merchant::DiscountsController < Merchant::BaseController

  def index
    @merchant = current_user.merchant
    @discounts = current_user.merchant.discounts
  end

  def new
    @discount = Discount.new
  end

  def create
    user = current_user
    @discount = user.merchant.discounts.new(discount_params)
    begin
      @discount.save!
      flash[:success] = "Discount created successfully!"
      redirect_to "/merchant/discounts"
    rescue ActiveRecord::RecordInvalid => e
      create_error_response(e)
      redirect_to "/merchant/discounts/new"
    end
  end

  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    @discount = Discount.find(params[:id])
    begin
      @discount.update!(discount_params)
      flash[:success] = "Your discount has been updated"
      redirect_to "/merchant/discounts"
    rescue ActiveRecord::RecordInvalid => e
      create_error_response(e)
      redirect_to "/merchant/discounts/#{@discount.id}/edit"
    end
  end

  private

  def discount_params
    params.require(:discount).permit(:discount, :number_of_items)
  end

  def create_error_response(error)
      flash[:error] = error.message.delete_prefix('Validation failed: ')
  end
end
