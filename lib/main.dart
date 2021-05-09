import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  Artboard _truckArtboard;
  RiveAnimationController _controller;
  bool get isPlaying => _controller?.isActive ?? false;

  @override
  void initState() {
    super.initState();
    rootBundle.load('assets/animations/loadingstock.riv').then((data) async {
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;
      artboard.addController(_controller = SimpleAnimation('idle'));
        setState(() => _truckArtboard = artboard);
    });
  }
  
  void _togglePlay() {
    setState(() {
      _controller.isActive = !_controller.isActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: _truckArtboard == null ? CircularProgressIndicator() : Rive(artboard: _truckArtboard)
      ),floatingActionButton: FloatingActionButton(
        onPressed: () => _togglePlay(),
        child: Icon(isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
      ),
    );
  }
}
