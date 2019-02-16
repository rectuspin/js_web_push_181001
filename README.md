# rails4-pwa-boilerplate

1. Key를 생성하고, public_key와 private_key를 저장해둔다.
```ruby
# rails console
require("webpush")
vapid_key = Webpush.generate_key
puts vapid_key.public_key
puts vapid_key.private_key
```

2. public_key와 private_key를 환경변수에 저장한다. 또는 figaro를 통해 환경변수에 저장한다. ( config/application.yml )
```ruby
# config/application.yml
VAPID_PUBLIC_KEY: 퍼블릭키를 여기에 복붙해서 넣자
VAPID_PRIVATE_KEY: 프라이빗키를 여기에 복붙해서 넣자
```

3. 만일 config/application.yml에 환경변수를 저장할려한다면, gitignore 설정을 통해서 git에 커밋 되지않도록 주의하자. 
( 이 boilerplate 프로젝트는 편의를 위해 application.yml을 git에 커밋하였지만, 실제 프로덕션 서비스라면 환경변수들이 노출되면 안되므로 주의해야한다. )

4. 사이트에 접속해서 알림을 켜고, 알림이 제대로 전송되는지 확인해보자.
```shell
# lib/tasks/my_tasks.rake 파일에 알림 테스트를 위한 코드를 작성하였다.

$ rake my_tasks:noti
```

참고. 자신의 서비스에 맞는 상황에 알림을 보내는게 궁극적인 목표인데, 이는 크게 어렵지 않다. 밑에 있는 루비 코드를 적절히 수정하여 충분히 구현가능하다.
```ruby
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
```

## Defendency

해당 프로젝트는 Rails4를 기반으로 작동한다. 하지만, 일부 수정을 거치면 Rails5에서도 작동함을 확인할수있다.

## 유용한 자료

[프로그레시브 웹앱(PWA) 푸시 알람 A to Z](https://joshua1988.github.io/web-development/pwa/pwa-push-noti-guide/)

[웹 앱에 푸시 알림 추가](https://developers.google.com/web/fundamentals/codelabs/push-notifications/?hl=ko)
