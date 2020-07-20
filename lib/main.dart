import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

//https://www.youtube.com/watch?v=jR0ETJQ8s7Y&list=PLMrtoLeyKwKwokybjCEZeKiiQr_Lh9xYV&index=56
//use isolate class which is low level api watch above video if you want to pause resume and stop isolate. if not use below code of compute
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    animation = BorderRadiusTween(
            begin: BorderRadius.circular(100.0),
            end: BorderRadius.circular(0.0))
        .animate(controller);
    controller.forward();
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ISOLATES IN PROGRESS"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CenterContainer(animation: animation),
            OutlineButton(
              child: Text("Main Isolate"),
              onPressed: () async {
                int result = await Future.delayed(
                  Duration(milliseconds: 100),
                  () => fib(40),
                );
                print("MainIsolate: $result");
              },
            ),
            OutlineButton(
              child: Text("Second Isolate"),
              onPressed: () async {
                int result = await compute(
                    fib, 40); // instead of 40 we can pass any model
                print("SecondryIsolate: $result"); //method + value
              },
            )
          ],
        ),
      ),
    );
  }
}

//inside class every method that is part of secondary isolate need to declare static or declare the method outside the class to avoid errors.
//inside class fib need to become static because of compute  outside class fib is simple method.
int fib(int n) {
  int n1 = n - 1;
  int n2 = n - 2;
  if (n == 1)
    return 0;
  else if (n == 0)
    return 1;
  else {
    return (fib(n1) + fib(n2));
  }
}

class CenterContainer extends StatelessWidget {
  const CenterContainer({
    @required this.animation,
  });

  final Animation animation;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 350.0,
        height: 200.0,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.blue, Colors.redAccent],
            ),
            borderRadius: animation.value),
      ),
    );
  }
}
