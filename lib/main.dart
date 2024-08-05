import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login_screen.dart';
import 'signin_screen.dart';
import 'hello_screen.dart';

// main 함수는 앱의 시작 지점입니다.
void main() async {
  // Flutter 엔진과의 상호 작용을 보장하기 위해 초기화합니다.
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 초기화. Firebase 사용 전에 반드시 호출해야 합니다.
  await Firebase.initializeApp();

  // Flutter 애플리케이션을 실행합니다.
  runApp(const MyApp());
}

// MyApp 클래스는 애플리케이션의 루트 위젯입니다.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 애플리케이션 제목
      title: 'Flutter Demo',

      // 애플리케이션 시작 경로
      initialRoute: '/',

      // 경로별로 연결될 화면 위젯을 지정합니다.
      routes: {
        // 기본 경로 (/)는 LoginScreen 위젯으로 연결됩니다.
        '/': (context) => const LoginScreen(),

        // /signin 경로는 SigninScreen 위젯으로 연결됩니다.
        '/signin': (context) => const SigninScreen(),

        // /hello 경로는 HelloScreen 위젯으로 연결됩니다.
        '/hello': (context) => const HelloScreen(),
      },
    );
  }
}
