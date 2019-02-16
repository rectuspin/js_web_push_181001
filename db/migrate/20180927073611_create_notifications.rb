class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :endpoint
      t.string :p256dh
      t.string :auth
    end
  end
end
