import 'dart:io';
import 'package:chat2/components/user_image_picker.dart';
import 'package:chat2/core/models/auth_form_data.dart';
import 'package:chat2/core/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final Function(AuthFormData) onSubmit;
  const AuthForm({super.key, required this.onSubmit});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final AuthFormData _formData = AuthFormData();
  final _formKey = GlobalKey<FormState>();

  void _submit() {
    bool isValidForm = _formKey.currentState!.validate();

    if (!isValidForm) return;
    
    widget.onSubmit(_formData);
    if (_formData.isLogin) {
      AuthService().login(_formData.email, _formData.password);
    } else {
      AuthService().signup(
        _formData.name,
        _formData.email, 
        _formData.password, 
        _formData.image,
      );
    }

  }

  void showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _handleImagePick(File image) {
    _formData.image = image;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4)
      ),
      child: SizedBox(
        height: _formData.isLogin ? 347 : 426,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                if(_formData.isSignup)
                UserImagePicker(onImagePick: _handleImagePick,),
                if(_formData.isSignup)
                TextFormField(
                  key: const ValueKey('name'),
                  initialValue: _formData.name,
                  decoration: const InputDecoration(
                    labelText: 'Nome'
                  ),
                  onChanged: (name) => _formData.name = name,
                  validator: (_name) {
                    final name = _name ?? '';
                    if (name.trim().length < 5) {
                      return 'Nome deve ter no minimo 5 caracteres';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  key: const ValueKey('email'),
                  decoration: const InputDecoration(
                    labelText: 'Email'
                  ),
                  onChanged: (email) => _formData.email = email,
                  validator: (_email) {
                    final email = _email ?? '';
                    if (!email.contains('@')) {
                      return 'Email inválido';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  key: const ValueKey('password'),
                  decoration: const InputDecoration(
                    labelText: 'Senha'
                  ),
                  onChanged: (password) => _formData.password = password,
                  obscureText: true,
                  validator: (_password) {
                    final password = _password ?? '';
                    if (password.length < 6) {
                      return 'Senha deve ter no minimo 6 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: _submit, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                    )
                  ),
                  child: Text(
                    _formData.isLogin ? 'Entrar' : 'Cadastrar', 
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20,),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _formData.toggleAuthMode();
                    });
                  }, 
                  child: Text(
                    _formData.isLogin ? 'Criar uma conta' : 'Já possui uma conta?',
                  ),
                )
              ],
            )
          ),
        ),
      ),
    );
  }
}