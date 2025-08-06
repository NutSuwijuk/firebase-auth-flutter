# คู่มือการตั้งค่า Google Sign-In

## 🔧 ขั้นตอนการตั้งค่า

### 1. ตั้งค่า Firebase Console

1. ไปที่ [Firebase Console](https://console.firebase.google.com/)
2. เลือกโปรเจคของคุณ
3. ไปที่ **Authentication** > **Sign-in method**
4. เปิดใช้งาน **Google** provider

### 2. ตั้งค่า Google Cloud Console

1. ไปที่ [Google Cloud Console](https://console.cloud.google.com/)
2. เลือกโปรเจคเดียวกับ Firebase
3. ไปที่ **APIs & Services** > **Credentials**
4. สร้าง **OAuth 2.0 Client ID** สำหรับ Android/iOS

### 3. สำหรับ Android

#### 3.1 เพิ่ม SHA-1 fingerprint

```bash
# สำหรับ debug
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

# สำหรับ release
keytool -list -v -keystore your-release-key.keystore -alias your-key-alias
```

#### 3.2 ตั้งค่าใน Firebase Console

1. ไปที่ **Project Settings** > **Your apps** > **Android**
2. เพิ่ม SHA-1 fingerprint
3. ดาวน์โหลด `google-services.json` ใหม่

### 4. สำหรับ iOS

#### 4.1 ตั้งค่า URL Scheme

1. เปิด `ios/Runner/Info.plist`
2. เพิ่ม URL scheme:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>REVERSED_CLIENT_ID</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.googleusercontent.apps.YOUR_CLIENT_ID</string>
        </array>
    </dict>
</array>
```

#### 4.2 ดาวน์โหลด GoogleService-Info.plist

1. ไปที่ Firebase Console > Project Settings > Your apps > iOS
2. ดาวน์โหลด `GoogleService-Info.plist`
3. วางใน `ios/Runner/`

### 5. สำหรับ Web

#### 5.1 ตั้งค่า Authorized Domains

1. ไปที่ Firebase Console > Authentication > Settings
2. เพิ่ม domain ใน **Authorized domains**

#### 5.2 ตั้งค่า OAuth Consent Screen

1. ไปที่ Google Cloud Console > APIs & Services > OAuth consent screen
2. เพิ่ม domain ใน **Authorized domains**

## 🚀 การทดสอบ

### 1. รันแอป

```bash
flutter run
```

### 2. ทดสอบ Google Sign-In

1. กดปุ่ม "เข้าสู่ระบบด้วย Google"
2. เลือกบัญชี Google
3. ตรวจสอบว่าข้อมูลแสดงถูกต้อง

## 🔧 การแก้ไขปัญหา

### ปัญหา: "Sign in failed"

**วิธีแก้:**
1. ตรวจสอบ SHA-1 fingerprint
2. ตรวจสอบ OAuth Client ID
3. ตรวจสอบ Firebase configuration

### ปัญหา: "Network error"

**วิธีแก้:**
1. ตรวจสอบการเชื่อมต่ออินเทอร์เน็ต
2. ตรวจสอบ Firebase project settings
3. ตรวจสอบ Google Cloud Console settings

### ปัญหา: "Invalid client"

**วิธีแก้:**
1. ตรวจสอบ OAuth Client ID
2. ตรวจสอบ Authorized domains
3. ตรวจสอบ Package name/Bundle ID

## 📱 ฟีเจอร์ที่ได้

- ✅ **Google Sign-In** แบบเต็มรูปแบบ
- ✅ **แสดงข้อมูลผู้ใช้** (ชื่อ, อีเมล, User ID)
- ✅ **UI สวยงาม** ตามรูปภาพ
- ✅ **การจัดการข้อผิดพลาด**
- ✅ **Loading states**

## 🎯 หมายเหตุ

- แอปนี้ใช้ Google Sign-In จริง ไม่ใช่การจำลอง
- ต้องตั้งค่า Firebase และ Google Cloud Console ให้ถูกต้อง
- สำหรับการใช้งานจริง ควรเพิ่มการจัดการ state และ navigation 