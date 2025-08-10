importScripts("https://www.gstatic.com/firebasejs/9.23.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.23.0/firebase-messaging-compat.js");

firebase.initializeApp({
    apiKey: "AIzaSyALygu5HyhLGXsRBxUzsT-EcEwtsRuoec8",
    authDomain: "linchpin-369.firebaseapp.com",
    projectId: "linchpin-369",
    storageBucket: "linchpin-369.appspot.com",
    messagingSenderId: "1057112917403",
    appId: "1:1057112917403:web:e4ef6a073fce59482d0d3e",
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage(function (payload) {
    console.log("[firebase-messaging-sw.js] دریافت پیام بک‌گراند:", payload);

    const notificationTitle = payload.notification?.title || "Notification";
    const notificationOptions = {
        body: payload.notification?.body || "",
        icon: "assets/images/logo.png"
    };

    self.registration.showNotification(notificationTitle, notificationOptions);
});
