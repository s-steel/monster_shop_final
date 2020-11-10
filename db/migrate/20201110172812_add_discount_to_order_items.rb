class AddDiscountToOrderItems < ActiveRecord::Migration[5.2]
  def change
    add_column :order_items, :discount?, :boolean, default: false
  end
end
