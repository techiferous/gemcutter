Factory.define :daily_download do |daily_download|
  daily_download.association(:version)
  daily_download.amount { 1 }
  daily_download.on { Time.now.to_s(:db) }
end
