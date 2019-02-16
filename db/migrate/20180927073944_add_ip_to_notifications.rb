class AddIpToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :ip, :string
  end
end
