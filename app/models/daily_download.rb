class DailyDownload < ActiveRecord::Base
  belongs_to :version

  def self.aggregate(version)
    downloads_by_date = Download.count(:group      => "date(created_at)",
                                       :conditions => { :version_id => version.id })

    downloads_by_date.each do |on, amount|
      daily = version.daily_downloads.find_or_initialize_by_on(on)
      daily.increment(:amount, amount)
      daily.save
    end

    version.downloads.delete_all
  end
end
