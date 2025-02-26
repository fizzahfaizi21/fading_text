import 'package:flutter/material.dart';

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

class _FadingTextAnimationState extends State<FadingTextAnimation> {
  bool _isVisible = true;
  Color _textColor = Colors.black;

  void toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
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

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
