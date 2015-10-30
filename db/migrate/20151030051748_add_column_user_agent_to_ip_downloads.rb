class AddColumnUserAgentToIpDownloads < ActiveRecord::Migration
  def change
    add_column :ip_downloads, :user_agent, :string
  end
end
