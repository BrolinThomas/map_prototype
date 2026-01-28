import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class AuthLayout extends StatelessWidget {
  final Widget child;

  const AuthLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Top section with primary color and logo
        Container(
          width: double.infinity,
          height: double.infinity,

          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            image: DecorationImage(fit: BoxFit.cover,
              image: AssetImage("assets/images/poster.png",),
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 50),
                // Image.asset(
                //   'assets/images/app_logo2.png',
                //   height: 200,
                //   width: 200,
                // ),
              ],
            ),
          ),
        ),
        // Bottom sheet style welcome section
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height * 0.30,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.4),
                  Colors.black.withValues(alpha: 0.7),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: child,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
