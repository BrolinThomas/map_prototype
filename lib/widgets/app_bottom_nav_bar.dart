// import 'package:flutter/material.dart';
// import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
// import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
// import '../../constants/app_colors.dart';

// class AppBottomNavBar extends StatelessWidget {
//   final int currentIndex;
//   final Function(int) onTap;
//   final GlobalKey<CurvedNavigationBarState>? navigationKey;

//   const AppBottomNavBar({
//     super.key,
//     required this.currentIndex,
//     required this.onTap,
//     this.navigationKey,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return CurvedNavigationBar(
//       key: navigationKey,
//       index: currentIndex,
//       height: 65,
//       backgroundColor: Colors.transparent,
//       color: AppColors.primary,
//       buttonBackgroundColor: AppColors.primary,
//       animationDuration: const Duration(milliseconds: 300),
//       animationCurve: Curves.easeInOut,
//       items: [
//         CurvedNavigationBarItem(
//           child: Icon(Icons.home_outlined, color: Colors.white, size: 28),
//           label: 'Home',
//           labelStyle: TextStyle(
//             color: Colors.white,
//             fontSize: 12,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         CurvedNavigationBarItem(
//           child: Icon(Icons.campaign_outlined, color: Colors.white, size: 28),
//           label: 'Broadcast',
//           labelStyle: TextStyle(
//             color: Colors.white,
//             fontSize: 12,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         CurvedNavigationBarItem(
//           child: Icon(Icons.people_outline, color: Colors.white, size: 28),
//           label: 'Contacts',
//           labelStyle: TextStyle(
//             color: Colors.white,
//             fontSize: 12,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
        
//         CurvedNavigationBarItem(
//           child: Icon(Icons.settings_outlined, color: Colors.white, size: 28),
//           label: 'Profile',
//           labelStyle: TextStyle(
//             color: Colors.white,
//             fontSize: 12,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//       onTap: onTap,
//     );
//   }
// }
