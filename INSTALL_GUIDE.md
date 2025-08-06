# คู่มือการติดตั้งและรันแอป Firebase Auth Flutter

## 🚀 วิธีรันแอปอย่างรวดเร็ว

### วิธีที่ 1: ใช้ไฟล์ Script (แนะนำ)

1. **ดับเบิลคลิกไฟล์ `run_app.bat`** หรือ **`run_app.ps1`**
2. รอให้ระบบตรวจสอบและติดตั้ง dependencies
3. แอปจะรันอัตโนมัติ

### วิธีที่ 2: ใช้ Command Line

```bash
# เปิด PowerShell ในโฟลเดอร์โปรเจค
flutter pub get
flutter run
```

## 📋 ขั้นตอนการติดตั้ง Flutter (หากยังไม่ได้ติดตั้ง)

### 1. ดาวน์โหลด Flutter SDK

1. ไปที่: https://docs.flutter.dev/get-started/install/windows
2. ดาวน์โหลด Flutter SDK
3. แตกไฟล์และวางใน `C:\flutter`

### 2. เพิ่ม Flutter ใน PATH

1. กด `Win + R` พิมพ์ `sysdm.cpl` กด Enter
2. ไปที่แท็บ "Advanced" > "Environment Variables"
3. ใน "System variables" เลือก "Path" > "Edit"
4. เพิ่ม `C:\flutter\bin` (หรือที่ที่คุณวาง Flutter)
5. กด OK ทั้งหมด

### 3. ตรวจสอบการติดตั้ง

เปิด Command Prompt หรือ PowerShell ใหม่ แล้วรัน:

```bash
flutter doctor
```

หากเห็นข้อความแสดง Flutter version แสดงว่าติดตั้งสำเร็จ

## 🔧 การแก้ไขปัญหา

### ปัญหา: "flutter is not recognized"

**วิธีแก้:**
1. ตรวจสอบว่าได้เพิ่ม Flutter ใน PATH แล้ว
2. รีสตาร์ท Command Prompt หรือ PowerShell
3. ลองรัน `flutter doctor` อีกครั้ง

### ปัญหา: Dependencies ไม่ติดตั้ง

**วิธีแก้:**
```bash
flutter clean
flutter pub get
```

### ปัญหา: Build errors

**วิธีแก้:**
```bash
flutter clean
flutter pub get
flutter run
```

## 📱 การใช้งานแอป

### ฟีเจอร์หลัก:
- ✅ **ปุ่มเข้าสู่ระบบ**: กดเพื่อเข้าสู่ระบบแบบ Anonymous
- ✅ **แสดงสถานะ**: แสดงสถานะการเข้าสู่ระบบแบบ Real-time
- ✅ **ปุ่มออกจากระบบ**: กดเพื่อออกจากระบบ
- ✅ **การแสดงผล**: แสดง User ID เมื่อเข้าสู่ระบบสำเร็จ

### คำสั่งในแอป:
- กด `r` เพื่อ hot reload
- กด `R` เพื่อ hot restart
- กด `q` เพื่อออกจากแอป

## 🎯 เป้าหมาย

แอปนี้เป็นตัวอย่างพื้นฐานสำหรับ Firebase Authentication ใน Flutter พร้อม UI ที่สวยงามและใช้งานง่าย

หากมีปัญหาอะไรเพิ่มเติม กรุณาติดต่อหรือดูเอกสารเพิ่มเติมใน README.md 