class CreateDailyDownloads < ActiveRecord::Migration
  def self.up
    create_table "daily_downloads" do |t|
      t.integer "version_id"
      t.integer "amount"
      t.date    "on"
    end
    add_index :daily_downloads, :version_id
    add_index :daily_downloads, :on
  end

  def self.down
    remove_index :daily_downloads, :version_id
    remove_index :daily_downloads, :on
    drop_table :daily_downloads
  end
end
