class DailyDownload < ActiveRecord::Base
  belongs_to :version

  def self.aggregate(version)
    downloads_by_date = Download.count(:group      => "date(created_at)",
                                       :conditions => { :version_id => version.id })

    downloads_by_date.each do |on, amount|
      version.daily_downloads.create(:on => on, :amount => amount)
    end

    version.downloads.delete_all
  end
end
