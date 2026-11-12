const CACHE='onda-auto-v1';
const ASSETS=['./','./index.html','./manifest.webmanifest','./icon.svg'];
self.addEventListener('install',e=>e.waitUntil(caches.open(CACHE).then(c=>c.addAll(ASSETS)).then(()=>self.skipWaiting())));
self.addEventListener('activate',e=>e.waitUntil(self.clients.claim()));
self.addEventListener('fetch',e=>{
 const url=new URL(e.request.url);
 if(url.origin!==self.location.origin||e.request.method!=='GET')return;
 e.respondWith(fetch(e.request).catch(()=>caches.match(e.request)));
});