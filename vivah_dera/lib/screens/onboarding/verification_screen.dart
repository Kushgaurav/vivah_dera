import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => VerificationScreenState();
}

class VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isResending = false;
  bool _isVerifying = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _resendOtp() {
    setState(() {
      _isResending = true;
    });

    // Simulate OTP resend
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _isResending = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('OTP resent successfully')));
    });
  }

  void _verifyOtp() async {
    setState(() {
      _isVerifying = true;
    });

    try {
      // Simulate OTP verification
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      setState(() {
        _isVerifying = false;
      });
      Navigator.pushReplacementNamed(context, '/profile_setup');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _isVerifying = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Verification failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OTP Verification')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter the OTP sent to your email',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'OTP',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isVerifying ? null : _verifyOtp,
                    child:
                        _isVerifying
                            ? const CircularProgressIndicator()
                            : const Text('Verify'),
                  ),
                ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: _isResending ? null : _resendOtp,
                  child:
                      _isResending
                          ? const CircularProgressIndicator()
                          : const Text('Resend OTP'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
