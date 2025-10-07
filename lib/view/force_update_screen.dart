import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../constants/app_colors.dart';
import '../services/force_update_service.dart';

class ForceUpdateScreen extends StatelessWidget {
  final ForceUpdateResult updateResult;
  final VoidCallback? onUpdatePressed;

  const ForceUpdateScreen({
    super.key,
    required this.updateResult,
    this.onUpdatePressed,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.midtoneColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top spacing
                SizedBox(height: size.height * 0.1),
                // Lottie Animation
                // Lottie.asset(
                //   "assets/json/Attendance_Login.json",
                //   height: 200,
                //   fit: BoxFit.contain,
                // ),
                SvgPicture.asset(
                  'assets/logo/Ahmedia_Delivery_Logo.svg',
                  height: 80,
                  errorBuilder: (_, __, ___) => const Icon(
                      Icons.delivery_dining,
                      color: AppColors.secondaryColor),
                ),
                SizedBox(height: size.height * 0.04),
                // Title
                Text(
                  "Exciting New Features Available!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.secondaryColor,
                    fontSize: size.width < 650 ? 18 : 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),

                SizedBox(height: size.height * 0.02),

                // Subtitle
                Text(
                  "We've released a new version with amazing improvements. Please update your app to continue enjoying the best experience.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.secondaryColor.withValues(alpha: 0.8),
                    fontSize: size.width < 650 ? 14 : 16,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),

                SizedBox(height: size.height * 0.04),

                // Version Info Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Current Version:",
                            style: TextStyle(
                              color: AppColors.secondaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            updateResult.currentVersion,
                            style: const TextStyle(
                              color: AppColors.secondaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Latest Version:",
                            style: TextStyle(
                              color: AppColors.secondaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            updateResult.storeVersion ?? "Unknown",
                            style: const TextStyle(
                              color: AppColors.statusAccepted,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Update Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (onUpdatePressed != null) {
                        onUpdatePressed!();
                      } else {
                        await ForceUpdateService.launchStore();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryColor,
                      foregroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      "Update Now",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: size.height * 0.02),

                // Platform Info
                Text(
                  "You'll be redirected to Play Store",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.secondaryColor.withValues(alpha: 0.6),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                SizedBox(height: size.height * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
