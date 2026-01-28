// import 'package:broadcaster/constants/app_colors.dart';
// import 'package:flutter/material.dart';


// class RoundTextField extends StatelessWidget {
//   final int? maxLength;
//   final String title;
//   final String hintText;
//   final TextEditingController controller;
//   final bool obscureText;
//   final TextInputType? keyboardType;
//   final String? Function(String?)? validator;
//   final Widget? prefixIcon;
//   final Widget? suffixIcon;
//   final Function(String)? onChanged;

//   const RoundTextField({
//     super.key,
//     required this.title,
//     required this.hintText,
//     this.maxLength,
//     required this.controller,
//     this.obscureText = false,
//     this.keyboardType,
//     this.validator,
//     this.prefixIcon,
//     this.suffixIcon,
//     this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: TextStyle(
//             color: AppColors.textPrimary,
//             fontSize: 15,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Container(
//           decoration: BoxDecoration(
//             color: AppColors.dimBackground,
//             borderRadius: BorderRadius.circular(15),
//             border: Border.all(
//               color: AppColors.textSecondary.withValues(alpha: 0.1),
//               width: 1,
//             ),
//           ),
//           child: TextFormField(
//             controller: controller,
//             obscureText: obscureText,
//             keyboardType: keyboardType,
//             maxLength: maxLength,
//             validator: validator,
//             onChanged: onChanged,
//             style: TextStyle(color: AppColors.textPrimary, fontSize: 16),
//             decoration: InputDecoration(
//               counterText: "",
//               hintText: hintText,
//               hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 16),
//               prefixIcon: prefixIcon,
//               suffixIcon: suffixIcon,
//               border: InputBorder.none,
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 14,
//                 vertical: 14,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
