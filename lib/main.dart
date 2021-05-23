import 'package:flutter/material.dart';
import 'package:status_change/status_change.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Demo Status Line'),
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
  var processIndex = 0;
  var processText = ['Order', 'Ship', 'Done'];
  var processColor = [Colors.orange, Colors.green, Colors.red];
  var todoColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    print(processIndex);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Container(
        child: StatusChange.tileBuilder(
          theme: StatusChangeThemeData(
            direction: Axis.vertical,
            connectorTheme: ConnectorThemeData(space: 1.0, thickness: 1.0),
          ),
          builder: StatusChangeTileBuilder.connected(
            itemWidth: (_) =>
                MediaQuery.of(context).size.width / processText.length,
            contentWidgetBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  '2020-05-10',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              );
            },
            nameWidgetBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  processText[index],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: (index <= processIndex) ? Colors.green : Colors.grey,
                  ),
                ),
              );
            },
            indicatorWidgetBuilder: (_, index) {
              if (index <= processIndex) {
                return DotIndicator(
                  size: 35.0,
                  border: Border.all(color: Colors.green, width: 1),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                    ),
                  ),
                );
              } else {
                return OutlinedDotIndicator(
                  size: 30,
                  borderWidth: 1.0,
                  color: todoColor,
                );
              }
            },
            lineWidgetBuilder: (index) {
              if (index > 0) {
                if (index == processIndex) {
                  final prevColor =
                      processColor[(index - 1) <= 0 ? 0 : (index - 1)];
                  final color = processColor[index];
                  var gradientColors;
                  gradientColors = [
                    prevColor,
                    Color.lerp(prevColor, color, 0.5)
                  ];
                  return DecoratedLineConnector(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradientColors,
                      ),
                    ),
                  );
                } else {
                  return SolidLineConnector(
                    color: Colors.black,
                  );
                }
              } else {
                return null;
              }
            },
            itemCount: processText.length,
          ),
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            processIndex++;
            if (processIndex >= processText.length) {
              processIndex = 0;
            }
          });
        },
        tooltip: 'Next',
        child: Icon(Icons.forward),
      ),
    );
  }
}
