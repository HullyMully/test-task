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

// Two AnimationControllers → TickerProviderStateMixin (plural).
class _PaywallScreenState extends State<PaywallScreen>
    with TickerProviderStateMixin {
  // Slow breathe: drives outer box-shadow intensity and badge glow.
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  // Constant-speed sweep: drives the comet of light on the border.
  late AnimationController _sweepController;
  late Animation<double> _sweepAnimation;

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

    // One full revolution every 5 seconds, linear, forever.
    _sweepController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    )..repeat();
    _sweepAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _sweepController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    _sweepController.dispose();
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
    final ctaBottomPadding = math.max(bottomInset, 16.0) + 16.0;
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
          child: CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
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
                      const SizedBox(height: 4),
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
                      _buildBullet('Offline mode \u2014 practice anywhere'),
                      const SizedBox(height: 32),
                      _buildMonthlyCard(),
                      // Extra gap so the "Most Popular" badge has room above.
                      const SizedBox(height: 30),
                      _buildYearlyCard(),
                    ],
                  ),
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24, 24, 24, ctaBottomPadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
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
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 56,
                        child: FilledButton(
                          onPressed: planSelected
                              ? () => _onTryFree(subscription)
                              : null,
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
            ],
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
            '\u2022',
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

  // ── Monthly card ──────────────────────────────────────────────────────────

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

  // ── Yearly card (premium) ─────────────────────────────────────────────────

  Widget _buildYearlyCard() {
    final isSelected = _selectedPlan == _Plan.yearly;

    // Listen to both animations together so the builder fires on every tick
    // of either the glow breathe or the border sweep.
    return AnimatedBuilder(
      animation: Listenable.merge([_glowAnimation, _sweepAnimation]),
      builder: (context, _) {
        final pulse = _glowAnimation.value; // 0.4 → 1.0
        final sweepAngle = _sweepAnimation.value * 2 * math.pi; // 0 → 2π

        // Outer ambient glow — soft and large.
        final outerGlowOpacity =
            isSelected ? 0.35 + 0.15 * pulse : 0.15 + 0.08 * pulse;
        // Inner glow — tighter, makes the card pop from the background.
        final innerGlowOpacity =
            isSelected ? 0.25 * pulse : 0.10 * pulse;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFD4AF37).withValues(alpha: outerGlowOpacity),
                blurRadius: isSelected
                    ? 28 + 12 * pulse
                    : 18 + 6 * pulse,
                spreadRadius: 0,
                offset: const Offset(0, 2),
              ),
              BoxShadow(
                color: const Color(0xFFD4AF37).withValues(alpha: innerGlowOpacity),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Card with the animated sweep border painted over it.
              GestureDetector(
                onTap: () => setState(() => _selectedPlan = _Plan.yearly),
                child: CustomPaint(
                  // foregroundPainter draws on top of the card but is not
                  // clipped by the ClipRRect inside _GlassCard.
                  foregroundPainter: _SweepBorderPainter(
                    angle: sweepAngle,
                    pulse: pulse,
                    isSelected: isSelected,
                  ),
                  child: _GlassCard(
                    // The static border is hidden; the CustomPainter owns it.
                    borderColor: Colors.transparent,
                    borderWidth: 0,
                    // Subtle warm gold tint distinguishes this from monthly.
                    backgroundColor:
                        const Color(0xFFD4AF37).withValues(alpha: 0.06),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.auto_awesome,
                                    color: const Color(0xFFD4AF37)
                                        .withValues(alpha: 0.9),
                                    size: 14,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Yearly',
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
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

              // ── "Most Popular" badge ──────────────────────────────────────
              // Floats 16px above the card top via Clip.none on the Stack.
              Positioned(
                top: -16,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFFFE066),
                          Color(0xFFD4AF37),
                          Color(0xFFC8960C),
                        ],
                        stops: [0.0, 0.5, 1.0],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        // Breathes with the glow animation.
                        BoxShadow(
                          color: const Color(0xFFD4AF37)
                              .withValues(alpha: 0.35 + 0.25 * pulse),
                          blurRadius: 10 + 6 * pulse,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.auto_awesome,
                          color: Color(0xFF3A2800),
                          size: 12,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'MOST POPULAR',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF3A2800),
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Sweep border painter ───────────────────────────────────────────────────
//
// Draws a SweepGradient stroke around the rounded-rectangle border.
// The gradient has a bright gold "head" that fades into a long dim tail,
// making a comet-like shimmer that rotates continuously.

class _SweepBorderPainter extends CustomPainter {
  final double angle;      // current head position in radians (0 → 2π)
  final double pulse;      // from glowAnimation (0.4 → 1.0)
  final bool isSelected;

  const _SweepBorderPainter({
    required this.angle,
    required this.pulse,
    required this.isSelected,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const borderRadius = 20.0;
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(
      rect,
      const Radius.circular(borderRadius),
    );

    final double headOpacity = isSelected ? 0.95 : 0.65;
    final double tailOpacity = isSelected ? 0.10 : 0.05;

    // Sweep gradient: bright head at `angle`, long dim tail trailing behind.
    final sweepShader = SweepGradient(
      center: Alignment.center,
      startAngle: angle,
      endAngle: angle + 2 * math.pi,
      colors: [
        const Color(0xFFFFE066).withOpacity(headOpacity),
        const Color(0xFFD4AF37).withOpacity(headOpacity * 0.75),
        const Color(0xFFD4AF37).withOpacity(tailOpacity * 1.5),
        const Color(0xFF8B6914).withOpacity(tailOpacity),
        const Color(0xFFFFE066).withOpacity(headOpacity),
      ],
      stops: const [0.0, 0.10, 0.40, 0.80, 1.0],
    ).createShader(rect);

    final strokeWidth = isSelected ? 2.5 : 1.8;

    // Main animated border stroke.
    canvas.drawRRect(
      rrect,
      Paint()
        ..shader = sweepShader
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    // When selected, add a soft ambient halo around the border that breathes.
    if (isSelected) {
      canvas.drawRRect(
        rrect,
        Paint()
          ..color =
              const Color(0xFFD4AF37).withOpacity(0.06 + 0.06 * pulse)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth + 5
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
      );
    }
  }

  @override
  bool shouldRepaint(_SweepBorderPainter old) =>
      old.angle != angle ||
      old.pulse != pulse ||
      old.isSelected != isSelected;
}

// ── Plan radio indicator ───────────────────────────────────────────────────

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
        color: isSelected ? const Color(0xFFD4AF37) : Colors.transparent,
        border: Border.all(
          color: isSelected ? const Color(0xFFD4AF37) : Colors.white38,
          width: 2,
        ),
      ),
      child: isSelected
          ? const Icon(Icons.check, color: Color(0xFF0D0D12), size: 14)
          : null,
    );
  }
}

// ── Glass card ────────────────────────────────────────────────────────────

class _GlassCard extends StatelessWidget {
  final Widget child;
  final Color borderColor;
  final double borderWidth;
  final Color? backgroundColor; // overrides the default white-glass tint

  const _GlassCard({
    required this.child,
    required this.borderColor,
    required this.borderWidth,
    this.backgroundColor,
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
            color: backgroundColor ?? Colors.white.withValues(alpha: 0.08),
          ),
          child: child,
        ),
      ),
    );
  }
}
