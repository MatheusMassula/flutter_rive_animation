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
  RiveAnimationController _idleController;
  RiveAnimationController _curvesController;
  bool get isIdlePlaying => _idleController?.isActive ?? false;
  bool get isCurvesPlaying => _curvesController?.isActive ?? false;

  @override
  void initState() {
    super.initState();
    rootBundle.load('assets/animations/loadingstock.riv').then((data) async {
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;
      artboard.addController(_curvesController = SimpleAnimation('curves'));
      artboard.addController(_idleController = SimpleAnimation('idle'));
      setState(() => _truckArtboard = artboard);
    });
  }
  
  void _toggleIdlePlay() {
    setState(() {
      _idleController.isActive = !_idleController.isActive;
    });
  }

  void _toggleCurvePlay() {
    setState(() {
      _curvesController.isActive = !_curvesController.isActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: _truckArtboard == null ? CircularProgressIndicator() :
        Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width,
              child: Rive(artboard: _truckArtboard)
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () => _toggleCurvePlay(),
                  icon: Icon(isCurvesPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
                ),
                IconButton(
                  onPressed: () => _toggleIdlePlay(),
                  icon: Icon(isIdlePlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
                ),
              ],
            )
          ],
        )
      ),
    );
  }
}
