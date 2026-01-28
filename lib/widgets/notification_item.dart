// import 'package:flutter/material.dart';
// import '../../constants/app_colors.dart';
// import '../../presentation/Additional/full_screen_image_viewer.dart';

// class NotificationItem extends StatefulWidget {
//   final IconData icon;
//   final Color iconColor;
//   final String title;
//   final String subtitle;
//   final String time;
//   final String sender;
//   final bool isRead;
//   final String? imageUrl;
//   final VoidCallback? onTap;

//   const NotificationItem({
//     super.key,
//     required this.icon,
//     required this.iconColor,
//     required this.title,
//     required this.subtitle,
//     required this.time,
//     required this.sender,
//     this.isRead = false,
//     this.imageUrl,
//     this.onTap,
//   });

//   @override
//   State<NotificationItem> createState() => _NotificationItemState();
// }

// class _NotificationItemState extends State<NotificationItem> {
//   bool _isExpanded = false;

//   void _showFullImage(BuildContext context) {
//     if (widget.imageUrl == null || widget.imageUrl!.isEmpty) return;

//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => FullScreenImageViewer(
//           imageUrl: widget.imageUrl!,
//           title: widget.title,
//           message: widget.subtitle,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bool hasTitleLongText = widget.title.length > 80;
//     final bool hasMessageLongText = widget.subtitle.length > 150;
//     final bool hasLongText = hasTitleLongText || hasMessageLongText;

//     final int titleMaxLines = _isExpanded ? 10 : 2;
//     final int messageMaxLines = _isExpanded ? 100 : 3;

//     return InkWell(
//       onTap: () {
//         if (hasLongText) {
//           setState(() {
//             _isExpanded = !_isExpanded;
//           });
//         }
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: AppColors.card,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: AppColors.textSecondary.withValues(alpha: 0.1),
//           ),
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: widget.iconColor.withValues(alpha: 0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(widget.icon, color: widget.iconColor, size: 24),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     widget.title,
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.textPrimary,
//                     ),
//                     maxLines: titleMaxLines,
//                     overflow: _isExpanded
//                         ? TextOverflow.visible
//                         : TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     widget.subtitle,
//                     style: TextStyle(
//                       fontSize: 13,
//                       color: AppColors.textSecondary,
//                       height: 1.4,
//                     ),
//                     maxLines: messageMaxLines,
//                     overflow: _isExpanded
//                         ? TextOverflow.visible
//                         : TextOverflow.ellipsis,
//                   ),
//                   if (hasLongText) ...[
//                     const SizedBox(height: 4),
//                     Text(
//                       _isExpanded ? 'Show less' : 'Read more',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: AppColors.primary,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                   if (widget.imageUrl != null &&
//                       widget.imageUrl!.isNotEmpty) ...[
//                     const SizedBox(height: 8),
//                     GestureDetector(
//                       onTap: () => _showFullImage(context),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(8),
//                         child: Stack(
//                           children: [
//                             Image.network(
//                               widget.imageUrl!,
//                               height: 120,
//                               width: double.infinity,
//                               fit: BoxFit.cover,
//                               errorBuilder: (context, error, stackTrace) {
//                                 return Container(
//                                   height: 120,
//                                   color: AppColors.textSecondary.withValues(
//                                     alpha: 0.1,
//                                   ),
//                                   child: Center(
//                                     child: Icon(
//                                       Icons.broken_image,
//                                       color: AppColors.textSecondary,
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                             Positioned(
//                               bottom: 8,
//                               right: 8,
//                               child: Container(
//                                 padding: const EdgeInsets.all(6),
//                                 decoration: BoxDecoration(
//                                   color: Colors.black.withValues(alpha: 0.6),
//                                   borderRadius: BorderRadius.circular(6),
//                                 ),
//                                 child: Icon(
//                                   Icons.zoom_in,
//                                   color: Colors.white,
//                                   size: 20,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.access_time,
//                         size: 14,
//                         color: AppColors.textSecondary,
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         widget.time,
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: AppColors.textSecondary,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Icon(
//                         Icons.person_outline,
//                         size: 14,
//                         color: AppColors.textSecondary,
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         widget.sender,
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: AppColors.textSecondary,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             if (!widget.isRead)
//               Container(
//                 width: 8,
//                 height: 8,
//                 margin: const EdgeInsets.only(left: 8),
//                 decoration: BoxDecoration(
//                   color: AppColors.primary,
//                   shape: BoxShape.circle,
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
