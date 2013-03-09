class AddColumnIspToIpDownload < ActiveRecord::Migration
  def change
    add_column :ip_downloads, :isp, :string
  end
end
