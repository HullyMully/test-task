import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:zenpulse/constants/affirmations.dart';
import 'package:zenpulse/models/meditation.dart';
import 'package:zenpulse/providers/subscription_provider.dart';
import 'package:zenpulse/screens/paywall_screen.dart';

const int kFreeMeditationsCount = 2;

final List<Meditation> kMeditations = [
  const Meditation(id: '1', title: 'Morning Calm', duration: '10 min', index: 0),
  const Meditation(id: '2', title: 'Deep Focus', duration: '15 min', index: 1),
  const Meditation(id: '3', title: 'Sleep Wind Down', duration: '20 min', index: 2),
  const Meditation(id: '4', title: 'Anxiety Relief', duration: '12 min', index: 3),
  const Meditation(id: '5', title: 'Body Scan', duration: '18 min', index: 4),
  const Meditation(id: '6', title: 'Loving Kindness', duration: '14 min', index: 5),
];

class MeditationsScreen extends StatefulWidget {
  const MeditationsScreen({super.key});

  @override
  State<MeditationsScreen> createState() => _MeditationsScreenState();
}

class _MeditationsScreenState extends State<MeditationsScreen> {
  final Random _random = Random();

  void _showAffirmationModal(String affirmation) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).padding.bottom,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A1A24),
              Color(0xFF0D0D12),
            ],
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD4AF37).withOpacity(0.2),
              blurRadius: 24,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Your affirmation',
                  style: GoogleFonts.inter(
                    color: const Color(0xFFD4AF37),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  affirmation,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 22,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: Text(
                      'Close',
                      style: GoogleFonts.inter(
                        color: const Color(0xFFD4AF37),
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

  void _onMoodTap() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(
        child: Card(
          color: Color(0xFF1A1A24),
          child: Padding(
            padding: EdgeInsets.all(32),
            child: CircularProgressIndicator(
              color: Color(0xFFD4AF37),
              strokeWidth: 2,
            ),
          ),
        ),
      ),
    );
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    Navigator.of(context).pop();
    final affirmation =
        kAffirmations[_random.nextInt(kAffirmations.length)];
    _showAffirmationModal(affirmation);
  }

  void _showGoPremiumSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).padding.bottom,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A24),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline, color: Color(0xFFD4AF37), size: 48),
                const SizedBox(height: 16),
                Text(
                  'Go Premium',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Unlock all meditations and offline mode.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const PaywallScreen(),
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AF37),
                      foregroundColor: const Color(0xFF0D0D12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'Unlock ZenPulse',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600),
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

  @override
  Widget build(BuildContext context) {
    final subscription = context.watch<SubscriptionProvider>();
    final isSubscribed = subscription.isSubscribed;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0D0D12),
              Color(0xFF1A1A24),
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ZenPulse',
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFD4AF37),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.person_outline, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: Text(
                    'How are you feeling?',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _MoodButton(emoji: '😔', onTap: _onMoodTap),
                      _MoodButton(emoji: '😐', onTap: _onMoodTap),
                      _MoodButton(emoji: '😊', onTap: _onMoodTap),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: Text(
                    'Meditations',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final meditation = kMeditations[index];
                      final isLocked = !isSubscribed && meditation.index >= kFreeMeditationsCount;
                      return _MeditationCard(
                        meditation: meditation,
                        isLocked: isLocked,
                        onTap: () {
                          if (isLocked) {
                            _showGoPremiumSheet();
                          }
                          // else could navigate to player
                        },
                      );
                    },
                    childCount: kMeditations.length,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoodButton extends StatelessWidget {
  final String emoji;
  final VoidCallback onTap;

  const _MoodButton({required this.emoji, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.08),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 72,
          height: 72,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white24),
          ),
          child: Text(emoji, style: const TextStyle(fontSize: 32)),
        ),
      ),
    );
  }
}

class _MeditationCard extends StatelessWidget {
  final Meditation meditation;
  final bool isLocked;
  final VoidCallback onTap;

  const _MeditationCard({
    required this.meditation,
    required this.isLocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isLocked
                      ? [
                          Colors.grey.shade800,
                          Colors.grey.shade900,
                        ]
                      : [
                          const Color(0xFF2A2A35),
                          const Color(0xFF1A1A24),
                        ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isLocked ? Colors.grey.shade700 : Colors.white12,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.image_outlined,
                          color: isLocked ? Colors.grey : Colors.white38,
                          size: 36,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meditation.title,
                          style: GoogleFonts.inter(
                            color: isLocked ? Colors.grey : Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          meditation.duration,
                          style: GoogleFonts.inter(
                            color: isLocked ? Colors.grey : Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLocked)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  color: Colors.black54,
                  child: Center(
                    child: Icon(
                      Icons.lock,
                      color: Colors.white.withOpacity(0.9),
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
