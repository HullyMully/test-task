import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:zenpulse/providers/subscription_provider.dart';
import 'package:zenpulse/screens/meditations_screen.dart';
import 'package:zenpulse/screens/paywall_screen.dart';

void main() {
  runApp(const ZenPulseApp());
}

class ZenPulseApp extends StatelessWidget {
  const ZenPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SubscriptionProvider(),
      child: MaterialApp(
        title: 'ZenPulse',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.dark(
            primary: const Color(0xFFD4AF37),
            surface: const Color(0xFF0D0D12),
            onSurface: Colors.white,
            onPrimary: const Color(0xFF0D0D12),
          ),
          fontFamily: GoogleFonts.inter().fontFamily,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const MeditationsScreen(),
          '/paywall': (context) => const PaywallScreen(),
        },
      ),
    );
  }
}
