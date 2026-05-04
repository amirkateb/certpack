# SSL Certificate Auto Generator Script

A simple interactive bash script to generate Let's Encrypt SSL certificates and package them for easy deployment (including Patchim platform compatibility).

---

## 🚀 One-line Install & Run

bash <(curl -s https://raw.githubusercontent.com/amirkateb/certpack/main/get-cert.sh)

---

## 📌 Features

- Interactive input (domain, email, extra domains)
- Supports multiple domains (SAN)
- Patchim-compatible output (server.crt + server.key)
- Normal mode (fullchain.pem, privkey.pem, etc.)
- Automatic ZIP packaging
- Minimal and clean setup

---

## 🧾 Requirements

- Ubuntu / Debian server
- Root access
- Nginx installed and running
- Port 80 open
- Domain DNS pointing to your server

---

## ⚙️ Usage Guide (English)

1. Run the script:
   bash    bash <(curl -s bash <(curl -s https://raw.githubusercontent.com/amirkateb/certpack/main/get-cert.sh)    

2. Enter:
   - Main domain
   - Email
   - Additional domains (optional)
   - Mode (Patchim or Normal)

3. After completion, a ZIP file will be created in:
      /root/cert-output/   

---

## 📦 Deployment

### Patchim Mode

1. Extract the ZIP file:
   bash    unzip cert-patchim.zip    

2. Move files to:
      /etc/nginx/ssl   

3. Replace existing files with:
   - server.crt
   - server.key

4. Restart Nginx:
   bash    systemctl restart nginx    

---

### Normal Mode

1. Extract ZIP:
   bash    unzip cert-normal.zip    

2. Use files as needed:
   - fullchain.pem
   - privkey.pem
   - cert.pem
   - chain.pem

3. Replace your existing SSL config files

4. Restart Nginx:
   bash    systemctl restart nginx    

---

## 🧭 راهنمای استفاده (فارسی)

### اجرا

با یک دستور اسکریپت را اجرا کنید:

bash <(curl -s https://raw.githubusercontent.com/amirkateb/certpack/main/get-cert.sh) 

---

### مراحل

بعد از اجرا، از شما سوال می‌شود:

- دامنه اصلی
- ایمیل
- دامنه‌های اضافی (در صورت وجود)
- نوع خروجی (پچیم یا نرمال)

---

### محل خروجی

فایل زیپ در مسیر زیر ساخته می‌شود:

/root/cert-output/

---

## 📦 نحوه استفاده از خروجی

### حالت پچیم

1. فایل زیپ را استخراج کنید:
   bash    unzip cert-patchim.zip    

2. فایل‌ها را در مسیر زیر قرار دهید:
      /etc/nginx/ssl   

3. فایل‌های قبلی را با این‌ها جایگزین کنید:
   - server.crt
   - server.key

4. سپس nginx را ریستارت کنید:
   bash    systemctl restart nginx    

---

### حالت نرمال

1. فایل زیپ را استخراج کنید:
   bash    unzip cert-normal.zip    

2. فایل‌ها شامل:
   - fullchain.pem
   - privkey.pem
   - cert.pem
   - chain.pem

3. در مسیرهای مورد نظر خود جایگزین کنید

4. در نهایت nginx را ریستارت کنید:
   bash    systemctl restart nginx    

---

## ⚠️ Notes

- DNS دامنه باید به سرور اشاره کند
- پورت 80 باید باز باشد
- اگر خطا گرفتید، nginx config را بررسی کنید

---

## 📄 Lic
