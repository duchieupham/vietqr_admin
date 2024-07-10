importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
    apiKey: "AIzaSyAjPP6Mc3baFUgEsO8o0-J-qmSVegmw2TQ",
    authDomain: "vietqr-product.firebaseapp.com",
    projectId: "vietqr-product",
    storageBucket: "vietqr-product.appspot.com",
    messagingSenderId: "84188087131",
    appId: "1:84188087131:web:79177d863a3480e04ed07e",
    measurementId: "G-WM7ZNEVC7R"
});
// Necessary to receive background messages:
const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((m) => {
    console.log("onBackgroundMessage", m);
});
