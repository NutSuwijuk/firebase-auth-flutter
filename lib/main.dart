import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_links/app_links.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await LineSDK.instance.setup("2007733529");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const AuthScreen(),
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;
  bool _isLoading = false;
  String _statusMessage = '';

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initDeepLinks() async {
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      if (uri.toString().startsWith('firebaseauth://')) {
        final code = uri.queryParameters['code'];
        if (code != null) {
          _processLineCallback(code);
        }
      }
    });
  }

  Future<void> _processLineCallback(String code) async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'กำลังประมวลผลการเข้าสู่ระบบ...';
    });

    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('processLineCallbackHttp');
      final response = await callable.call(<String, dynamic>{
        'code': code,
      });

      final customToken = response.data['token'];

      final UserCredential userCredential = await _auth.signInWithCustomToken(customToken);

      setState(() {
        _statusMessage = 'เข้าสู่ระบบสำเร็จ!';
      });

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('สำเร็จ'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ชื่อ: ${userCredential.user?.displayName ?? 'ไม่ระบุ'}'),
                Text('อีเมล: ${userCredential.user?.email ?? 'ไม่ระบุ'}'),
                Text('User ID: ${userCredential.user?.uid ?? 'ไม่พบ'}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('ตกลง'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'เกิดข้อผิดพลาด: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // ฟังก์ชันสำหรับ Google Sign-In
  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'กำลังเข้าสู่ระบบด้วย Google...';
    });

    try {
      // เริ่ม Google Sign-In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        setState(() {
          _statusMessage = 'ยกเลิกการเข้าสู่ระบบ';
        });
        return;
      }

      // ดึงข้อมูล authentication
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // สร้าง credential สำหรับ Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // เข้าสู่ระบบด้วย Firebase
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      setState(() {
        _statusMessage = 'เข้าสู่ระบบสำเร็จ!';
      });
      
      // แสดง dialog เมื่อ login สำเร็จ
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('สำเร็จ'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ชื่อ: ${userCredential.user?.displayName ?? 'ไม่ระบุ'}'),
                Text('อีเมล: ${userCredential.user?.email ?? 'ไม่ระบุ'}'),
                Text('User ID: ${userCredential.user?.uid ?? 'ไม่พบ'}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('ตกลง'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'เกิดข้อผิดพลาด: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // ฟังก์ชันสำหรับ Cancel Login
  void _cancelLogin() {
    setState(() {
      _statusMessage = 'ยกเลิกการเข้าสู่ระบบ';
    });
  }

  // ฟังก์ชันสำหรับ LINE Sign-In
  Future<void> _signInWithLine() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'กำลังเข้าสู่ระบบด้วย LINE...';
    });

    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('getLineAuthUrlHttp');
      final response = await callable.call();
      final authUrl = response.data['url'];

      if (await canLaunch(authUrl)) {
        await launch(authUrl);
      } else {
        throw 'Could not launch $authUrl';
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'เกิดข้อผิดพลาด: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6A4C93), // สีม่วง
              Color(0xFFFF6B35), // สีส้ม
            ],
            stops: [0.0, 0.7], // 70% ม่วง, 30% ส้ม
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ส่วนบน (สีม่วง) - 70% ของหน้าจอ
              Expanded(
                flex: 7,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ปุ่ม Google Sign-In
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(28),
                            onTap: _isLoading ? null : _signInWithGoogle,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Google Logo
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF4285F4), // Blue
                                          Color(0xFF34A853), // Green
                                          Color(0xFFFBBC05), // Yellow
                                          Color(0xFFEA4335), // Red
                                        ],
                                      ),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'G',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // ข้อความ
                                  Text(
                                    'เข้าสู่ระบบด้วย Google',
                                    style: TextStyle(
                                      color: Colors.grey[800],
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // ปุ่ม LINE Sign-In
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00B900),
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(28),
                            onTap: _isLoading ? null : _signInWithLine,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // LINE Logo
                                  Container(
                                    width: 24,
                                    height: 24,
                                    child: Image.network('https://upload.wikimedia.org/wikipedia/commons/4/41/LINE_logo.svg'),
                                  ),
                                  const SizedBox(width: 16),
                                  // ข้อความ
                                  const Text(
                                    'เข้าสู่ระบบด้วย LINE',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // ข้อความอธิบาย
                      Text(
                        'การเข้าสู่ระบบด้วย Google จะช่วยให้คุณ\nใช้งานแอปได้อย่างปลอดภัย',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                      
                      // แสดงสถานะการโหลด
                      if (_isLoading) ...[
                        const SizedBox(height: 24),
                        const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ],
                      
                      // แสดงข้อความสถานะ
                      if (_statusMessage.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _statusMessage,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              
              // ส่วนล่าง (สีส้ม) - 30% ของหน้าจอ
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32.0),
                  child: Center(
                    child: GestureDetector(
                      onTap: _cancelLogin,
                      child: Text(
                        'ยกเลิกการเข้าสู่ระบบ',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
