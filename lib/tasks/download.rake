namespace :download do
  desc "Download csv data from Economatica"
  task run: :environment do
    puts "Starting dowload"
    DownloadJob.perform_now
    puts "Download completed"
  end
end
