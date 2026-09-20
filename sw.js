/* عامل الخدمة: يحفظ البرنامج والمكتبات على الجهاز ليعمل بلا اتصال.
   غيّر رقم الإصدار عند نشر تحديث لإجبار الأجهزة على تنزيل الملفات من جديد. */
const CACHE='lawh-v9';
const FILES=['./','./index.html','./manifest.webmanifest','./icon-192.png','./icon-512.png','./icon-maskable-512.png','./apple-touch-icon.png','./icon.svg',
 './peerjs.min.js','./qrcode.min.js','./jsQR.js','./pdf.min.mjs','./pdf.worker.min.mjs',
 ...[400,500,600,700].flatMap(w=>['arabic','latin'].map(s=>`./fonts/ibm-plex-sans-arabic-${s}-${w}-normal.woff2`))];
self.addEventListener('install',e=>{
  e.waitUntil((async()=>{
    const c=await caches.open(CACHE);
    await Promise.all(FILES.map(f=>c.add(f).catch(()=>{})));   // ملف ناقص لا يُفشل التثبيت
    self.skipWaiting();
  })());
});
self.addEventListener('activate',e=>{
  e.waitUntil((async()=>{
    for(const k of await caches.keys())if(k!==CACHE)await caches.delete(k);
    await self.clients.claim();
  })());
});
self.addEventListener('fetch',e=>{
  const r=e.request;
  if(r.method!=='GET')return;
  const u=new URL(r.url);
  if(u.origin!==location.origin)return;               // لا نتدخل في خادم الإشارة ولا الطلبات الخارجية
  e.respondWith((async()=>{
    const c=await caches.open(CACHE);
    const hit=await c.match(r,{ignoreSearch:true});
    const net=fetch(r).then(res=>{if(res&&res.ok)c.put(r,res.clone());return res}).catch(()=>null);
    if(hit){e.waitUntil(net);return hit}               // من الجهاز فورًا، وتحديث خلفي عند وجود اتصال
    const res=await net;if(res)return res;
    if(r.mode==='navigate')return(await c.match('./index.html'))||(await c.match('./'))||Response.error();
    return Response.error();
  })());
});
