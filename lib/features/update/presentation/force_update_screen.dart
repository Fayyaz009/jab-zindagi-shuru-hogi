import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../domain/update_config.dart';

class ForceUpdateScreen extends StatelessWidget {
  final UpdateConfig config;

  const ForceUpdateScreen({
    super.key,
    required this.config,
  });

  Future<void> _launchUpdateUrl(BuildContext context) async {
    final uri = Uri.parse(config.updateUrl);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw 'Could not launch URL';
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Update link open nahi ho saka. Baraye meharbani Play Store par check karein.',
              style: TextStyle(fontFamily: 'Urdu', fontSize: 16),
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Premium theme colors
    const backgroundColor1 = Color(0xFF0D102A); // Premium dark indigo
    const backgroundColor2 = Color(0xFF1A1F3C); // Lighter dark indigo
    const accentGold = Color(0xFFC5A358); // Muted gold

    return PopScope(
      canPop: false, // ✅ Prevents user from going back using Android back button/gestures
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [backgroundColor1, backgroundColor2],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),

                  /// Glowing Icon Container
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: accentGold.withValues(alpha: 0.1), // Modern withValues
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: accentGold.withValues(alpha: 0.3),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: accentGold.withValues(alpha: 0.05),
                            blurRadius: 40,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.system_update_rounded,
                        size: 72,
                        color: accentGold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// Title
                  Text(
                    config.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Urdu',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// Message / Description
                  Text(
                    config.updateMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Urdu',
                      fontSize: 18,
                      color: Color(0xFFB0B3C7),
                      height: 1.6,
                    ),
                  ),

                  const Spacer(),

                  /// "Update Now" Action Button
                  ElevatedButton.icon(
                    onPressed: () => _launchUpdateUrl(context),
                    icon: const Icon(
                      Icons.double_arrow_rounded,
                      color: Color(0xFF3E2723), // dark brown text color
                    ),
                    label: const Text(
                      'Update Now (Abhi Update Karein)',
                      style: TextStyle(
                        fontFamily: 'Urdu',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3E2723),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentGold,
                      foregroundColor: const Color(0xFF3E2723),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 5,
                      shadowColor: accentGold.withValues(alpha: 0.3),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
