@echo off
chcp 65001 >nul
cd /d "%~dp0"
if not exist libs\fonts mkdir libs\fonts
echo تنزيل المكتبات...
curl.exe -fsSL --retry 3 https://cdn.jsdelivr.net/npm/peerjs@1.5.4/dist/peerjs.min.js -o libs\peerjs.min.js || goto :err
curl.exe -fsSL --retry 3 https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js -o libs\qrcode.min.js || goto :err
curl.exe -fsSL --retry 3 https://cdn.jsdelivr.net/npm/jsqr@1.4.0/dist/jsQR.js -o libs\jsQR.js || goto :err
for %%w in (400 500 600 700) do for %%s in (arabic latin) do (
  curl.exe -fsSL --retry 2 https://cdn.jsdelivr.net/npm/@fontsource/ibm-plex-sans-arabic/files/ibm-plex-sans-arabic-%%s-%%w-normal.woff2 -o libs\fonts\ibm-plex-sans-arabic-%%s-%%w-normal.woff2 || del libs\fonts\ibm-plex-sans-arabic-%%s-%%w-normal.woff2 2>nul
)
echo تم. الملفات في مجلد libs
pause
exit /b 0
:err
echo فشل التنزيل. تحقق من الاتصال بالإنترنت.
pause
exit /b 1
