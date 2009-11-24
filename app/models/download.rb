class Download < ActiveRecord::Base
  include Pacecar
  attr_accessor :raw
  belongs_to :version

  def perform
    version = Version.find_by_full_name!(self.raw.chomp(".gem"))

    Download.transaction do
      self.version = version
      self.save!
      self.version.increment!(:downloads_count)
      self.version.rubygem.increment!(:downloads)
    end
  end
end
