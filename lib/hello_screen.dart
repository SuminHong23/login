import 'package:flutter/material.dart';

// HelloScreen 클래스는 사용자에게 인사말을 표시하는 화면입니다.
class HelloScreen extends StatelessWidget {
  const HelloScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 이전 화면에서 전달된 이메일 값을 가져옵니다.
    final String? email = ModalRoute.of(context)!.settings.arguments as String?;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello Screen'), // 앱바 제목 설정
      ),
      body: Center(
        // 사용자에게 인사말과 이메일을 표시하는 텍스트 위젯
        child: Text('Hello, $email!'),
      ),
    );
  }
}

