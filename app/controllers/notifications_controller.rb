class NotificationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def push
    jsonbody = JSON.parse request.body.read()
    endpoint = jsonbody["subscription"]["endpoint"]
    p256dh = jsonbody["subscription"]["keys"]["p256dh"]
    auth = jsonbody["subscription"]["keys"]["auth"]
    @notification = Notification.new(endpoint: endpoint, p256dh: p256dh, auth: auth)
    @notification.ip = request.remote_ip
    # 필요에 따라 user의 id도 저장할수있음. 
    
    @notification.save()
    
    render json: jsonbody
  end
  
  def message
    @notifications = Notification.all
    
    # 구독자들에게 알림을 보낸다.
    for notif in @notifications
     begin
       Webpush.payload_send(
           message: request.body.read(),
           endpoint: notif.endpoint,
           p256dh: notif.p256dh,
           auth: notif.auth,
           ttl: 24 * 60 * 60,
           vapid: {
               subject: 'mailto: hello@gmail.com',
               public_key: ENV['VAPID_PUBLIC_KEY'],
               private_key: ENV['VAPID_PRIVATE_KEY']
           }
       )
    #   Webpush.payload_send(
    #       message: { title: 'hello 제목', content: 'rhrh'}.to_json,
    #       endpoint: notif.endpoint,
    #       p256dh: notif.p256dh,
    #       auth: notif.auth,
    #       ttl: 24 * 60 * 60,
    #       vapid: {
    #           subject: 'mailto: hello@gmail.com',
    #           public_key: ENV['VAPID_PUBLIC_KEY'],
    #           private_key: ENV['VAPID_PRIVATE_KEY']
    #       }
    #   )
     rescue
      # 간혹 Notification이 안되는 경우도 있기에 예외처리를 한다.
     end
    end
  end
end
