'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "febddcdf218b26fb957008816a475ad4",
"version.json": "e4fe985f9fb3b074ab4690f22b388d4b",
"splash/img/light-2x.png": "78b32172d739fcec40fd4ff9601192ec",
"splash/img/dark-4x.png": "ce752977aef4637f4e5c40deb4a774fb",
"splash/img/light-3x.png": "f48cc3e4652a217cc96cec92aa343386",
"splash/img/dark-3x.png": "f48cc3e4652a217cc96cec92aa343386",
"splash/img/light-4x.png": "ce752977aef4637f4e5c40deb4a774fb",
"splash/img/dark-2x.png": "78b32172d739fcec40fd4ff9601192ec",
"splash/img/dark-1x.png": "940040774642d53de6f71453e737a203",
"splash/img/light-1x.png": "940040774642d53de6f71453e737a203",
"splash/splash.js": "123c400b58bea74c1305ca3ac966748d",
"splash/style.css": "c94c38ff00a9d487c353a2d78989ea08",
"index.html": "4b606f770f8c3a5485751edad0bfbf42",
"/": "4b606f770f8c3a5485751edad0bfbf42",
"firebase-messaging-sw.js": "ac580569feefa4089ae00ab086b89ada",
"main.dart.js": "b294d5bed9341a4afcd82b56faf6c6d1",
"flutter.js": "383e55f7f3cce5be08fcf1f3881f585c",
"icons/favicon-16x16.png": "0852cf0bc1ac3fe43eb50cd8b6d0accd",
"icons/favicon.ico": "f43709e9dd9a3265ef12c4f419e8de07",
"icons/apple-icon.png": "b81dff5f34c3e5b07ac1d24aac871fb1",
"icons/apple-icon-144x144.png": "977fdfd359864ae1f8d171e6cd882767",
"icons/android-icon-192x192.png": "cc0edaf14ab7ca6c305dfd14a5874ec0",
"icons/apple-icon-precomposed.png": "b81dff5f34c3e5b07ac1d24aac871fb1",
"icons/apple-icon-114x114.png": "a4d28a2f2c2bc0a9ec021e396779b3e9",
"icons/ms-icon-310x310.png": "6cbc4f3c6d61b64de313526842dbaf18",
"icons/ms-icon-144x144.png": "977fdfd359864ae1f8d171e6cd882767",
"icons/apple-icon-57x57.png": "0ea66baf676af178f7ef7d928084f03a",
"icons/apple-icon-152x152.png": "aa9744592d9401fba07a2c0a72b95348",
"icons/ms-icon-150x150.png": "77def3f60cb128fa2082d44c8f272424",
"icons/android-icon-72x72.png": "117fe5eb9c3eb2ba1c3a2d32ffc28cf3",
"icons/android-icon-96x96.png": "1f843914f82aabe6a0b38b55196254e1",
"icons/android-icon-36x36.png": "3299b1d3b31066dc52914c3d3b080b4f",
"icons/apple-icon-180x180.png": "0c0960cf175e2838edc7b2b21e833889",
"icons/favicon-96x96.png": "1f843914f82aabe6a0b38b55196254e1",
"icons/manifest.json": "e09ef311ac263278c68affec51eb0e49",
"icons/android-icon-48x48.png": "64fc77eed255c6c5848490fbb67ad407",
"icons/apple-icon-76x76.png": "cb5afd10e89e4a1ddb525096a9f1cd8d",
"icons/apple-icon-60x60.png": "7f711ca18d3a14cc44459b6da307e3e9",
"icons/browserconfig.xml": "653d077300a12f09a69caeea7a8947f8",
"icons/android-icon-144x144.png": "977fdfd359864ae1f8d171e6cd882767",
"icons/apple-icon-72x72.png": "117fe5eb9c3eb2ba1c3a2d32ffc28cf3",
"icons/apple-icon-120x120.png": "d179e52f32611fc6dcba7e117092d622",
"icons/favicon-32x32.png": "2e84764908dd520b0f248bd050de29ca",
"icons/ms-icon-70x70.png": "fb84334959dbceee6928f3682f17a88c",
"assets/AssetManifest.json": "0715eaf6194e68ccc6ac72994f50f42b",
"assets/NOTICES": "24149c5fb5869e8cb419a55a8d73df97",
"assets/FontManifest.json": "e77016124a9e5a64a4766219d6aa6cf9",
"assets/AssetManifest.bin.json": "bb2c73c0410374001d628803fad7c8bf",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "04f83c01dded195a11d21c2edf643455",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "78736212556cc9a82f076f9a7a9e4d5c",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "17ee8e30dde24e349e70ffcdc0073fb0",
"assets/packages/iconsax_flutter/fonts/FlutterIconsax.ttf": "83c878235f9c448928034fe5bcba1c8a",
"assets/packages/fluttertoast/assets/toastify.js": "56e2c9cedd97f10e7e5f1cebd85d53e3",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "f8741c4cb4238148c11eb017716a7139",
"assets/fonts/MaterialIcons-Regular.otf": "0ee2cfebfef1c08476e7f3802f34eab5",
"assets/assets/rives/success_ani.riv": "ee100756ea0ffb40f61a85294fbc0a0f",
"assets/assets/images/ic-guide1.png": "7a4e74d4ba28c93c4efad5a3861c3129",
"assets/assets/images/ic-viet-qr-login.png": "4d18e43796065fe0887ca43ef73a103a",
"assets/assets/images/ic-guide3.png": "fe1e45167767031a41e7e93c19551560",
"assets/assets/images/ic-guide2.png": "4ec76ca18dba95277134618f577bb1c4",
"assets/assets/images/logo-google-play.png": "64627bd3b8538155afe1062cbd636953",
"assets/assets/images/ic-transaction-success.png": "7b645cf903ccb1093cd4911908988171",
"assets/assets/images/ic-light-web.png": "592fcbada3ed27ae0b196f4722840d38",
"assets/assets/images/ic-guide5.png": "1fac4bcdc41fc7df0c2510ae186738a6",
"assets/assets/images/logo-google.png": "acb6e1dd389cdbf2ec50746e1e7460b9",
"assets/assets/images/ic-copy.png": "1dd932fb198c42b43a261b1f7a74d4a8",
"assets/assets/images/ic-avatar-business.png": "085ac759656cbb299fae5565d501ec54",
"assets/assets/images/ic-hide.png": "4a366bd77719a4ec0fe4a6f39308192c",
"assets/assets/images/ic-warning.png": "4cb684b1016af781014344188e36ee91",
"assets/assets/images/logo-vietqr-header.png": "570c842d37176804e108bcc314b726e6",
"assets/assets/images/ic-guide4.png": "b85e4aa22b4d6b4de505e3439cdac06d",
"assets/assets/images/ic-auto-theme-web.png": "9f8e1cf21633b3998b57589b8df658c0",
"assets/assets/images/bg-home-web.png": "a88a1acd2f522ccdf460d8c8ed1f628e",
"assets/assets/images/ads-1.jpg": "cf7daca53fb4943883c6a0547d501972",
"assets/assets/images/ic-napas247.png": "f6c557ed224514a70743401191d2325c",
"assets/assets/images/logo-mb.png": "db5d9ada04bae4da0999277906a6d105",
"assets/assets/images/ic-business-introduction.png": "d80612c5cb1ffa8717739ab2ef93f0a0",
"assets/assets/images/logo-vietqr-admin.png": "8e6140fd32bc2b7325801cc3df3dc31a",
"assets/assets/images/bg_napas_qr_has_amout.png": "cfc72b6ddbb782f7d783e871d9101373",
"assets/assets/images/logo-vietqr-vn.png": "042fc3e87ce05e3fc36cc17c66ea288b",
"assets/assets/images/ic-hook-blue.png": "6ca62574c8bb4d3d766ae9d2fa7d58d7",
"assets/assets/images/ic-avatar.png": "40d36a273b69d7c5599bad0323e5250e",
"assets/assets/images/ic-checked.png": "3ef4ba72e0e54234fd370bd87713795c",
"assets/assets/images/ic-setting-header.png": "6ab58e79229235941752ce38df6a59be",
"assets/assets/images/bg_napas_qr.png": "32aab9008174212bd15f6cdc2ae5251f",
"assets/assets/images/bg-member-card.png": "3eddbad52d575690a83ed99bbf86a561",
"assets/assets/images/ic-key-blue.png": "f7f51ea75d25ca8d3c0a178471e7a4da",
"assets/assets/images/ic-card-unselect.png": "a1117931f5535e4e34bf91282793b05e",
"assets/assets/images/ic-user-unselect.png": "76fe326606586ceb4c222a35d2bee72c",
"assets/assets/images/ic-qr-payment-selected.png": "e52d7d39f4e72a861cb993cb78b7e6ef",
"assets/assets/images/ic-dashboard-unselect.png": "ed9337a26642e3317f9377dcd2726162",
"assets/assets/images/ic-share-code.png": "a035964f9346a4d1a649a20d7d340588",
"assets/assets/images/bg-admin-card.png": "53e1efeaa72c5ee4c49059f13484a17d",
"assets/assets/images/ic-qr-unselect.png": "83c2381d6f1791704bd525fdf9adb033",
"assets/assets/images/splash.png": "50d0983e8566586ec0b2c44a903c76bd",
"assets/assets/images/ic-dashboard.png": "07bcad74b80d2881c7c73d40abc00b24",
"assets/assets/images/bg-bank-card.png": "a735b43d2849891671bd48cf1231d4fa",
"assets/assets/images/ic-pop.png": "aebd963f3c030c6bf4b43849a4aca956",
"assets/assets/images/ic-point.png": "5211bb8ae129b9024d332e62e600c6b1",
"assets/assets/images/ic-viet-qr-org.png": "33b5f490256101e8e9e2b7ddd8966434",
"assets/assets/images/ic-card-nfc.png": "5b62d0915c1363eda33e0cd48ce34f66",
"assets/assets/images/logo.png": "e2764cb2c470a8114d1354ce69c657e8",
"assets/assets/images/ic-qr-payment-unselect.png": "e20ac42b03047081d7f277d23717ab2a",
"assets/assets/images/ic-scan-qr-frame.png": "49687ef22e5a20f65aa57591b61e4c59",
"assets/assets/images/ic-user.png": "96baf1f6ff0c95d638ee7847b27dd6d8",
"assets/assets/images/logo-app-store.png": "10668f07af514ea7e6e386e33b8b49b9",
"assets/assets/images/ic-member.png": "577d92f9a79b5802c17be71387318a86",
"assets/assets/images/ic-dark-web.png": "ef6d712e0690aa1a8461f5f7a08b2ef4",
"assets/assets/images/ic-maintain.png": "f6b71085994495761d1da7affd17f376",
"assets/assets/images/ic-personal-card.png": "dd9669b695721003b8283254513c233a",
"assets/assets/images/ic-card-selected.png": "50428edd96b5da68df1234fcaf77b512",
"assets/assets/images/bg_napas_qr_has_amout_content.png": "8f41b29330656966e839f7ea482a2ac7",
"assets/assets/images/ic-uncheck.png": "5afe9d1df5cdfbce671ae8b28005d2d5",
"assets/assets/images/ic-card.png": "60f3cf2a1a5c03109d657ef43906d95e",
"assets/assets/images/ic-printer.png": "f5aa580c9b75645159ab23e6e19aa6e3",
"assets/assets/images/bg-qr-vqr.png": "cb23b24bb590f7d84dcadf4bb70312b0",
"assets/assets/images/ic-viet-qr.png": "ad4b764b5840265e82308b1a362d7348",
"assets/assets/images/ic-unhide.png": "4920ce9e253e0301fb31d3b7bb5425f3",
"assets/assets/images/ic-theme-blue.png": "bbeb2bcf0da25e1e6580316ffcd748c8",
"assets/assets/images/ic-viet-qr-small-trans.png": "3c02cb8795b1549abf3a54e481ea187e",
"assets/assets/images/bg-qr.png": "1feb906ab766cc066be47b331ed0237c",
"assets/assets/images/ic-viet-qr-small.png": "befe0aaea723d18aa0afea2c2ef994a6",
"assets/assets/images/ic-disconnect.png": "47efbbba5ada5c3e21d22c55f0bf5498",
"assets/assets/images/ic-qr.png": "f6f6d61bfdb5e00104820ce0edcc2bba",
"assets/assets/images/ic-dropdown.png": "94d7102385a1ad012b994b69eeb5aad6",
"assets/assets/icons_menu/ic-menu-intro-vietqrvn.png": "52e0941bd9a89c6a6110045a3c5f676c",
"assets/assets/icons_menu/ic-menu-add-bank.png": "5beefeb6ec33caff820f14aed7097d0e",
"assets/assets/icons_menu/ic-menu-setting.png": "6d8b496dff3846e380631024378311ac",
"assets/assets/icons_menu/ic-menu-scan-cccd.png": "a43a11ceee60c6161e4873d649a7623a",
"assets/assets/icons_menu/ic-menu-logout.png": "f6f33c09cd1bd113abf1dd1b665dfe70",
"assets/assets/icons_menu/ic-menu-home.png": "6a27708aef757d7bf96796a4123c60c2",
"assets/assets/icons_menu/ic-menu-scan-bank.png": "923b23bbc155f3b91e3e3d66cb5fe1ed",
"assets/assets/icons_menu/ic-menu-contact.png": "ce7c7f77171f4f987b872164e9d74fa6",
"assets/assets/icons_menu/ic-menu-qr.png": "3f059092820d78cbe2287f38cc1c9b7f",
"assets/assets/icons_menu/ic-menu-new-mb.png": "190b944024570dc19e90a3b7fd31d6cd",
"assets/assets/icons_menu/ic-menu-business.png": "08d133c786892159ebc3eea8ef6467fc",
"assets/assets/icons_menu/ic-menu-linked.png": "873f203f150454d914d9af6b71194751",
"assets/assets/icons_menu/ic-menu-bank.png": "235110435814e893edd88b0ccbcb2fb5",
"assets/assets/sounds/prefix_transaction.mp3": "e0b0336c32dfb126523403f43f82f483",
"assets/assets/fonts/SF-Pro.ttf": "f8c47fea9e75c043c84babfd127ae023",
"toast.js": "40d00dd51847173ff28b4421e7511674",
"canvaskit/skwasm.js": "5d4f9263ec93efeb022bb14a3881d240",
"canvaskit/skwasm.js.symbols": "c3c05bd50bdf59da8626bbe446ce65a3",
"canvaskit/canvaskit.js.symbols": "74a84c23f5ada42fe063514c587968c6",
"canvaskit/skwasm.wasm": "4051bfc27ba29bf420d17aa0c3a98bce",
"canvaskit/chromium/canvaskit.js.symbols": "ee7e331f7f5bbf5ec937737542112372",
"canvaskit/chromium/canvaskit.js": "901bb9e28fac643b7da75ecfd3339f3f",
"canvaskit/chromium/canvaskit.wasm": "399e2344480862e2dfa26f12fa5891d7",
"canvaskit/canvaskit.js": "738255d00768497e86aa4ca510cce1e1",
"canvaskit/canvaskit.wasm": "9251bb81ae8464c4df3b072f84aa969b",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
