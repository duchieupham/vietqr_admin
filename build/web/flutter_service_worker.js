'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "version.json": "e4fe985f9fb3b074ab4690f22b388d4b",
"index.html": "def398557bbc716766788195fe7c2bbc",
"/": "def398557bbc716766788195fe7c2bbc",
"main.dart.js": "bc2d097be3e26b3462c42c9814aac873",
"flutter.js": "1cfe996e845b3a8a33f57607e8b09ee4",
"favicon.png": "b65731f1a32e881fcb00e13d1efa5961",
"icons/Icon-192.png": "e88f1a8f6d591e4dfb9b47a2b92ae3bf",
"icons/Icon-maskable-192.png": "e88f1a8f6d591e4dfb9b47a2b92ae3bf",
"icons/Icon-maskable-512.png": "689baf8f2a853c985d049606a04a6470",
"icons/Icon-512.png": "689baf8f2a853c985d049606a04a6470",
"manifest.json": "1e596a960139a054b2e54b567bb03378",
"assets/AssetManifest.json": "f8aeaea44a7f4c5a0749199bb17e452b",
"assets/NOTICES": "2fe3f95e2470bfeb6142934bc668fd09",
"assets/FontManifest.json": "c2a05e02fe4b179c51cdade9d95e6544",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/packages/fluttertoast/assets/toastify.js": "56e2c9cedd97f10e7e5f1cebd85d53e3",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
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
"canvaskit/canvaskit.js": "97937cb4c2c2073c968525a3e08c86a3",
"canvaskit/profiling/canvaskit.js": "c21852696bc1cc82e8894d851c01921a",
"canvaskit/profiling/canvaskit.wasm": "371bc4e204443b0d5e774d64a046eb99",
"canvaskit/canvaskit.wasm": "3de12d898ec208a5f31362cc00f09b9e"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
"index.html",
"assets/AssetManifest.json",
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
