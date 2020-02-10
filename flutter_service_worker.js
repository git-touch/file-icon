'use strict';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "/index.html": "2caff57a9e84276f37776c9b0d161194",
"/assets/packages/file_icon/fonts/seti.ttf": "2b67c27356467781d7786c59ca58b34f",
"/assets/AssetManifest.json": "a725d3bb5ed6b5c0fd5b834bb5167ab2",
"/assets/LICENSE": "44d84e5395270c35c3cd5064dce02a04",
"/assets/FontManifest.json": "ef09e1b44e3b199b0487a04e18684209",
"/assets/fonts/MaterialIcons-Regular.ttf": "56d3ffdef7a25659eab6a68a3fbfaf16",
"/main.dart.js": "03459c171bbce818e597d9e1968ecd46"
};

self.addEventListener('activate', function (event) {
  event.waitUntil(
    caches.keys().then(function (cacheName) {
      return caches.delete(cacheName);
    }).then(function (_) {
      return caches.open(CACHE_NAME);
    }).then(function (cache) {
      return cache.addAll(Object.keys(RESOURCES));
    })
  );
});

self.addEventListener('fetch', function (event) {
  event.respondWith(
    caches.match(event.request)
      .then(function (response) {
        if (response) {
          return response;
        }
        return fetch(event.request, {
          credentials: 'include'
        });
      })
  );
});
