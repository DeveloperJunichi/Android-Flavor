import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
// Firebase CLIを使うので、main関数はこのように設定する↓
// Flutter Webだけで使用
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MaterialApp(
      initialRoute: '/userLogin',
      routes: {
        '/userLogin': (context) => const UserLogin(),
        '/content': (context) => const MainContent(),
      },
    ),
  );
}

class UserLogin extends StatefulWidget {
  const UserLogin({Key? key}) : super(key: key);

  @override
  _UserLogin createState() => _UserLogin();
}

class _UserLogin extends State<UserLogin> {
  final _auth = FirebaseAuth.instance;

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ログイン'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (value) {
                email = value;
              },
              decoration: const InputDecoration(
                hintText: 'メールアドレスを入力',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (value) {
                password = value;
              },
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'パスワードを入力',
              ),
            ),
          ),
          ElevatedButton(
            child: const Text('ログイン'),
            onPressed: () async {
              try {
                final newUser = await _auth.signInWithEmailAndPassword(
                    email: email, password: password);
                if (newUser != null) {
                  Navigator.pushNamed(context, '/content');
                }
              } on FirebaseAuthException catch (e) {
                if (e.code == 'invalid-email') {
                  print('メールアドレスのフォーマットが正しくありません');
                } else if (e.code == 'user-disabled') {
                  print('現在指定したメールアドレスは使用できません');
                } else if (e.code == 'user-not-found') {
                  print('指定したメールアドレスは登録されていません');
                } else if (e.code == 'wrong-password') {
                  print('パスワードが間違っています');
                }
              }
            },
          )
        ],
      ),
    );
  }
}

class MainContent extends StatefulWidget {
  const MainContent({Key? key}) : super(key: key);

  @override
  _MainContentState createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {
  //ステップ１
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('成功'),
        actions: [
          IconButton(
            //ステップ２
            onPressed: () async {
              await _auth.signOut();
              if (_auth.currentUser == null) {
                print('ログアウトしました！');
              }
              Navigator.pop(context);
            },
            icon: Icon(Icons.close),
          ),
        ],
      ),
      body: Center(
        child: Text('ログイン成功！'),
      ),
    );
  }
}