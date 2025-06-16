import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:zcap_net_app/features/login/view_model/language_model.dart';
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

  List<Language> _supportedLanguages = [];
  Language? _selectedLanguage;

  void _login() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final success = await _loginViewModel.login(
      _usernameController.text,
      _passwordController.text,
    );

    if (!mounted) return;
    Navigator.of(context).pop();

    if (success) {
      CustomOkSnackBar.show(
        context,
        'login_ok'.tr(),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      CustomNOkSnackBar.show(context, 'login_nok'.tr());
    }
  }

  @override
  void initState() {
    super.initState();
    _loadLanguages();
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

  void _loadLanguages() async {
    final langs = await Language.loadFromAsset();

    setState(() {
      _supportedLanguages = langs;
      _selectedLanguage = langs.firstWhere(
        (lang) => lang.code == context.locale.languageCode,
        orElse: () => langs.first,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("login".tr())),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  HeroWidget(title: 'app_name'.tr()),
                  SizedBox(
                    height: 20.0,
                  ),
                  CustomTextField(
                    controller: _usernameController,
                    fieldName: 'username'.tr(),
                    prefixIcon: Icons.person_outlined,
                    inputType: TextInputType.text,
                    focusNode: _usernameFocusNode,
                    onSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_passwordFocusNode);
                    },
                  ),
                  CustomTextField(
                    controller: _passwordController,
                    fieldName: 'password'.tr(),
                    prefixIcon: Icons.password_outlined,
                    inputType: TextInputType.text,
                    obscureText: true,
                    focusNode: _passwordFocusNode,
                    onSubmitted: (_) => _login(),
                  ),
                  const SizedBox(height: 20),

DropdownButton<Language>(
  value: _selectedLanguage,
  icon: const Icon(Icons.language),
  isExpanded: true,
  underline: Container(height: 1, color: Colors.grey),
  items: _supportedLanguages.map((lang) {
    return DropdownMenuItem<Language>(
      value: lang,
      child: Row(
        children: [
          Image.asset(lang.flag, width: 24, height: 24),
          const SizedBox(width: 8),
          Text(lang.name),
        ],
      ),
    );
  }).toList(),
  onChanged: (Language? newLang) {
    if (newLang != null) {
      setState(() {
        _selectedLanguage = newLang;
      });
      context.setLocale(Locale(newLang.code));
    }
  },
),


                  const SizedBox(height: 20),
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: _login,
                      child: Text('login'.tr()),
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
