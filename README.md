# CertPack

Interactive SSL certificate generator using Let's Encrypt (Certbot) with automatic packaging for deployment (Patchim & standard formats).

---

## 🚀 One-line Install & Run

```text
 bash <(curl -s https://raw.githubusercontent.com/amirkateb/certpack/main/get-cert.sh) 
```
---

## 📌 Features

- Interactive CLI (domain, email, multi-domain)
- Supports HTTP challenge (automatic)
- Supports DNS challenge (manual, wildcard ready)
- Patchim-compatible output (server.crt + server.key)
- Standard output (fullchain.pem, privkey.pem, etc.)
- Automatic ZIP packaging
- Clean and minimal design

---

## 🧾 Requirements

- Ubuntu / Debian server
- Root access
- Nginx (for HTTP mode)
- Port 80 open (for HTTP mode)
- Domain DNS pointed to server

---

## ⚙️ Usage Guide (English)

### 1. Run script

```text
 bash <(curl -s https://raw.githubusercontent.com/amirkateb/certpack/main/get-cert.sh) 
```
---

### 2. Provide inputs

- Main domain
- Email
- Additional domains (optional)
- Challenge type:
  - HTTP (automatic via Nginx)
  - DNS (manual TXT record, supports wildcard)
- Output mode:
  - Patchim
  - Normal

---

### 3. Output location

```text
 /root/cert-output/ 
```
ZIP files:
- cert-patchim.zip
- cert-normal.zip

---

## 🌐 Challenge Types

### 🔹 HTTP Challenge (Automatic)

- Uses Nginx
- Requires port 80
- Fully automatic

---

### 🔹 DNS Challenge (Manual)

- Supports wildcard (*.domain.com)
- Certbot will show a TXT record like:

_acme-challenge.example.com TXT "TOKEN"

#### Steps:

1. Go to your DNS provider (Cloudflare, etc)
2. Add TXT record
3. Wait for propagation
4. Press Enter in terminal

---

## 📦 Deployment

### 🔸 Patchim Mode

1. Extract ZIP:

```text
 unzip cert-patchim.zip 
```
2. Move files to:

/etc/nginx/ssl

3. Replace:

- server.crt
- server.key

4. Restart Nginx:

```text
 systemctl restart nginx 
```
---

### 🔸 Normal Mode

1. Extract ZIP:

bash unzip cert-normal.zip 

2. Files included:

- fullchain.pem
- privkey.pem
- cert.pem
- chain.pem

3. Replace in your SSL config paths

4. Restart Nginx:

```text
 systemctl restart nginx 
```
---

## 🧭 راهنمای استفاده (فارسی)

### اجرا

```text
 bash <(curl -s https://raw.githubusercontent.com/amirkateb/certpack/main/get-cert.sh) 
```
---

### مراحل

پس از اجرا:

- دامنه اصلی را وارد کنید
- ایمیل را وارد کنید
- در صورت وجود، دامنه‌های اضافی را وارد کنید
- نوع چالش را انتخاب کنید:
  - HTTP (اتوماتیک)
  - DNS (دستی، مناسب wildcard)
- نوع خروجی را انتخاب کنید:
  - پچیم
  - نرمال

---

### 📍 محل خروجی

```text
 /root/cert-output/ 
```
---

## 📦 استفاده از خروجی

### 🔸 حالت پچیم

1. استخراج:

```text
 unzip cert-patchim.zip
```

2. انتقال به:

/etc/nginx/ssl

3. جایگزینی فایل‌ها:

- server.crt
- server.key

4. ریستارت nginx:

```text
 systemctl restart nginx 
```
---

### 🔸 حالت نرمال

1. استخراج:

```text
 unzip cert-normal.zip 
```
2. فایل‌ها:

- fullchain.pem
- privkey.pem
- cert.pem
- chain.pem

3. جایگزینی در مسیرهای SSL

4. ریستارت nginx:

```text
systemctl restart nginx 
```
---

## ⚠️ Notes

- DNS باید به سرور اشاره کند
- در حالت HTTP، پورت 80 باید باز باشد
- در حالت DNS، propagation ممکن است چند دقیقه زمان ببرد
- اگر خطا داشتید، nginx config را بررسی کنید

---

## 📄 License (MIT)

```text
MIT License

Copyright (c) 2026 amirkateb

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction.
