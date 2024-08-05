import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 이메일과 비밀번호 입력 필드를 위한 컨트롤러
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // 폼의 상태를 관리하기 위한 GlobalKey
  final _formKey = GlobalKey<FormState>();

  // FirebaseAuth 인스턴스
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // LocalAuthentication 인스턴스
  final LocalAuthentication auth = LocalAuthentication();

  // 지문 인증을 수행하는 메서드
  Future<void> _authenticate() async {
    try {
      // 지문 인증 수행
      bool authenticated = await auth.authenticate(
        localizedReason: 'Authenticate to login', // 인증 이유
        options: const AuthenticationOptions(
          useErrorDialogs: true, // 에러 다이얼로그 사용 여부
          stickyAuth: true, // 인증 지속 여부
        ),
      );

      // 인증 성공 시
      if (authenticated) {
        final User? user = _auth.currentUser; // 현재 사용자 정보 가져오기
        if (user != null) {
          // 사용자가 존재하면 hello 화면으로 이동하며 이메일 전달
          Navigator.pushNamed(context, '/hello', arguments: user.email);
        } else {
          // 사용자가 존재하지 않으면 스낵바로 경고 메시지 표시
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No user found. Please log in first.')),
          );
        }
      }
    } catch (e) {
      // 인증 실패 시 에러 메시지 표시
      print('Failed to authenticate: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to authenticate: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'), // 앱바 제목
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // 전체 패딩 설정
        child: Form(
          key: _formKey, // 폼의 키 설정
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
            children: <Widget>[
              // 이메일 입력 필드
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email', // 레이블 텍스트
                  border: OutlineInputBorder(), // 외곽선 설정
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email'; // 유효성 검사 실패 메시지
                  }
                  return null; // 유효성 검사 성공
                },
              ),
              const SizedBox(height: 16.0), // 간격 조정
              // 비밀번호 입력 필드
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password', // 레이블 텍스트
                  border: OutlineInputBorder(), // 외곽선 설정
                ),
                obscureText: true, // 비밀번호 숨김 설정
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password'; // 유효성 검사 실패 메시지
                  }
                  return null; // 유효성 검사 성공
                },
              ),
              const SizedBox(height: 16.0), // 간격 조정
              // 로그인 버튼
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      // 이메일과 비밀번호로 로그인 시도
                      await _auth.signInWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text,
                      );
                      // 로그인 성공 시 hello 화면으로 이동하며 이메일 전달
                      Navigator.pushNamed(context, '/hello', arguments: emailController.text);
                    } catch (e) {
                      // 로그인 실패 시 에러 메시지 표시
                      print('Failed to sign in: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to sign in: ${e.toString()}')),
                      );
                    }
                  }
                },
                child: const Text('Login'), // 버튼 텍스트
              ),
              const SizedBox(height: 16.0), // 간격 조정
              // 지문 로그인 버튼
              ElevatedButton(
                onPressed: _authenticate, // 지문 인증 메서드 호출
                child: const Text('Login with Fingerprint'), // 버튼 텍스트
              ),
              const SizedBox(height: 16.0), // 간격 조정
              // 회원가입 화면으로 이동하는 버튼
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signin'); // 회원가입 화면으로 이동
                },
                child: const Text('Sign In'), // 버튼 텍스트
              ),
            ],
          ),
        ),
      ),
    );
  }
}
