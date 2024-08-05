import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  // 이메일과 비밀번호 입력 필드를 위한 컨트롤러
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // 폼의 상태를 관리하기 위한 GlobalKey
  final _formKey = GlobalKey<FormState>();

  // FirebaseAuth 인스턴스
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // LocalAuthentication 인스턴스
  final LocalAuthentication auth = LocalAuthentication();

  // 이메일 사용 가능 여부, 이메일 및 비밀번호 유효성 상태
  bool _isEmailAvailable = false;
  bool _isEmailValid = false;
  bool _isPasswordValid = false;

  // 이메일과 비밀번호의 유효성을 검사하는 메서드
  void _checkEmailAndPassword() {
    setState(() {
      // 이메일 유효성 검사
      _isEmailValid = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(emailController.text);
      // 비밀번호 유효성 검사 (7자 이상, 알파벳과 숫자로만 구성)
      _isPasswordValid = passwordController.text.length >= 7 && RegExp(r'^[a-zA-Z0-9]+$').hasMatch(passwordController.text);
    });
  }

  // 이메일 사용 가능 여부를 확인하는 메서드
  Future<void> _checkEmailAvailability() async {
    try {
      // FirebaseAuth를 통해 이메일로 가입된 계정 확인
      final list = await _auth.fetchSignInMethodsForEmail(emailController.text);
      setState(() {
        // 이메일 사용 가능 여부를 업데이트
        _isEmailAvailable = list.isEmpty;
      });
      if (_isEmailAvailable) {
        // 이메일이 사용 가능하면 계정 생성 및 지문 등록 여부 묻기
        await _createAccount();
        _showFingerprintDialog();
      } else {
        // 이메일이 이미 사용 중이면 경고 다이얼로그 표시
        _showEmailInUseDialog();
      }
    } catch (e) {
      // 에러가 발생하면 에러 메시지를 표시
      print('Failed to check email: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to check email: ${e.toString()}')),
      );
    }
  }

  // 이메일이 이미 사용 중이라는 다이얼로그를 표시하는 메서드
  void _showEmailInUseDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Email In Use'),
        content: const Text('The email address is already in use.'),
        actions: [
          TextButton(
            onPressed: () {
              // 다이얼로그 닫기
              emailController.clear();
              passwordController.clear();
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // 계정을 생성하는 메서드
  Future<void> _createAccount() async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully')),
      );
    } catch (e) {
      print('Failed to create account: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create account: ${e.toString()}')),
      );
    }
  }

  // 지문 등록 여부를 묻는 다이얼로그를 표시하는 메서드
  void _showFingerprintDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Register Fingerprint'),
        content: const Text('Do you want to register your fingerprint for login?'),
        actions: [
          TextButton(
            onPressed: () {
              // 지문 등록을 하지 않고 로그인 화면으로 이동
              Navigator.of(context).pop();
              Navigator.pushNamed(context, '/');
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              // 지문 등록을 수행
              Navigator.of(context).pop();
              await _registerFingerprint();
              Navigator.pushNamed(context, '/');
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  // 지문을 등록하는 메서드
  Future<void> _registerFingerprint() async {
    try {
      // 지문 인증을 수행
      bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to register fingerprint',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );

      if (didAuthenticate) {
        // 지문 등록이 성공하면 메시지를 표시하고 로그인 화면으로 이동
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fingerprint registered')),
        );
        Navigator.pushNamed(context, '/');
      }
    } catch (e) {
      // 에러가 발생하면 에러 메시지를 표시
      print('Failed to register fingerprint: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to register fingerprint: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signin Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  // 이메일 입력이 변경될 때 유효성 검사 수행
                  _checkEmailAndPassword();
                },
                validator: (value) {
                  // 이메일 유효성 검사
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              if (!_isEmailValid)
                const Text(
                  '형식에 맞는 이메일을 입력하세요',
                  style: TextStyle(color: Colors.red),
                ),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                onChanged: (value) {
                  // 비밀번호 입력이 변경될 때 유효성 검사 수행
                  _checkEmailAndPassword();
                },
                validator: (value) {
                  // 비밀번호 유효성 검사
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  } else if (value.length < 7) {
                    return 'Password must be at least 7 characters';
                  } else if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
                    return 'Password must contain only letters and numbers';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              if (!_isPasswordValid)
                const Text(
                  '비밀번호는 영어와 숫자로 이루어진 7글자여야 합니다',
                  style: TextStyle(color: Colors.red),
                ),
              if (_isEmailValid && _isPasswordValid)
                ElevatedButton(
                  onPressed: _checkEmailAvailability,
                  child: const Text('Check Email Availability'),
                ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
