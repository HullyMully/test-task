import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:zenpulse/providers/subscription_provider.dart';

enum _Plan { monthly, yearly }

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  _Plan? _selectedPlan;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  void _onTryFree(SubscriptionProvider subscription) {
    subscription.unlockFree();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final subscription = context.watch<SubscriptionProvider>();
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final buttonBottomPadding = math.max(bottomInset, 16.0) + 24.0;
    final planSelected = _selectedPlan != null;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0D0D12),
              Color(0xFF1A1A24),
              Color(0xFF0F1419),
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(24, 0, 24, buttonBottomPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Close button row ──────────────────────────────────────
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: Colors.white54),
                      tooltip: 'Close',
                    ),
                  ),
                ),

                // ── Headline ──────────────────────────────────────────────
                Text(
                  'Unlock Inner Peace',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),

                _buildBullet('AI Guided meditations tailored to you'),
                _buildBullet('4K nature sounds & binaural beats'),
                _buildBullet('Offline mode — practice anywhere'),
                const SizedBox(height: 32),

                // ── Plan cards ───────────────────────────────────────────
                _buildMonthlyCard(),
                const SizedBox(height: 20),
                _buildYearlyCard(),
                const SizedBox(height: 24),

                // ── CTA hint ─────────────────────────────────────────────
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: planSelected ? 0.0 : 1.0,
                  child: Text(
                    'Select a plan to continue',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: Colors.white38,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // ── Try Free button ───────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton(
                    onPressed: planSelected ? () => _onTryFree(subscription) : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AF37),
                      disabledBackgroundColor: Colors.white12,
                      disabledForegroundColor: Colors.white30,
                      foregroundColor: const Color(0xFF0D0D12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Try Free',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '•',
            style: GoogleFonts.inter(
              color: const Color(0xFFD4AF37),
              fontSize: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(color: Colors.white70, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyCard() {
    final isSelected = _selectedPlan == _Plan.monthly;
    return GestureDetector(
      onTap: () => setState(() => _selectedPlan = _Plan.monthly),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFD4AF37).withValues(alpha: 0.25),
                    blurRadius: 16,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: _GlassCard(
          borderColor: isSelected
              ? const Color(0xFFD4AF37)
              : Colors.white.withValues(alpha: 0.15),
          borderWidth: isSelected ? 2.0 : 1.0,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monthly',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '\$9.99 / month',
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                _PlanSelector(isSelected: isSelected),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildYearlyCard() {
    final isSelected = _selectedPlan == _Plan.yearly;
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        final glowOpacity = isSelected
            ? 0.45 * _glowAnimation.value
            : 0.25 * _glowAnimation.value;
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFD4AF37).withValues(alpha: glowOpacity),
                blurRadius: isSelected
                    ? 20 + 10 * _glowAnimation.value
                    : 14 + 6 * _glowAnimation.value,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              child!,
              Positioned(
                top: -12,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AF37),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFD4AF37)
                              .withValues(alpha: 0.4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Text(
                      'Most Popular',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF0D0D12),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      child: GestureDetector(
        onTap: () => setState(() => _selectedPlan = _Plan.yearly),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: _GlassCard(
            borderColor: isSelected
                ? const Color(0xFFD4AF37)
                : const Color(0xFFD4AF37).withValues(alpha: 0.45),
            borderWidth: isSelected ? 2.0 : 1.5,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Yearly',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '\$59.99 / year',
                        style: GoogleFonts.inter(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D5016),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Save 50%',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF90EE90),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      _PlanSelector(isSelected: isSelected),
                    ],
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

/// Small radio-style selection indicator used on each plan card.
class _PlanSelector extends StatelessWidget {
  final bool isSelected;
  const _PlanSelector({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected
            ? const Color(0xFFD4AF37)
            : Colors.transparent,
        border: Border.all(
          color: isSelected
              ? const Color(0xFFD4AF37)
              : Colors.white38,
          width: 2,
        ),
      ),
      child: isSelected
          ? const Icon(Icons.check, color: Color(0xFF0D0D12), size: 14)
          : null,
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  final Color borderColor;
  final double borderWidth;

  const _GlassCard({
    required this.child,
    required this.borderColor,
    required this.borderWidth,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor, width: borderWidth),
            color: Colors.white.withValues(alpha: 0.08),
          ),
          child: child,
        ),
      ),
    );
  }
}
