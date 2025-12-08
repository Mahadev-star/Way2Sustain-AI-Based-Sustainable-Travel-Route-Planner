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

  @override
  void initState() {
    super.initState();

    // Setup animation for 3 seconds
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Start the animation
    _controller.forward();

    // Navigate to login page after animation completes
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
    const double carWidth = 50.0;
    const Color brandGreen = Color(0xFF43A047);

    return Scaffold(
      backgroundColor: const Color(0xFF151717),
      body: Stack(
        children: [
          // Animated Background Particles
          Positioned.fill(
            child: CustomPaint(
              painter: ParticlePainter(_controller.value),
            ),
          ),

          // Wind lines
          Positioned.fill(
            child: CustomPaint(
              painter: WindLinesPainter(_controller.value),
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),

              // Logo Section
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
                      child:
                          const Icon(Icons.eco, size: 60, color: Colors.white),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),

              // Text Section with fade-in animation
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

              // Animated Road Section
              SizedBox(
                height: 80,
                width: double.infinity,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        // Dashed Road Line
                        CustomPaint(
                          size: Size(screenWidth, 2),
                          painter: DashedLinePainter(),
                        ),

                        // Speed lines
                        Positioned(
                          left: screenWidth * _animation.value,
                          child: CustomPaint(
                            size: const Size(100, 40),
                            painter: SpeedLinesPainter(_controller.value),
                          ),
                        ),

                        // Green Progress Line
                        Container(
                          width: screenWidth * _animation.value,
                          height: 4,
                          decoration: BoxDecoration(
                            color: brandGreen,
                            boxShadow: [
                              BoxShadow(
                                color: brandGreen,
                                blurRadius: 10 * _controller.value,
                                spreadRadius: 1,
                              )
                            ],
                          ),
                        ),

                        // Moving Electric Car
                        Positioned(
                          left: (screenWidth * _animation.value) - carWidth,
                          child: SizedBox(
                            width: carWidth,
                            height: 40,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Glow effect
                                AnimatedBuilder(
                                  animation: _controller,
                                  builder: (context, child) {
                                    return Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        // ignore: deprecated_member_use
                                        color: brandGreen.withOpacity(
                                            0.4 * _controller.value),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            // ignore: deprecated_member_use
                                            color: brandGreen.withOpacity(
                                                0.6 * _controller.value),
                                            blurRadius: 20 * _controller.value,
                                            spreadRadius: 5 * _controller.value,
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),

                                // Car Icon with rotating wheels
                                Stack(
                                  children: [
                                    const Icon(
                                      Icons.directions_car_filled,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                    // Front Wheel
                                    Positioned(
                                      left: 8,
                                      bottom: 2,
                                      child: AnimatedBuilder(
                                        animation: _controller,
                                        builder: (context, child) {
                                          return Transform.rotate(
                                            angle: _controller.value * 20,
                                            child: Container(
                                              width: 12,
                                              height: 12,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[800],
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: brandGreen,
                                                    width: 1),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    // Rear Wheel
                                    Positioned(
                                      right: 8,
                                      bottom: 2,
                                      child: AnimatedBuilder(
                                        animation: _controller,
                                        builder: (context, child) {
                                          return Transform.rotate(
                                            angle: _controller.value * 20,
                                            child: Container(
                                              width: 12,
                                              height: 12,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[800],
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: brandGreen,
                                                    width: 1),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),

                                // Electric Bolt Icon
                                const Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Icon(Icons.bolt,
                                      color: Colors.yellow, size: 16),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Percentage Text with Count-up Effect
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) => Text(
                  "${(_animation.value * 100).toInt()}%",
                  style: TextStyle(
                    // ignore: deprecated_member_use
                    color: Colors.white
                        // ignore: deprecated_member_use
                        .withOpacity(0.7 + (_animation.value * 0.3)),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),

              const Spacer(flex: 2),

              // "Ride with Greener" Section with fade-in
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _controller.value > 0.5
                        ? (_controller.value - 0.5) * 2
                        : 0,
                    child: Column(
                      children: [
                        const Text(
                          "Ride with Greener",
                          style: TextStyle(
                            fontSize: 20,
                            color: brandGreen,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Journey to a sustainable future",
                          style: TextStyle(
                            // ignore: deprecated_member_use
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  );
                },
              ),

              // Footer Section
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
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 12,
                    ),
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

// Custom painter for dashed road line
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

// Custom painter for animated background particles
class ParticlePainter extends CustomPainter {
  final double animationValue;

  ParticlePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      // ignore: deprecated_member_use
      ..color = const Color(0xFF43A047).withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Draw floating particles
    for (int i = 0; i < 20; i++) {
      final x = (size.width * 0.1) + (i * 80);
      final y = 100 + (60 * i * animationValue) % size.height;

      canvas.drawCircle(
        Offset(x, y),
        2 + (i % 4).toDouble(),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}

// Custom painter for speed lines
class SpeedLinesPainter extends CustomPainter {
  final double animationValue;

  SpeedLinesPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      // ignore: deprecated_member_use
      ..color = const Color(0xFF43A047).withOpacity(0.1)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw speed lines
    for (int i = 0; i < 15; i++) {
      final x = size.width - (i * 20 * animationValue);
      final y = size.height * 0.6;
      final length = 20 + (i % 5).toDouble();

      canvas.drawLine(
        Offset(x, y),
        Offset(x - length, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant SpeedLinesPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}

// Custom painter for wind lines behind car
class WindLinesPainter extends CustomPainter {
  final double animationValue;

  WindLinesPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      // ignore: deprecated_member_use
      ..color = const Color(0xFF43A047).withOpacity(0.5)
      ..strokeWidth = 1;

    // Draw wind lines
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
