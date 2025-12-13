import 'package:flutter/material.dart';
import 'auth/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _carAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Separate animation for car to start from center and grow
    _carAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    const double carWidth = 70.0; // Increased from 50 to 70
    const double carHeight = 70.0; // Increased height
    const Color brandGreen = Color(0xFF43A047);

    return Scaffold(
      backgroundColor: const Color(0xFF151717),
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: ParticlePainter(_controller.value)),
          ),

          Positioned.fill(
            child: CustomPaint(painter: WindLinesPainter(_controller.value)),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),

              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 0.8 + (_animation.value * 0.2),
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: brandGreen,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: brandGreen.withOpacity(0.5),
                            blurRadius: 30 * _controller.value,
                            spreadRadius: 5 * _controller.value,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.eco,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),

              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _controller.value,
                    child: Column(
                      children: [
                        const Text(
                          "Way2Sustain",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Smart Green Travel Planner",
                          style: TextStyle(
                            fontSize: 16,
                            // ignore: deprecated_member_use
                            color: brandGreen.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const Spacer(flex: 2),

              SizedBox(
                height: 90, // Increased height to accommodate larger car
                width: double.infinity,
                child: AnimatedBuilder(
                  animation: _carAnimation,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        // Dashed line
                        CustomPaint(
                          size: Size(screenWidth, 2),
                          painter: DashedLinePainter(),
                        ),

                        // Progress bar
                        Container(
                          width: screenWidth * _carAnimation.value,
                          height: 4,
                          decoration: BoxDecoration(
                            color: brandGreen,
                            boxShadow: [
                              BoxShadow(
                                color: brandGreen,
                                blurRadius: 10 * _controller.value,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),

                        // Car container positioned at the end of progress
                        Positioned(
                          left:
                              (screenWidth * _carAnimation.value) -
                              carWidth +
                              35, // Adjusted position
                          child: SizedBox(
                            width: carWidth,
                            height: carHeight,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Glow effect - increased size
                                AnimatedBuilder(
                                  animation: _controller,
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scale: 0.9 + (_carAnimation.value * 0.3),
                                      child: Container(
                                        width: 60, // Increased from 40
                                        height: 60, // Increased from 40
                                        decoration: BoxDecoration(
                                          color: brandGreen
                                              // ignore: deprecated_member_use
                                              .withOpacity(
                                                0.2 * _controller.value,
                                              ),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              // ignore: deprecated_member_use
                                              color: brandGreen.withOpacity(
                                                0.6 * _controller.value,
                                              ),
                                              blurRadius:
                                                  25 *
                                                  _controller
                                                      .value, // Increased blur
                                              spreadRadius:
                                                  8 *
                                                  _controller
                                                      .value, // Increased spread
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),

                                // Car image with scale animation - increased size
                                AnimatedBuilder(
                                  animation: _carAnimation,
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scale: 0.8 + (_carAnimation.value * 0.4),
                                      child: Image.asset(
                                        'assets/images/electric_car.png',
                                        width: 65, // Increased from 40
                                        height: 65, // Increased from 40
                                        fit: BoxFit.contain,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Speed lines
                        Positioned(
                          left: screenWidth * _carAnimation.value,
                          child: CustomPaint(
                            size: const Size(120, 50), // Increased size
                            painter: SpeedLinesPainter(_controller.value),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) => Text(
                  "${(_animation.value * 100).toInt()}%",
                  style: TextStyle(
                    // ignore: deprecated_member_use
                    color: Colors.white.withOpacity(
                      0.7 + (_animation.value * 0.3),
                    ),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),

              const Spacer(flex: 2),

              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _controller.value > 0.5
                        ? (_controller.value - 0.5) * 2
                        : 0,
                    child: Column(
                      children: const [
                        Text(
                          "Ride with Greener",
                          style: TextStyle(
                            fontSize: 20,
                            color: brandGreen,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.1,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Journey to a sustainable future",
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                  );
                },
              ),

              Column(
                children: [
                  Text(
                    "Plan Green. Travel Clean.",
                    style: TextStyle(
                      // ignore: deprecated_member_use
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Reducing carbon footprint, one ride at a time",
                    style: TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ],
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double dashWidth = 9;
    const double dashSpace = 5;
    double startX = 0;
    final paint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 2;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class ParticlePainter extends CustomPainter {
  final double animationValue;

  ParticlePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      // ignore: deprecated_member_use
      ..color = const Color(0xFF43A047).withOpacity(0.1)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 20; i++) {
      final x = (size.width * 0.1) + (i * 80);
      final y = 100 + (60 * i * animationValue) % size.height;

      canvas.drawCircle(Offset(x, y), 2 + (i % 4).toDouble(), paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}

class SpeedLinesPainter extends CustomPainter {
  final double animationValue;

  SpeedLinesPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      // ignore: deprecated_member_use
      ..color = const Color(0xFF43A047).withOpacity(0.1)
      ..strokeWidth = 1;

    for (int i = 0; i < 15; i++) {
      final x = size.width - (i * 20 * animationValue);
      final y = size.height * 0.6;
      final length = 20 + (i % 5).toDouble();

      canvas.drawLine(Offset(x, y), Offset(x - length, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant SpeedLinesPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}

class WindLinesPainter extends CustomPainter {
  final double animationValue;

  WindLinesPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      // ignore: deprecated_member_use
      ..color = const Color(0xFF43A047).withOpacity(0.5)
      ..strokeWidth = 1;

    for (int i = 0; i < 5; i++) {
      final x1 = size.width;
      final y1 = i * 5.0;
      const x2 = 0.0;
      final y2 = i * 5.0;

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant WindLinesPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
