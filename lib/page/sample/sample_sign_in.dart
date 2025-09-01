import 'package:flutter/material.dart';

class SampleSignIn extends StatelessWidget {
  const SampleSignIn();

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Center(
      child: isSmallScreen
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _logo(isSmallScreen),
                const _FormContent(),
              ],
            )
          : Container(
              padding: const EdgeInsets.all(32),
              constraints: const BoxConstraints(maxWidth: 800),
              child: Row(
                children: [
                  Expanded(child: _logo(isSmallScreen)),
                  const Expanded(child: Center(child: _FormContent())),
                ],
              ),
            ),
    );
  }

  Widget _logo(bool isSmallScreen) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FlutterLogo(size: isSmallScreen ? 100 : 200),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            "Welcome to Flutter!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isSmallScreen ? 16 : 20,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class _FormContent extends StatefulWidget {
  const _FormContent();

  @override
  State<_FormContent> createState() => _FormContentState();
}

class _FormContentState extends State<_FormContent> {
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  final _formKey = GlobalKey<FormState>();

  Widget _form() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            validator: (value) => value == null || value.isEmpty
                ? 'Please enter an email'
                : !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                        .hasMatch(value)
                    ? 'Please enter a valid email'
                    : null,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'Enter your email',
              prefixIcon: Icon(Icons.email_outlined),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            obscureText: !_isPasswordVisible,
            validator: (value) => value == null || value.isEmpty
                ? 'Please enter a password'
                : value.length < 6
                    ? 'Password must be at least 6 characters'
                    : null,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              prefixIcon: const Icon(Icons.lock_outline_rounded),
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(_isPasswordVisible
                    ? Icons.visibility_off
                    : Icons.visibility),
                onPressed: () =>
                    setState(() => _isPasswordVisible = !_isPasswordVisible),
              ),
            ),
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            value: _rememberMe,
            onChanged: (value) => setState(() => _rememberMe = value ?? false),
            title: const Text('Remember me'),
            controlAffinity: ListTileControlAffinity.leading,
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Do something
                }
              },
              child: const Text('Sign in',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: _form(),
    );
  }
}
