#!/usr/bin/env bash
# ينزّل المكتبات والخطوط إلى مجلد libs ليعمل البرنامج بلا إنترنت.
set -e
cd "$(dirname "$0")"
mkdir -p libs/fonts
get(){ echo "تنزيل: $2"; curl -fsSL --retry 3 "$1" -o "$2"; }
get https://cdn.jsdelivr.net/npm/peerjs@1.5.4/dist/peerjs.min.js libs/peerjs.min.js
get https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js libs/qrcode.min.js
get https://cdn.jsdelivr.net/npm/jsqr@1.4.0/dist/jsQR.js libs/jsQR.js
# الخطوط اختيارية: إن فشل تنزيلها يستخدم البرنامج خط الجهاز
for w in 400 500 600 700; do
  for s in arabic latin; do
    f="ibm-plex-sans-arabic-$s-$w-normal.woff2"
    curl -fsSL --retry 2 "https://cdn.jsdelivr.net/npm/@fontsource/ibm-plex-sans-arabic/files/$f" -o "libs/fonts/$f" || { echo "تخطي الخط: $f"; rm -f "libs/fonts/$f"; }
  done
done
echo "تم. الملفات في مجلد libs"
