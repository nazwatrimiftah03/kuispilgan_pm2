import 'package:flutter/material.dart';
import '../utils/responsive.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isPassword;
  final TextInputAction action;
  final String? Function(String?)? validator;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.isPassword = false,
    this.action = TextInputAction.next,
    this.validator,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _hidden = true;

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    return Padding(
      padding: EdgeInsets.only(bottom: r.wp(4)),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.isPassword && _hidden,
        textInputAction: widget.action,
        validator: widget.validator,
        style: TextStyle(fontSize: r.sp(3.8)),
        decoration: InputDecoration(
          labelText: widget.label,
          prefixIcon: Icon(widget.icon),
          suffixIcon: widget.isPassword
              ? IconButton(
            icon: Icon(_hidden ? Icons.visibility : Icons.visibility_off),
            onPressed: () => setState(() => _hidden = !_hidden),
          )
              : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(r.wp(4))),
        ),
      ),
    );
  }
}