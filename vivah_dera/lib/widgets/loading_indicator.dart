import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final String? message;

  const LoadingIndicator({
    super.key,
    required this.child,
    required this.isLoading,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.white.withAlpha(229), // equivalent to opacity 0.9
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  if (message != null) ...[
                    const SizedBox(height: 16),
                    Text(message!),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}
