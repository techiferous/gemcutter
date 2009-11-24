require File.dirname(__FILE__) + '/../test_helper'

class DailyDownloadTest < ActiveSupport::TestCase
  should "be valid with factory" do
    assert_valid Factory.build(:daily_download)
  end
  should_belong_to :version
  should_have_db_index :version_id
  should_have_db_index :on

  context "with a few downloads" do
    setup do
      @version = Factory(:version)
      Download.create(:raw => "#{@version.full_name}.gem", :created_at => 1.day.ago).perform
      Download.create(:raw => "#{@version.full_name}.gem", :created_at => 1.day.ago).perform
      Download.create(:raw => "#{@version.full_name}.gem", :created_at => 2.days.ago).perform
    end

    should "aggregate downloads properly" do
      DailyDownload.aggregate(@version)

      first_daily = DailyDownload.find_by_version_id_and_on!(@version.id, 1.day.ago.to_date)
      assert_equal 2, first_daily.amount

      second_daily = DailyDownload.find_by_version_id_and_on!(@version.id, 2.days.ago.to_date)
      assert_equal 1, second_daily.amount

      assert_equal 0, @version.reload.downloads.count
      assert_equal 3, @version.reload.downloads_count
      assert_equal 3, @version.rubygem.downloads
    end
  end
end
