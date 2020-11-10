class User::OrdersController < ApplicationController
  before_action :exclude_admin

  def index
    @orders = current_user.orders
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  def create
    order = current_user.orders.new
    order.save
      cart.items.each do |item|
        if item.discount_to_use(cart.count_of(item.id))
          discount = ((100 - item.discount_to_use(cart.count_of(item.id))) * 0.01)
          has_discount = true
        else
          discount = 1
          has_discount = false
        end
        order.order_items.create({
          item: item,
          quantity: cart.count_of(item.id),
          price: (item.price * discount),
          discount?: has_discount
          })
      end
    session.delete(:cart)
    flash[:notice] = "Order created successfully!"
    redirect_to '/profile/orders'
  end

  def cancel
    order = current_user.orders.find(params[:id])
    order.cancel
    redirect_to "/profile/orders/#{order.id}"
  end
end
