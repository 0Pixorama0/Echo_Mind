import 'package:flutter/material.dart';

import '../screens/crisis/crisis_help_screen.dart';
import '../theme/app_colors.dart';

/// Opens the crisis help screen. Per the SOW, crisis resources must be
/// reachable from every screen via a permanent help control.
void openCrisisHelp(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => const CrisisHelpScreen(),
      fullscreenDialog: true,
    ),
  );
}

/// Compact app-bar action used on every screen.
class CrisisHelpAction extends StatelessWidget {
  const CrisisHelpAction({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Tooltip(
        message: 'Get help now',
        child: Material(
          color: AppColors.crisis.withValues(alpha: 0.14),
          shape: const StadiumBorder(),
          child: InkWell(
            customBorder: const StadiumBorder(),
            onTap: () => openCrisisHelp(context),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite_border,
                      size: 16, color: AppColors.crisis),
                  SizedBox(width: 6),
                  Text(
                    'Help',
                    style: TextStyle(
                      color: AppColors.crisis,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
