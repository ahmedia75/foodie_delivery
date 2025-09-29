import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../controller/login_controller.dart';
import '../constants/app_colors.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Future<void> _handleLogin() async {
  //   if (_formKey.currentState?.validate() ?? false) {
  //     // Get device token for push notifications
  //     String? deviceToken = await FirebaseMessaging.instance.getToken();
  //     String? devicePlatform = Platform.isIOS ? 'IOS' : 'ANDROID';
  //     final success = await context.read<LoginController>().login(
  //         _phoneController.text,
  //         _passwordController.text,
  //         deviceToken ?? "",
  //         devicePlatform ?? "",);

  //     if (success && mounted) {
  //       Navigator.of(context).pushReplacement(
  //         MaterialPageRoute(builder: (_) => const HomeScreen()),
  //       );
  //     } else {
  //       _animationController.forward(from: 0.0);
  //     }
  //   }
  // }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      String? deviceToken = await FirebaseMessaging.instance.getToken();
      String devicePlatform = Platform.isIOS ? 'IOS' : 'ANDROID';
      final success = await context.read<LoginController>().login(
            _phoneController.text,
            _passwordController.text,
            deviceToken ?? "",
            devicePlatform,
          );
      if (success && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        _animationController.forward(from: 0.0);
      }
    }
  }

  Widget _buildErrorWidget(String error) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.red.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: AppColors.red),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                error,
                style: const TextStyle(
                  color: AppColors.red,
                  fontSize: 14,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: AppColors.red, size: 20),
              onPressed: () {
                context.read<LoginController>().clearError();
                _animationController.reverse();
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.midtoneColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondaryColor.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // const Icon(
                    //   Icons.delivery_dining,
                    //   size: 80,
                    //   color: AppColors.secondaryColor,
                    // ),
                    SvgPicture.asset(
                      'assets/logo/Ahmedia_Delivery_Logo.svg',
                      height: 32,
                      errorBuilder: (_, __, ___) => const Icon(
                          Icons.delivery_dining,
                          color: AppColors.secondaryColor),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Agents',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    Consumer<LoginController>(
                      builder: (context, controller, child) {
                        if (controller.isLoading) {
                          return const Center(
                              child: CircularProgressIndicator(
                            color: AppColors.secondaryColor,
                          ));
                        }
                        return ElevatedButton(
                          onPressed: _handleLogin,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: AppColors.secondaryColor,
                            foregroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),
                    Consumer<LoginController>(
                      builder: (context, controller, child) {
                        if (controller.error != null) {
                          return _buildErrorWidget(controller.error!);
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
