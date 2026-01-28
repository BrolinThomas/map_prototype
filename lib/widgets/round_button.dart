import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class RoundButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? title;
  final double height;
  final Widget? child;

  const RoundButton({
    super.key,
    this.title,
    this.onPressed,
    this.height = 45.0,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(9),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.primaryGradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(9),
          boxShadow:
              AppColors.isDarkMode
                  ? null
                  : [
                    BoxShadow(
                      color: AppColors.backgroundDark.withValues(alpha: 0.2),
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
        ),
        alignment: Alignment.center,
        child:
            child ??
            Text(
              title ?? "",
              style: TextStyle(
                color: AppColors.buttonText,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
      ),
    );
  }
}
