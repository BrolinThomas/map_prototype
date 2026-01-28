import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class CustomDropdown extends StatelessWidget {
  final String? value;
  final String hint;
  final IconData? prefixIcon;
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String?> onChanged;
  final bool showBorder;
  final Color? borderColor;
  final double borderWidth;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.prefixIcon,
    this.showBorder = true,
    this.borderColor,
    this.borderWidth = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: showBorder
            ? Border.all(
                color:
                    borderColor ??
                    AppColors.textSecondary.withValues(alpha: 0.2),
                width: borderWidth,
              )
            : null,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          hint: Row(
            children: [
              if (prefixIcon != null) ...[
                Icon(prefixIcon, color: AppColors.textSecondary, size: 24),
                const SizedBox(width: 12),
              ],
              Text(
                hint,
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              ),
            ],
          ),
          icon: Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
          dropdownColor: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
