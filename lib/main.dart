import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FadingTextAnimation(),
    );
  }
}

class FadingTextAnimation extends StatefulWidget {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Fading Text Animation'),
        actions: [
          PopupMenuButton<Color>(
            onSelected: changeColor,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: Colors.red,
                  child: Text('Red'),
                ),
                PopupMenuItem(
                  value: Colors.blue,
                  child: Text('Blue'),
                ),
                PopupMenuItem(
                  value: Colors.green,
                  child: Text('Green'),
                ),
                PopupMenuItem(
                  value: Colors.orange,
                  child: Text('Orange'),
                ),
                PopupMenuItem(
                  value: Colors.purple,
                  child: Text('Purple'),
                ),
              ];
            },
            icon: Icon(Icons.color_lens),
          ),
        ],
      ),
      body: Center(
        child: AnimatedOpacity(
          opacity: _isVisible ? 1.0 : 0.0,
          duration: Duration(seconds: 1),
          child: Text(
            'Hello, Flutter!',
            style: TextStyle(fontSize: 24, color: _textColor),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleVisibility,
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}