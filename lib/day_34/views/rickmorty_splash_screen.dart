import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RickmortySplashScreen extends StatefulWidget {
  const RickmortySplashScreen({super.key});

  @override
  State<RickmortySplashScreen> createState() => _RickmortySplashScreenState();
} // RickmortySplashScreen

class _RickmortySplashScreenState extends State<RickmortySplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _portalController;
  late final AnimationController _outerRingController;
  double _progressValue = 0.0;
  Timer? _progressTimer;

  @override
  void initState() {
    super.initState();

    // Portal rotation (clockwise fallback)
    _portalController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    // Outer ring rotation (counter-clockwise fallback)
    _outerRingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: false);

    // Progress bar animation
    _progressTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      setState(() {
        if (_progressValue >= 1.0) {
          _progressTimer?.cancel();
          _navigateToHome();
        } else {
          _progressValue += 0.01;
        }
      });
    });
  } // initState

  void _navigateToHome() {
    Navigator.pushReplacementNamed(context, '/home');
  } // _navigateToHome

  @override
  void dispose() {
    _portalController.dispose();
    _outerRingController.dispose();
    _progressTimer?.cancel();
    super.dispose();
  } // dispose

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFF10131A);
    const neonGreen = Color(0xFF62FF8F);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Glowing portal background blobs
            Positioned(
              top: MediaQuery.of(context).size.height * 0.15,
              left: MediaQuery.of(context).size.width * 0.1,
              right: MediaQuery.of(context).size.width * 0.1,
              child: Center(
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: neonGreen.withOpacity(0.08),
                        blurRadius: 100,
                        spreadRadius: 40,
                      ), // BoxShadow
                    ], // boxShadow
                  ), // BoxDecoration
                ), // Container
              ), // Center
            ), // Positioned

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title text
                  Text(
                    'Rick and Morty',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      color: neonGreen,
                      letterSpacing: 1.2,
                      shadows: [
                        Shadow(
                          color: neonGreen,
                          blurRadius: 20,
                        ), // Shadow
                      ], // shadows
                    ), // TextStyle
                  ), // Text
                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    'CHARACTER EXPLORER',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withOpacity(0.9),
                      letterSpacing: 4.0,
                    ), // TextStyle
                  ), // Text
                  const SizedBox(height: 50),

                  // Portal Lottie Animation with Fallback
                  SizedBox(
                    width: 280,
                    height: 280,
                    child: Lottie.network(
                      'https://lottie.host/9e414c12-32b0-466d-96e0-264fb9b5a837/97b3R8Wcph.json',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildFallbackPortal();
                      },
                    ), // Lottie.network
                  ), // SizedBox
                  const SizedBox(height: 70),

                  // Progress bar matching image styling
                  Container(
                    width: 200,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ), // BoxDecoration
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 200 * _progressValue,
                        height: 4,
                        decoration: BoxDecoration(
                          color: neonGreen,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: neonGreen.withOpacity(0.5),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ), // BoxShadow
                          ], // boxShadow
                        ), // BoxDecoration
                      ), // Container
                    ), // Align
                  ), // Container
                ], // children
              ), // Column
            ), // Center
          ], // children
        ), // Stack
      ), // SafeArea
    ); // Scaffold
  } // build

  // Beautiful local procedural portal in case Lottie network fails
  Widget _buildFallbackPortal() {
    const bgColor = Color(0xFF10131A);
    const neonGreen = Color(0xFF62FF8F);
    final primaryGreen = neonGreen.withOpacity(0.7);

    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer counter-rotating portal halo
        RotationTransition(
          turns: Tween(begin: 1.0, end: 0.0).animate(_outerRingController),
          child: Container(
            width: 270,
            height: 270,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: primaryGreen.withOpacity(0.3),
                width: 2,
                style: BorderStyle.solid,
              ), // Border.all
            ), // BoxDecoration
            child: Stack(
              children: List.generate(4, (index) {
                final angle = (index * 90) * 3.14159 / 180;
                return Transform.rotate(
                  angle: angle,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: neonGreen,
                        shape: BoxShape.circle,
                      ), // BoxDecoration
                    ), // Container
                  ), // Align
                ); // Transform.rotate
              }), // List.generate
            ), // Stack
          ), // Container
        ), // RotationTransition

        // Rotating swirling green portal
        RotationTransition(
          turns: _portalController,
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: neonGreen.withOpacity(0.2),
                  blurRadius: 40,
                  spreadRadius: 5,
                ), // BoxShadow
              ], // boxShadow
              gradient: SweepGradient(
                colors: [
                  bgColor,
                  primaryGreen,
                  neonGreen,
                  primaryGreen,
                  bgColor,
                ], // colors
                stops: [0.0, 0.25, 0.5, 0.75, 1.0],
              ), // SweepGradient
            ), // BoxDecoration
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: bgColor,
                gradient: RadialGradient(
                  colors: [
                    bgColor,
                    Color(0xFF142422),
                  ], // colors
                ), // RadialGradient
              ), // BoxDecoration
              child: Center(
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: neonGreen.withOpacity(0.2),
                      width: 1,
                    ), // Border.all
                    gradient: RadialGradient(
                      colors: [
                        neonGreen.withOpacity(0.15),
                        Colors.transparent,
                      ], // colors
                    ), // RadialGradient
                  ), // BoxDecoration
                ), // Container
              ), // Center
            ), // Container
          ), // Container
        ), // RotationTransition

        // Inner portal silhouette or icon
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
            border: Border.all(
              color: neonGreen.withOpacity(0.1),
              width: 1,
            ), // Border.all
          ), // BoxDecoration
          child: Center(
            child: Icon(
              Icons.location_on,
              size: 50,
              color: neonGreen.withOpacity(0.9),
            ), // Icon
          ), // Center
        ), // Container
      ], // children
    ); // Stack
  } // _buildFallbackPortal
} // _RickmortySplashScreenState
