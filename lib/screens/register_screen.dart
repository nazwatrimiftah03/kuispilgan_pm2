import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/responsive.dart';
import '../widgets/app_text_field.dart';
import '../widgets/content_wrapper.dart';
import '../widgets/primary_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _name.dispose();
    _username.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final error = await context
        .read<AuthProvider>()
        .register(_name.text, _username.text, _password.text);
    if (!mounted) return;
    setState(() => _loading = false);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Akun')),
      body: ContentWrapper(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(Icons.person_add, size: r.wp(18), color: cs.primary),
              SizedBox(height: r.wp(5)),
              AppTextField(
                controller: _name,
                label: 'Nama lengkap',
                icon: Icons.badge,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
              ),
              AppTextField(
                controller: _username,
                label: 'Username',
                icon: Icons.person,
                validator: (v) {
                  final t = v?.trim() ?? '';
                  if (t.length < 4) return 'Minimal 4 karakter';
                  if (t.contains(' ')) return 'Tidak boleh ada spasi';
                  return null;
                },
              ),
              AppTextField(
                controller: _password,
                label: 'Password',
                icon: Icons.lock,
                isPassword: true,
                validator: (v) => (v == null || v.length < 6) ? 'Minimal 6 karakter' : null,
              ),
              AppTextField(
                controller: _confirm,
                label: 'Konfirmasi password',
                icon: Icons.lock_outline,
                isPassword: true,
                action: TextInputAction.done,
                validator: (v) => v != _password.text ? 'Password tidak sama' : null,
              ),
              _loading
                  ? const Center(child: CircularProgressIndicator())
                  : PrimaryButton(label: 'Daftar', icon: Icons.check, onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}