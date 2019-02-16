namespace :my_tasks do
  task noti: :environment do
    puts 'Go!!!!!!!1'
    notif = Notification.all
    puts "*"*10
    puts ENV['VAPID_PUBLIC_KEY']
    puts ENV['VAPID_PRIVATE_KEY']
    puts "%"*10
    notif.each do |noti|
      begin
          Webpush.payload_send(
            message: { title: '제목!!', content: '내용ㅃ' }.to_json,
            endpoint: noti.endpoint,
            p256dh: noti.p256dh,
            auth: noti.auth,
            ttl: 24 * 60 * 60,
            vapid: {
              subject: 'mailto:gooooo@gmail.com',
              public_key: ENV['VAPID_PUBLIC_KEY'],
              private_key: ENV['VAPID_PRIVATE_KEY']
            }
          )
     rescue Exception => e
      puts 'no'
      puts e 
     end
    end
  end
  task :te do
    puts Product.last
  end
end