class AddTelegramToProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :telegram_id, :string
  end
end
