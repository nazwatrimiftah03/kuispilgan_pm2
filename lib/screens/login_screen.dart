import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/responsive.dart';
import '../widgets/app_text_field.dart';
import '../widgets/content_wrapper.dart';
import '../widgets/primary_button.dart';
import '../widgets/theme_toggle_button.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final error = await context.read<AuthProvider>().login(_username.text, _password.text);
    if (!mounted) return;
    setState(() => _loading = false);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(actions: const [ThemeToggleButton()]),
      body: ContentWrapper(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(r.wp(5)),
                child: Image.asset(
                  'assets/images/usu_banner.png',
                  fit: BoxFit.cover,
                  height: r.wp(32),
                ),
              ),
              SizedBox(height: r.wp(5)),
              Text(
                'Masuk',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: r.sp(7), fontWeight: FontWeight.w700, color: cs.primary),
              ),
              Text(
                'Kuis Ilmu Komputer',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: r.sp(3.5), color: cs.onSurfaceVariant),
              ),
              SizedBox(height: r.wp(6)),
              AppTextField(
                controller: _username,
                label: 'Username',
                icon: Icons.person,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Username wajib diisi' : null,
              ),
              AppTextField(
                controller: _password,
                label: 'Password',
                icon: Icons.lock,
                isPassword: true,
                action: TextInputAction.done,
                validator: (v) => (v == null || v.isEmpty) ? 'Password wajib diisi' : null,
              ),
              _loading
                  ? const Center(child: CircularProgressIndicator())
                  : PrimaryButton(label: 'Masuk', icon: Icons.login, onPressed: _submit),
              SizedBox(height: r.wp(3)),
              PrimaryButton(
                label: 'Daftar',
                outlined: true,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}