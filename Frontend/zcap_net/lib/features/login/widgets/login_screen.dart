import 'package:flutter/material.dart';
import 'package:zcap_net_app/widgets/hero_widget.dart';
import '../../../shared/shared.dart';
import '../view_model/login_view_model.dart';
import '../../home/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _loginViewModel = LoginViewModel();
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  void _login() async {
    final success = await _loginViewModel.login(
      _usernameController.text,
      _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      CustomOkSnackBar.show(
        context,
        'Credenciais válidas!!',
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      CustomNOkSnackBar.show(context, 'Credenciais inválidas');
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _usernameFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  HeroWidget(title: 'ZCAP Net'),
                  SizedBox(
                    height: 20.0,
                  ),
                  CustomTextField(
                    controller: _usernameController,
                    fieldName: 'Username',
                    prefixIcon: Icons.person_outlined,
                    inputType: TextInputType.text,
                    focusNode: _usernameFocusNode,
                    onSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_passwordFocusNode);
                    },
                  ),
                  CustomTextField(
                    controller: _passwordController,
                    fieldName: 'Password',
                    prefixIcon: Icons.password_outlined,
                    inputType: TextInputType.text,
                    obscureText: true,
                    focusNode: _passwordFocusNode,
                    onSubmitted: (_) => _login(),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: _login,
                      child: const Text("Entrar"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
