import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/bloc/premium_bloc/premium_bloc.dart';
import 'package:jab_zindagi_shuru_hogi_inzaar/services/iap_service.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: colorScheme.onSurface),
      ),
      body: Stack(
        children: [
          // 1. Decorative Background Elements
          _buildBackgroundDecor(colorScheme),

          BlocConsumer<PremiumBloc, PremiumState>(
            listener: (context, state) {
              if (state is PremiumError) {
                _showSnackBar(context, state.message, Colors.redAccent);
              } else if (state is PremiumLoaded && state.isPremium) {
                _showSnackBar(
                  context,
                  'Purchase successful! JazakAllah.',
                  Colors.green,
                );
              }
            },
            builder: (context, state) {
              return SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildAnimatedHeader(),
                      const SizedBox(height: 40),

                      // Title & Subtitle
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Unlock Full Access',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: colorScheme.onSurface,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Support the mission to spread knowledge and enjoy an ad-free experience.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                            height: 1.5,
                          ),
                        ),
                      ),

                      const SizedBox(height: 48),

                      // Benefit Cards (using a custom list)
                      _buildBenefitsGrid(context),

                      const SizedBox(height: 60),

                      // CTA Section
                      if (state.isPremium)
                        _buildPremiumActiveCard()
                      else if (state is PremiumLoading)
                        const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFD4AF37),
                          ),
                        )
                      else
                        _buildPurchaseControls(context, state),

                      _buildRestoreButton(context),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRestoreButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: InkWell(
        onTap: () => context.read<PremiumBloc>().add(RestorePremium()),
        borderRadius: BorderRadius.circular(12), // Visual feedback area
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min, // Keeps the button compact
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. Soft Rounded Icon Container
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.refresh_rounded, // Using a clean refresh/restore icon
                  size: 16,
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(width: 10),

              // 2. Refined Text
              Text(
                'Restore Purchases',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundDecor(ColorScheme colorScheme) {
    return Positioned.fill(
      child: Stack(
        children: [
          Positioned(
            top: -100,
            right: -50,
            child: CircleAvatar(
              radius: 150,
              backgroundColor: const Color(0xFFFFD700).withValues(alpha: 0.07),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: CircleAvatar(
              radius: 120,
              backgroundColor: colorScheme.primary.withValues(alpha: 0.05),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedHeader() {
    return Container(
      height: 160,
      width: 160,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD700).withValues(alpha: 0.2),
            blurRadius: 40,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Spinning or layered rings
          _buildRing(160, 0.05),
          _buildRing(130, 0.1),
          _buildRing(100, 0.2),
          const Icon(
            Icons.auto_awesome_rounded,
            size: 70,
            color: Color(0xFFD4AF37),
          ),
        ],
      ),
    );
  }

  Widget _buildRing(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFFFD700).withValues(alpha: opacity),
          width: 2,
        ),
      ),
    );
  }

  Widget _buildBenefitsGrid(BuildContext context) {
    final List<Map<String, dynamic>> benefits = [
      {
        'icon': Icons.ads_click_rounded,
        'title': 'No Ads',
        'desc': 'Zero interruptions',
      },
      {
        'icon': Icons.download_done_rounded,
        'title': 'Offline',
        'desc': 'Read anywhere',
      },
      {
        'icon': Icons.favorite_rounded,
        'title': 'Sadaqah',
        'desc': 'Support mission',
      },
      {'icon': Icons.star_rounded, 'title': 'Priority', 'desc': 'New features'},
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: benefits
          .map(
            (b) => Container(
              width: (MediaQuery.of(context).size.width / 2) - 32,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Icon(b['icon'], color: const Color(0xFFD4AF37)),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      b['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      b['desc'],
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildPurchaseControls(BuildContext context, PremiumState state) {
    final price = state.premiumProduct?.price ?? '150 PKR';

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 65,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color(0xFFC5A358), Color(0xFFB0893F)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFB0893F).withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () => _handlePremiumPurchase(context, state),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                price,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'One-time purchase. Lifetime access.',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumActiveCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1B5E20).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF1B5E20).withValues(alpha: 0.3),
        ),
      ),
      child: const Row(
        children: [
          Icon(Icons.verified_rounded, color: Color(0xFF2E7D32), size: 40),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Premium Active',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  'Thank you for your generosity.',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // ... _handlePremiumPurchase logic remains the same ...
}

Future<void> _handlePremiumPurchase(
  BuildContext context,
  PremiumState state,
) async {
  if (state.premiumProduct != null) {
    context.read<PremiumBloc>().add(PurchasePremium(state.premiumProduct!));
  } else {
    // Fallback if product wasn't loaded in state
    final iap = IAPService();
    try {
      final products = await iap.getProducts();
      if (products.isNotEmpty && context.mounted) {
        final premiumProduct = products.firstWhere(
          (p) => p.id == IAPService.productNoAds,
          orElse: () => products.first,
        );
        context.read<PremiumBloc>().add(PurchasePremium(premiumProduct));
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to fetch premium plans.')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}
