'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "08570c2f1e6f360c80d1ab08ee579c35",
"assets/AssetManifest.bin.json": "18d3b7234890c7a29944cef7a7169b84",
"assets/AssetManifest.json": "05e57360a70357f6f0dfa07c11c3ecad",
"assets/assets/fonts/IRANSansXFaNum-Bold.ttf": "f3942a4d1852bd1e5c557c0d2f1c9e53",
"assets/assets/fonts/IRANSansXFaNum-DemiBold.ttf": "687f73e6d53611b6b7a491d01dd79b37",
"assets/assets/fonts/IRANSansXFaNum-Medium.ttf": "e80730f952b42aea6adc1837bdef0318",
"assets/assets/fonts/IRANSansXFaNum-Regular.ttf": "32e900508cd1f6220303f167f032df1f",
"assets/assets/fonts/POPPINS-SEMIBOLD.ttf": "e0fdfd23da3dcbd115fa4c06f38dd2d7",
"assets/assets/fonts/ProductSans-Bold.ttf": "f9baffe062f0448bd9f1a19404062732",
"assets/assets/fonts/ProductSans-Medium.ttf": "27b6dc324137dc58114f9b5ad1cb51a7",
"assets/assets/fonts/ProductSans-Regular.ttf": "bf3d592f44d0e2a5889ac5934aec4741",
"assets/assets/icons/activity-a.svg": "81a43b2b5b0d0737fe145445e4c995ea",
"assets/assets/icons/activity.svg": "98f8414f1b9ff681abc614150ab13af0",
"assets/assets/icons/arrow-up.svg": "e39d2920803554df93e338a03c6e9c2c",
"assets/assets/icons/attach.svg": "cea6c0b2512242c65acfcd78f755912f",
"assets/assets/icons/autumn.svg": "0fd46f2cd07a46312b7536ab275fa24e",
"assets/assets/icons/avatar.svg": "abf664dc6333b92b3d23fdac760d73dc",
"assets/assets/icons/board-tasks-a.svg": "39c06a24f7afb7cce36f95b59f99edf7",
"assets/assets/icons/board-tasks.svg": "300f058b2d488e12a8672035e92a1146",
"assets/assets/icons/board.svg": "9b3c0ae5eb6253dca0799b2fafb60847",
"assets/assets/icons/calculate.svg": "a7860e9c4ea076381a93e6e0f4f50b33",
"assets/assets/icons/calendar.svg": "79f070dd0e117e91a81d42e2c99645da",
"assets/assets/icons/calendar1.svg": "688220ac4519114799d12b1a68781517",
"assets/assets/icons/check-in.svg": "66dc9f71b50d570dcabd9098122fe4bd",
"assets/assets/icons/check-out.svg": "e7bf6c22cfe9ab1a877a0e314b695909",
"assets/assets/icons/check.svg": "ef252b1713f8280910f79559ed816776",
"assets/assets/icons/chevron-up-down.svg": "e82dca1fd37eef3cf1293f26989b4ae1",
"assets/assets/icons/cir.svg": "b865f0c6b17c7601459003723bec1bf6",
"assets/assets/icons/circle_clock.svg": "96c9169ffbf549065eb95eaa15c9fb7c",
"assets/assets/icons/clock-add-plus-a.svg": "3418c140b4f3c2bb15f3d155f52a8b18",
"assets/assets/icons/clock-add-plus.svg": "75008fba36ca8d15ca32806220e9050a",
"assets/assets/icons/clock-add.svg": "44061da9466d0e764fc819ee5d68124b",
"assets/assets/icons/clock-close.svg": "0755224a2dbe776499ea8ad8c4b45cc5",
"assets/assets/icons/clock-dash.svg": "9c0429258dfba9d73daeb2b08267ba0d",
"assets/assets/icons/code.svg": "bf88daef7d3e17e0c42da57811ecf16b",
"assets/assets/icons/combined.svg": "7602fc5c52469acffac8c19d7cfacee7",
"assets/assets/icons/delete.svg": "0fded0a1c0f3f847f22d99831d820bc4",
"assets/assets/icons/docs.svg": "8c216eb028cab520df44cfb1f436afe0",
"assets/assets/icons/document_pdf.svg": "920dbe4550868faa6f194d88a8cf3c85",
"assets/assets/icons/download.svg": "6d6d75d043a1027bd11795a8105a6294",
"assets/assets/icons/filter.svg": "d99ea6b4e5b2c420006350b7915906fc",
"assets/assets/icons/flag.svg": "a9e993ab774a89e76651909b0d45c532",
"assets/assets/icons/info.svg": "fdca87642a562a70f9f2d8350dce31ff",
"assets/assets/icons/leaves.svg": "5f8fbd4b463bf590de7e2d3f4f6c9551",
"assets/assets/icons/leaves_off.svg": "a80d43affe012dbb12852ff77915e51c",
"assets/assets/icons/location.svg": "d1411f57001a86513e40e224d9a1ead4",
"assets/assets/icons/logout.svg": "da906abb36f8839fd23e59bd0fb7fbf6",
"assets/assets/icons/notification-s.svg": "ac67699acd7fd28d4e785cfb2c916cbc",
"assets/assets/icons/notification.svg": "5d900b840383c8aa6d7efe123c2c16d3",
"assets/assets/icons/pause.svg": "7c7b5493d415245c31af46b241279817",
"assets/assets/icons/play.svg": "24ad69068f93bb6a1dee35d06b7ed0e3",
"assets/assets/icons/plus.svg": "f0b082ec347251c7975cdea01e98eb72",
"assets/assets/icons/question.svg": "acf336969f06716780312e1addfde83d",
"assets/assets/icons/radio.svg": "00e26fef184ccf9254c1460f1b0cbaf1",
"assets/assets/icons/ringing.svg": "02035aa12485bee454105153338bb96f",
"assets/assets/icons/scale.svg": "ace909d00f0bf5bc29c2efd9fda2ced5",
"assets/assets/icons/setting.svg": "91ea5eacc6178e16dfb30d023ea63b51",
"assets/assets/icons/spring.svg": "09f2c6463d708978a06ed7a6039ef9a0",
"assets/assets/icons/star.svg": "d01aba3050eba1122e864565e6cd8117",
"assets/assets/icons/summer.svg": "555ccdff64278e13fc792768d1ddf560",
"assets/assets/icons/tag.svg": "b2b13802c5e7d8b5a8a0796c50164b06",
"assets/assets/icons/task.svg": "4141dbdfd981621700a512ae1d51efc4",
"assets/assets/icons/timer-off-sleep.svg": "2b234a6603df4facbf19bb917d562b2d",
"assets/assets/icons/timer-tick-2.svg": "dd7d8c57319c673942347a15b6c72e8c",
"assets/assets/icons/timer-tick-3.svg": "d6bcd322da6d92bb53c18a9dd7b03d50",
"assets/assets/icons/timer-tick-4.svg": "198498d611c829fde6725ef7e9222d1e",
"assets/assets/icons/timer-tick.svg": "594ceda72ea4bc432c34e9b7209174a4",
"assets/assets/icons/user.svg": "bcc83c6b7702b69bce0d0f3529cadfcc",
"assets/assets/icons/verify.png": "3c0462ae55d61386550ec01b33d01da8",
"assets/assets/icons/wallet.svg": "1aefbc2570e0c6a564c696fbdca6310c",
"assets/assets/icons/winter.svg": "711aa67959e4de512a14efee3ef61570",
"assets/assets/images/img.svg": "653463c5e44a707663d9562e4daecdac",
"assets/assets/images/logo.png": "100ab225c330b1caad5af3ede1189660",
"assets/assets/images/mp3.svg": "4aa040dfb8001a426b9ed921a4c21317",
"assets/assets/images/pdf.svg": "dd15434f9d77cfc98138199f4b31228f",
"assets/assets/images/xls.svg": "801ce23fef9bed470f4620baba624975",
"assets/assets/translations/ar.json": "46867d1877abba4f15731d45d9602b9c",
"assets/assets/translations/en.json": "e7a31ce4ef4d5560f5d82df7b578d2e1",
"assets/assets/translations/fa.json": "4e738463f2109f712203d86ae0ade7c2",
"assets/FontManifest.json": "bab8ef43ad5ac1814197a7ed8bf9d019",
"assets/fonts/MaterialIcons-Regular.otf": "c7edc48a5c3a9d56ce7318bb27d4ae1a",
"assets/NOTICES": "3afb95a4ce1e5340563ccec8f2605930",
"assets/packages/calendar_pro_farhad/assets/fonts/IRANSansXFaNum-Bold.ttf": "f3942a4d1852bd1e5c557c0d2f1c9e53",
"assets/packages/calendar_pro_farhad/assets/fonts/IRANSansXFaNum-DemiBold.ttf": "687f73e6d53611b6b7a491d01dd79b37",
"assets/packages/calendar_pro_farhad/assets/fonts/IRANSansXFaNum-Medium.ttf": "e80730f952b42aea6adc1837bdef0318",
"assets/packages/calendar_pro_farhad/assets/fonts/IRANSansXFaNum-Regular.ttf": "32e900508cd1f6220303f167f032df1f",
"assets/packages/calendar_pro_farhad/assets/icons/calendar.svg": "99e3ddfa66840b69d22476a5d13a1ef2",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "6cfe36b4647fbfa15683e09e7dd366bc",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/chromium/canvaskit.js": "ba4a8ae1a65ff3ad81c6818fd47e348b",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"favicon.png": "d08656166d2e0f432ece1d1ab98a2250",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"flutter_bootstrap.js": "62812a6eae41a35e8b327b92f2e86bb8",
"icons/Icon-192.png": "883311d11737d66e952972dd0489c87e",
"icons/Icon-512.png": "543eabab53fb8e212747b37b90a44610",
"icons/Icon-maskable-192.png": "883311d11737d66e952972dd0489c87e",
"icons/Icon-maskable-512.png": "543eabab53fb8e212747b37b90a44610",
"index.html": "712343cbb6feafda4d179d6dbb6fb025",
"/": "712343cbb6feafda4d179d6dbb6fb025",
"main.dart.js": "9cb61b6d66892f08fc9507ef829b4318",
"manifest.json": "18e019f351a70e7e53a2f261b4d8dab5",
"version.json": "160178d4d5fc7cea5597b5128025fe98"};
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
