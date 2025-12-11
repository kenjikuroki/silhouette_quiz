import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import '../state/quiz_app_state.dart';

class SplashScreen extends StatefulWidget {
  final Future<void> Function(QuizAppState appState) onInitializationComplete;

  const SplashScreen({Key? key, required this.onInitializationComplete})
      : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // 1: factory1
  // 2: factory2
  bool _showFactory1 = true;
  Timer? _timer;
  bool _animationStarted = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage('assets/images/icon/factory1.png'), context);
    precacheImage(const AssetImage('assets/images/icon/factory2.png'), context);
  }

  Future<void> _initializeApp() async {
    // 1. Start a timer for the initial "Native Splash" phase (1.0 second)
    //    We want the native icon to stay visible for at least this long.
    final nativeSplashDuration = Future.delayed(const Duration(milliseconds: 1000));

    // 2. Initialize App State in parallel
    final appState = QuizAppState();
    await appState.initialize();
    await appState.purchaseService.initialize();

    // 3. Wait for the 1s duration to complete
    await nativeSplashDuration;

    // 4. CRITICAL: Remove Native Splash Screen
    //    This must happen before we do anything else.
    FlutterNativeSplash.remove();

    // 5. Start Factory Animation
    if (mounted) {
      setState(() {
        _animationStarted = true;
      });
      _startFactoryAnimation();

      // 6. Show animation for 2 seconds (optional, but requested previously)
      await Future.delayed(const Duration(seconds: 2));

      // 7. Proceed to Home
      if (mounted) {
        await widget.onInitializationComplete(appState);
      }
    }
  }

  void _startFactoryAnimation() {
    _timer = Timer.periodic(const Duration(milliseconds: 700), (timer) {
      if (mounted) {
        setState(() {
          _showFactory1 = !_showFactory1;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    // While animation hasn't started (during the first 1s), we show nothing
    // because the Native Splash is covering the screen via preserve().
    if (!_animationStarted) {
      return const SizedBox.shrink();
    }

    return Image.asset(
      _showFactory1
          ? 'assets/images/icon/factory1.png'
          : 'assets/images/icon/factory2.png',
      key: ValueKey<bool>(_showFactory1),
      width: 400,
      fit: BoxFit.contain,
    );
  }
}
