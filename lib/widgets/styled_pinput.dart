// import 'package:flutter/material.dart';
// import 'package:pinput/pinput.dart';
// import '../../constants/app_colors.dart';

// class StyledPinput extends StatelessWidget {
//   final int length;
//   final TextEditingController controller;
//   final Function(String)? onCompleted;
//   final Function(String)? onChanged;
//   final bool obscureText;
//   final bool enabled;

//   const StyledPinput({
//     super.key,
//     this.length = 4,
//     required this.controller,
//     this.onCompleted,
//     this.onChanged,
//     this.obscureText = true,
//     this.enabled = true,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final defaultPinTheme = PinTheme(
//       width: 60,
//       height: 60,
//       textStyle: TextStyle(
//         fontSize: 24,
//         fontWeight: FontWeight.bold,
//         color: enabled ? AppColors.textPrimary : AppColors.textSecondary,
//       ),
//       decoration: BoxDecoration(
//         color: enabled
//             ? AppColors.dimBackground
//             : AppColors.dimBackground.withValues(alpha: 0.5),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: AppColors.textSecondary.withValues(alpha: 0.2),
//           width: 1,
//         ),
//       ),
//     );

//     final focusedPinTheme = defaultPinTheme.copyWith(
//       decoration: defaultPinTheme.decoration?.copyWith(
//         border: Border.all(color: AppColors.primary, width: 2),
//       ),
//     );

//     final submittedPinTheme = defaultPinTheme.copyWith(
//       decoration: defaultPinTheme.decoration?.copyWith(
//         border: Border.all(
//           color: AppColors.primary.withValues(alpha: 0.5),
//           width: 1,
//         ),
//       ),
//     );

//     return Pinput(
//       length: length,
//       controller: controller,
//       defaultPinTheme: defaultPinTheme,
//       focusedPinTheme: focusedPinTheme,
//       submittedPinTheme: submittedPinTheme,
//       obscureText: obscureText,
//       onCompleted: onCompleted,
//       onChanged: onChanged,
//       enabled: enabled,
//       keyboardType: TextInputType.number,
//       hapticFeedbackType: HapticFeedbackType.lightImpact,
//       cursor: Container(width: 2, height: 24, color: AppColors.primary),
//     );
//   }
// }
