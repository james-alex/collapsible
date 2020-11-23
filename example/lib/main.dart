import 'package:flutter/material.dart';
import 'package:collapsible/collapsible.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Collapsible Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Collapsible Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _collapsed = false;

  void _toggleCollapsible() {
    _collapsed = !_collapsed;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Collapsible(
          child: MyWidget(),
          collapsed: _collapsed,
          axis: CollapsibleAxis.both,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleCollapsible,
        child: Icon(_collapsed ? Icons.close_fullscreen : Icons.open_in_full),
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.shortestSide * 0.6;
    final theme = Theme.of(context);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: theme.primaryColor,
      ),
      child: Center(
        child: Icon(
          Icons.adjust,
          size: size * 0.5,
          color: theme.accentIconTheme.color,
        ),
      ),
    );
  }
}
