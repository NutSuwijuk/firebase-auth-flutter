Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Firebase Auth Flutter App Runner" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# ตรวจสอบ Flutter
Write-Host "กำลังตรวจสอบ Flutter..." -ForegroundColor Yellow
try {
    $flutterPath = Get-Command flutter -ErrorAction Stop
    Write-Host "[SUCCESS] พบ Flutter แล้ว: $($flutterPath.Source)" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] ไม่พบ Flutter ใน PATH" -ForegroundColor Red
    Write-Host "กรุณาติดตั้ง Flutter SDK และเพิ่มใน PATH" -ForegroundColor Yellow
    Write-Host "ดูคำแนะนำได้ที่: https://docs.flutter.dev/get-started/install/windows" -ForegroundColor Blue
    Read-Host "กด Enter เพื่อออก"
    exit 1
}

Write-Host ""

# ติดตั้ง dependencies
Write-Host "กำลังติดตั้ง dependencies..." -ForegroundColor Yellow
try {
    flutter pub get
    Write-Host "[SUCCESS] ติดตั้ง dependencies สำเร็จ" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] ไม่สามารถติดตั้ง dependencies ได้" -ForegroundColor Red
    Read-Host "กด Enter เพื่อออก"
    exit 1
}

Write-Host ""
Write-Host "กำลังรันแอป..." -ForegroundColor Yellow
Write-Host ""
Write-Host "คำแนะนำ:" -ForegroundColor Cyan
Write-Host "- กด 'r' เพื่อ hot reload" -ForegroundColor White
Write-Host "- กด 'R' เพื่อ hot restart" -ForegroundColor White
Write-Host "- กด 'q' เพื่อออกจากแอป" -ForegroundColor White
Write-Host ""

# รันแอป
flutter run

Read-Host "กด Enter เพื่อออก" 