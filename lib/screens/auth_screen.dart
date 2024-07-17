import 'package:flutter/material.dart';
import 'package:kargo_app/services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSignIn = true;

  void _toggleAuthMode() {
    setState(() {
      _isSignIn = !_isSignIn;
    });
  }

  Future<void> _submit() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (_isSignIn) {
      final response = await _authService.signIn(username, password);
      if (response != null) {
        Navigator.of(context).pushReplacementNamed('/main');
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Giriş başarısız')));
      }
    } else {
      final response = await _authService.signUp(username, password);
      if (response != null) {
        _toggleAuthMode();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Kayıt başarısız')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isSignIn ? 'Giriş Yap' : 'Kayıt Ol'),
        actions: [
          TextButton(
            onPressed: _toggleAuthMode,
            child: Text(_isSignIn ? 'Kayıt Ol' : 'Giriş Yap'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Kullanıcı Adı'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Şifre'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: Text(_isSignIn ? 'Giriş Yap' : 'Kayıt Ol'),
            ),
          ],
        ),
      ),
    );
  }
}
