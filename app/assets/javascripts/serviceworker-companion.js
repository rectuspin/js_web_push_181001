if (navigator.serviceWorker) {
    navigator.serviceWorker.register('/serviceworker.js', { scope: './' })
      .then(function(reg) {
        console.log('[Companion]', 'Service worker registered!');
      });
    
    navigator.serviceWorker.ready
    .then((swReg) => {
      console.log("When SW is ready");
       swReg.pushManager.getSubscription()
                .then((subscription) => {
                    isSubscribed = !(subscription === null);

                    if (isSubscribed) {
                        // 이미 구독을 하고있는경우!
                        console.log('User IS subscribed.');
                        console.log(subscription)
                    } else {
                        // 아직 구독을 안하고있는 경우!
                        // 그렇기때문에 구독을 생성해줘야한다.
                        console.log('User is NOT subscribed.');
                        return swReg.pushManager
                            .subscribe({
                                // 구독
                                userVisibleOnly: true,
                                applicationServerKey: window.vapidPublicKey
                            }).then(() => (swReg))
                             .then((swReg) => {
                                swReg.pushManager.getSubscription()
                                    .then((sub) => {
                                         // 서버에도 구독 정보를 저장해야하므로  
                                        let body = {
                                            subscription: sub.toJSON(),
                                            message: 'Hey!'
                                        };
                                        console.log(body);
                                        fetch('/push', {
                                            method: 'POST',
                                            body: JSON.stringify(body)
                                        })
                                            .then((res) => {
                                                console.log(res)
                                            })
                                            .catch((err) => {
                                                console.log(err)
                                            })
                                    })
                            })
                    }
                })

    })
}
