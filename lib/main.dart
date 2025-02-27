import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: HomePageSwiper(
        isDarkMode: _isDarkMode,
        toggleTheme: toggleTheme,
      ),
    );
  }
}

class HomePageSwiper extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  HomePageSwiper({required this.isDarkMode, required this.toggleTheme});

  @override
  _HomePageSwiperState createState() => _HomePageSwiperState();
}

class _HomePageSwiperState extends State<HomePageSwiper> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentPage == 0
            ? 'Fading Text Animation'
            : 'Alternative Fading Animation'),
        actions: [
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
            ),
            onPressed: widget.toggleTheme,
            tooltip: widget.isDarkMode
                ? 'Switch to Light Mode'
                : 'Switch to Dark Mode',
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: [
          // First animation page
          FadingTextAnimation(
            isDarkMode: widget.isDarkMode,
            duration: const Duration(seconds: 1),
            title: 'Hello, Flutter!',
            subtitle: 'Swipe left for a different animation',
          ),
          // Second animation page
          FadingTextAnimation(
            isDarkMode: widget.isDarkMode,
            duration: const Duration(milliseconds: 300),
            title: 'Quick Fade Animation',
            subtitle: 'This one fades faster! Swipe right to go back',
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.animation),
            label: 'Animation 1',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.speed),
            label: 'Animation 2',
          ),
        ],
      ),
    );
  }
}

class FadingTextAnimation extends StatefulWidget {
  final bool isDarkMode;
  final Duration duration;
  final String title;
  final String subtitle;

  FadingTextAnimation({
    required this.isDarkMode,
    required this.duration,
    required this.title,
    required this.subtitle,
  });

  @override
  _FadingTextAnimationState createState() => _FadingTextAnimationState();
}

class _FadingTextAnimationState extends State<FadingTextAnimation>
    with TickerProviderStateMixin {
  bool _isVisible = true;
  Color _textColor = Colors.black;
  List<ConfettiParticle> _confetti = [];
  AnimationController? _confettiController;
  bool _showConfetti = false;

  @override
  void initState() {
    super.initState();
    _confettiController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _confettiController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showConfetti = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _confettiController?.dispose();
    super.dispose();
  }

  void toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
      // Trigger confetti
      _showConfetti = true;
      _generateConfetti();
      _confettiController!.forward(from: 0.0);
    });
  }

  void _generateConfetti() {
    _confetti = [];
    final random = Random();
    for (int i = 0; i < 50; i++) {
      _confetti.add(
        ConfettiParticle(
          x: random.nextDouble() * MediaQuery.of(context).size.width,
          y: -20.0 - random.nextDouble() * 100,
          color: Color.fromARGB(
            255,
            random.nextInt(255),
            random.nextInt(255),
            random.nextInt(255),
          ),
          size: 5 + random.nextDouble() * 10,
          speed: 30 + random.nextDouble() * 50,
          angle: (random.nextDouble() * 0.2) - 0.1,
        ),
      );
    }
  }

  void changeColor(Color color) {
    setState(() {
      _textColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Make sure text color is visible in dark mode
    if (widget.isDarkMode && _textColor == Colors.black) {
      _textColor = Colors.white;
    }

    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text above the image
              AnimatedOpacity(
                opacity: _isVisible ? 1.0 : 0.0,
                duration: widget.duration,
                child: Text(
                  widget.title,
                  style: TextStyle(fontSize: 24, color: _textColor),
                ),
              ),
              SizedBox(height: 20),
              Text(
                widget.isDarkMode ? 'Dark Mode Enabled' : 'Light Mode Enabled',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                widget.subtitle,
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 20),
              // Image in the middle
              AnimatedOpacity(
                opacity: _isVisible ? 1.0 : 0.0,
                duration: widget.duration,
                child: Image.asset(
                  'assets/images/pexels-pixabay-206959.jpg', // Replace with your image path
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
              // Buttons for color and visibility
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.color_lens),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Choose Text Color'),
                            content: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  colorButton(Colors.red, 'Red'),
                                  colorButton(Colors.blue, 'Blue'),
                                  colorButton(Colors.green, 'Green'),
                                  colorButton(Colors.orange, 'Orange'),
                                  colorButton(Colors.purple, 'Purple'),
                                  colorButton(
                                      widget.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      'Default'),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    tooltip: 'Change Text Color',
                  ),
                  SizedBox(width: 20),
                  FloatingActionButton(
                    onPressed: toggleVisibility,
                    child: Icon(Icons.play_arrow),
                    tooltip: 'Toggle Visibility',
                  ),
                ],
              ),
            ],
          ),
        ),
        if (_showConfetti)
          AnimatedBuilder(
            animation: _confettiController!,
            builder: (context, child) {
              for (var confetti in _confetti) {
                confetti.y += confetti.speed * _confettiController!.value;
                confetti.x += confetti.angle *
                    confetti.speed *
                    _confettiController!.value *
                    10;
              }

              return CustomPaint(
                size: Size(
                  MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height,
                ),
                painter: ConfettiPainter(_confetti),
              );
            },
          ),
      ],
    );
  }

  Widget colorButton(Color color, String name) {
    return TextButton(
      onPressed: () {
        changeColor(color);
        Navigator.of(context).pop();
      },
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            color: color,
            margin: EdgeInsets.only(right: 8),
          ),
          Text(name),
        ],
      ),
    );
  }
}

class ConfettiParticle {
  double x;
  double y;
  Color color;
  double size;
  double speed;
  double angle; // For sideways movement

  ConfettiParticle({
    required this.x,
    required this.y,
    required this.color,
    required this.size,
    required this.speed,
    required this.angle,
  });
}

class ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> confetti;

  ConfettiPainter(this.confetti);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in confetti) {
      if (particle.y < size.height) {
        final paint = Paint()..color = particle.color;

        // Reduce the downward speed by applying a smaller multiplier
        double fallSpeed = particle.speed * 0.2; // Slows down falling speed
        double sideDrift =
            particle.angle * particle.speed * 0.5; // Less horizontal drift

        particle.y += fallSpeed;
        particle.x += sideDrift;

        canvas.drawRect(
          Rect.fromLTWH(
            particle.x,
            particle.y,
            particle.size,
            particle.size * 1.5,
          ),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}