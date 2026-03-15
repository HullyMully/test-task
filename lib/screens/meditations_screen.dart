import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:zenpulse/constants/ai_mood_affirmations.dart';
import 'package:zenpulse/models/meditation.dart';
import 'package:zenpulse/providers/subscription_provider.dart';
import 'package:zenpulse/screens/paywall_screen.dart';

const int kFreeMeditationsCount = 2;

// Unsplash nature/zen/meditation themed images (w=500 for card size).
const _kMorningCalm =
    'https://images.unsplash.com/photo-1495616811223-4d98c6e9c869?w=500&q=80';
const _kDeepFocus =
    'https://images.unsplash.com/photo-1518241353330-0f7941c2d1b7?w=500&q=80';
const _kSleepWindDown =
    'https://images.unsplash.com/photo-1535332371349-a5d229f49c4c?w=500&q=80';
const _kAnxietyRelief =
    'https://images.unsplash.com/photo-1505142468610-359e7d316be0?w=500&q=80';
const _kBodyScan =
    'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=500&q=80';
const _kLovingKindness =
    'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=500&q=80';

final List<Meditation> kMeditations = [
  const Meditation(
    id: '1',
    title: 'Morning Calm',
    duration: '10 min',
    index: 0,
    imageUrl: _kMorningCalm,
  ),
  const Meditation(
    id: '2',
    title: 'Deep Focus',
    duration: '15 min',
    index: 1,
    imageUrl: _kDeepFocus,
  ),
  const Meditation(
    id: '3',
    title: 'Sleep Wind Down',
    duration: '20 min',
    index: 2,
    imageUrl: _kSleepWindDown,
  ),
  const Meditation(
    id: '4',
    title: 'Anxiety Relief',
    duration: '12 min',
    index: 3,
    imageUrl: _kAnxietyRelief,
  ),
  const Meditation(
    id: '5',
    title: 'Body Scan',
    duration: '18 min',
    index: 4,
    imageUrl: _kBodyScan,
  ),
  const Meditation(
    id: '6',
    title: 'Loving Kindness',
    duration: '14 min',
    index: 5,
    imageUrl: _kLovingKindness,
  ),
];

enum _Mood { sad, neutral, happy }

class MeditationsScreen extends StatefulWidget {
  const MeditationsScreen({super.key});

  @override
  State<MeditationsScreen> createState() => _MeditationsScreenState();
}

class _MeditationsScreenState extends State<MeditationsScreen> {
  void _showProfileSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Profile settings coming soon',
          style: GoogleFonts.inter(color: Colors.white),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF2A2A35),
      ),
    );
  }

  void _showPlayingSnackBar(String meditationTitle) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Playing $meditationTitle...',
          style: GoogleFonts.inter(color: Colors.white),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF2A2A35),
      ),
    );
  }

  void _showAiVibeModal(String affirmation, String moodLabel) {
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
              color: const Color(0xFFD4AF37).withValues(alpha: 0.25),
              blurRadius: 28,
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
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: const Color(0xFFD4AF37).withValues(alpha: 0.9),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'AI Daily Vibe',
                      style: GoogleFonts.inter(
                        color: const Color(0xFFD4AF37),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  moodLabel,
                  style: GoogleFonts.inter(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  affirmation,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 22,
                    color: Colors.white,
                    height: 1.45,
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

  Future<void> _onMoodTap(_Mood mood) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(
        child: Card(
          color: Color(0xFF1A1A24),
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: Color(0xFFD4AF37),
                  strokeWidth: 2,
                ),
                SizedBox(height: 16),
                Text(
                  'Reading your vibe...',
                  style: TextStyle(color: Colors.white54, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    Navigator.of(context).pop();
    String affirmation;
    String moodLabel;
    switch (mood) {
      case _Mood.sad:
        affirmation = kAffirmationSad;
        moodLabel = 'For when you\'re feeling down';
        break;
      case _Mood.neutral:
        affirmation = kAffirmationNeutral;
        moodLabel = 'For a balanced moment';
        break;
      case _Mood.happy:
        affirmation = kAffirmationHappy;
        moodLabel = 'For your positive energy';
        break;
    }
    _showAiVibeModal(affirmation, moodLabel);
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
          border: Border.all(
            color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.lock_outline,
                  color: Color(0xFFD4AF37),
                  size: 48,
                ),
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
                  style: GoogleFonts.inter(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      Navigator.of(context).push(
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

  void _onMeditationTap(Meditation meditation, bool isLocked) {
    if (isLocked) {
      _showGoPremiumSheet();
    } else {
      _showPlayingSnackBar(meditation.title);
    }
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
              // ── App bar: logo + profile ───────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
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
                        onPressed: _showProfileSnackBar,
                        icon: const Icon(
                          Icons.person_outline,
                          color: Colors.white70,
                        ),
                        tooltip: 'Profile',
                      ),
                    ],
                  ),
                ),
              ),

              // ── AI Daily Vibe section ────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                  child: Text(
                    'AI Daily Vibe',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                  child: Text(
                    'How are you feeling right now?',
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _MoodButton(
                        emoji: '😔',
                        onTap: () => _onMoodTap(_Mood.sad),
                      ),
                      _MoodButton(
                        emoji: '😐',
                        onTap: () => _onMoodTap(_Mood.neutral),
                      ),
                      _MoodButton(
                        emoji: '😊',
                        onTap: () => _onMoodTap(_Mood.happy),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Meditations grid ──────────────────────────────────────────
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
                      final isLocked = !isSubscribed &&
                          meditation.index >= kFreeMeditationsCount;
                      return _MeditationCard(
                        meditation: meditation,
                        isLocked: isLocked,
                        onTap: () => _onMeditationTap(meditation, isLocked),
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

// ── Mood button (large emoji, ripple) ───────────────────────────────────────

class _MoodButton extends StatelessWidget {
  final String emoji;
  final VoidCallback onTap;

  const _MoodButton({required this.emoji, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        splashColor: const Color(0xFFD4AF37).withValues(alpha: 0.2),
        highlightColor: const Color(0xFFD4AF37).withValues(alpha: 0.1),
        child: Container(
          width: 80,
          height: 80,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white24),
          ),
          child: Text(emoji, style: const TextStyle(fontSize: 36)),
        ),
      ),
    );
  }
}

// ── Meditation card (image + gradient overlay + InkWell) ─────────────────────

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
    final imageUrl = meditation.imageUrl;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: const Color(0xFFD4AF37).withValues(alpha: 0.2),
        highlightColor: const Color(0xFFD4AF37).withValues(alpha: 0.08),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background: network image or fallback gradient
                  if (imageUrl != null && !isLocked)
                    Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _fallbackGradient(),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return _fallbackGradient();
                      },
                    )
                  else if (imageUrl != null && isLocked)
                    ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Colors.grey.withValues(alpha: 0.7),
                        BlendMode.saturation,
                      ),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _fallbackGradient(),
                      ),
                    )
                  else
                    _fallbackGradient(),
                  // Dark gradient overlay at bottom so text is readable
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.85),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Title + duration at bottom
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    meditation.title,
                    style: GoogleFonts.inter(
                      color: Colors.white,
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
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            // Lock overlay when locked
            if (isLocked)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    color: Colors.black54,
                    child: Center(
                      child: Icon(
                        Icons.lock,
                        color: Colors.white.withValues(alpha: 0.9),
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _fallbackGradient() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isLocked
              ? [Colors.grey.shade800, Colors.grey.shade900]
              : [
                  const Color(0xFF2A2A35),
                  const Color(0xFF1A1A24),
                ],
        ),
      ),
    );
  }
}
