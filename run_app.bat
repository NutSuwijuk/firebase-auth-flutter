@echo off
echo ========================================
echo Firebase Auth Flutter App Runner
echo ========================================

echo.
echo กำลังตรวจสอบ Flutter...
where flutter >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] ไม่พบ Flutter ใน PATH
    echo กรุณาติดตั้ง Flutter SDK และเพิ่มใน PATH
    echo ดูคำแนะนำได้ที่: https://docs.flutter.dev/get-started/install/windows
    pause
    exit /b 1
)

echo [SUCCESS] พบ Flutter แล้ว
echo.

echo กำลังติดตั้ง dependencies...
flutter pub get
if %errorlevel% neq 0 (
    echo [ERROR] ไม่สามารถติดตั้ง dependencies ได้
    pause
    exit /b 1
)

echo.
echo กำลังรันแอป...
echo.
echo คำแนะนำ:
echo - กด 'r' เพื่อ hot reload
echo - กด 'R' เพื่อ hot restart  
echo - กด 'q' เพื่อออกจากแอป
echo.

flutter run

pause 