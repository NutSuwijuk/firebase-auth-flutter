# Firebase Authentication Flutter Demo

โปรเจค Flutter พื้นฐานสำหรับทดสอบ Firebase Authentication พร้อม UI ที่ใช้งานง่าย

## คุณสมบัติ

- ✅ Anonymous Authentication (เข้าสู่ระบบแบบไม่ระบุตัวตน)
- ✅ Real-time authentication state monitoring
- ✅ UI ที่สวยงามและใช้งานง่าย
- ✅ การแสดงสถานะการโหลด
- ✅ การจัดการข้อผิดพลาด
- ✅ Material Design 3

## ขั้นตอนการติดตั้ง

### 1. ติดตั้ง Dependencies

รันคำสั่งต่อไปนี้เพื่อติดตั้ง dependencies:

```bash
flutter pub get
```

### 2. ติดตั้ง Firebase CLI

```bash
npm install -g firebase-tools
```

### 3. Login เข้า Firebase

```bash
firebase login
```

### 4. เริ่มต้น Firebase ในโปรเจค

```bash
firebase init
```

เลือกตัวเลือกต่อไปนี้:
- Hosting
- Firestore
- Authentication

### 5. เพิ่ม Firebase Configuration

#### สำหรับ Android:
1. ไปที่ [Firebase Console](https://console.firebase.google.com/)
2. สร้างโปรเจคใหม่หรือเลือกโปรเจคที่มีอยู่
3. เพิ่มแอป Android
4. ดาวน์โหลดไฟล์ `google-services.json`
5. วางไฟล์ใน `android/app/`

#### สำหรับ iOS:
1. เพิ่มแอป iOS ใน Firebase Console
2. ดาวน์โหลดไฟล์ `GoogleService-Info.plist`
3. วางไฟล์ใน `ios/Runner/`

#### สำหรับ Web:
1. เพิ่มแอป Web ใน Firebase Console
2. คัดลอก Firebase config
3. สร้างไฟล์ `lib/firebase_options.dart`

### 6. เปิดใช้งาน Anonymous Authentication

1. ไปที่ Firebase Console > Authentication
2. ไปที่แท็บ "Sign-in method"
3. เปิดใช้งาน "Anonymous"

## การใช้งาน

### รันแอป

```bash
flutter run
```

### ฟีเจอร์ที่มี

1. **ปุ่มเข้าสู่ระบบ**: กดเพื่อเข้าสู่ระบบแบบ Anonymous
2. **แสดงสถานะ**: แสดงสถานะการเข้าสู่ระบบแบบ Real-time
3. **ปุ่มออกจากระบบ**: กดเพื่อออกจากระบบ
4. **การแสดงผล**: แสดง User ID เมื่อเข้าสู่ระบบสำเร็จ

## โครงสร้างโค้ด

### ไฟล์หลัก

- `lib/main.dart` - ไฟล์หลักของแอปพลิเคชัน

### คลาสหลัก

- `MyApp` - Widget หลักของแอป
- `AuthScreen` - หน้าจอหลักสำหรับ Authentication
- `_AuthScreenState` - State management สำหรับ AuthScreen

### ฟังก์ชันสำคัญ

- `_signInAnonymously()` - ฟังก์ชันเข้าสู่ระบบแบบ Anonymous
- `_signOut()` - ฟังก์ชันออกจากระบบ
- `StreamBuilder<User?>` - Real-time monitoring ของ authentication state

## การปรับแต่ง

### เพิ่ม Authentication Methods อื่นๆ

คุณสามารถเพิ่ม authentication methods อื่นๆ ได้ เช่น:

```dart
// Email/Password Authentication
Future<void> _signInWithEmail(String email, String password) async {
  try {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  } catch (e) {
    // Handle error
  }
}

// Google Sign-In
Future<void> _signInWithGoogle() async {
  try {
    // Implement Google Sign-In
  } catch (e) {
    // Handle error
  }
}
```

### ปรับแต่ง UI

คุณสามารถปรับแต่ง UI ได้โดยการแก้ไข:

- สีและธีมใน `ThemeData`
- Layout และ spacing
- Icons และ typography

## การแก้ไขปัญหา

### ปัญหาที่พบบ่อย

1. **Firebase ไม่ initialize**
   - ตรวจสอบว่าได้เรียก `Firebase.initializeApp()` แล้ว
   - ตรวจสอบไฟล์ configuration

2. **Anonymous Authentication ไม่ทำงาน**
   - ตรวจสอบว่าได้เปิดใช้งานใน Firebase Console แล้ว
   - ตรวจสอบ Network connection

3. **Build errors**
   - รัน `flutter clean` แล้ว `flutter pub get`
   - ตรวจสอบ dependencies versions

## การพัฒนาเพิ่มเติม

### แนวทางในการพัฒนา

1. **เพิ่ม Authentication Methods**
   - Email/Password
   - Google Sign-In
   - Facebook Sign-In
   - Phone Number

2. **เพิ่มฟีเจอร์**
   - User Profile Management
   - Password Reset
   - Email Verification

3. **ปรับปรุง UI/UX**
   - Custom Themes
   - Animations
   - Better Error Handling

## License

MIT License
