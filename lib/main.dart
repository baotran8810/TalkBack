import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var items = List<String>.generate(10000, (i) => "Item $i");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Voice Back"),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return SlideMenu(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  ExcludeSemantics(
                    child: FlutterLogo(),
                  ),
                  Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                        ExcludeSemantics(
                          child: Text(
                            "This is title  " + items[index],
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        ExcludeSemantics(
                          child: Text(
                              "This is content of item 3432432432432432  " +
                                  items[index]),
                        ),
                        Row(
                          children: [
                            ExcludeSemantics(
                              child: Text(
                                "Orgnaization     ",
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                            Semantics(
                              child: Text(
                                DateTime.now().day.toString() +
                                    "/" +
                                    DateTime.now().month.toString() +
                                    "/" +
                                    DateTime.now().year.toString(),
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                          ],
                        ),
                        Semantics(
                          label: "Ornaization",
                        ),
                        Semantics(
                          label: "This is title " + items[index],
                        )
                      ])),
                ],
              ),
            ),
            menuItems: <Widget>[
              new Semantics(
                label: "Delete",
                child: Container(
                  child: new IconButton(
                    icon: new Icon(Icons.delete),
                  ),
                ),
              ),
              new Semantics(
                label: "Info",
                child: Container(
                  child: new IconButton(
                    icon: new Icon(Icons.info),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

Widget slideRightBackground() {
  return Container(
    color: Colors.green,
    child: Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Icon(
            Icons.edit,
            color: Colors.white,
          ),
          Text(
            " Edit",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
      alignment: Alignment.centerLeft,
    ),
  );
}

Widget slideLeftBackground() {
  return Container(
    color: Colors.red,
    child: Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
          Text(
            " Delete",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.right,
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      alignment: Alignment.centerRight,
    ),
  );
}

class SlideMenu extends StatefulWidget {
  final Widget child;
  final List<Widget> menuItems;

  SlideMenu({this.child, this.menuItems});

  @override
  _SlideMenuState createState() => new _SlideMenuState();
}

class _SlideMenuState extends State<SlideMenu>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  initState() {
    super.initState();
    _controller = new AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animation = new Tween(
            begin: const Offset(0.0, 0.0), end: const Offset(-0.2, 0.0))
        .animate(new CurveTween(curve: Curves.decelerate).animate(_controller));

    return new GestureDetector(
      onHorizontalDragUpdate: (data) {
        // we can access context.size here
        setState(() {
          _controller.value -= data.primaryDelta / context.size.width;
        });
      },
      onHorizontalDragEnd: (data) {
        if (data.primaryVelocity > 2500)
          _controller
              .animateTo(.0); //close menu on fast swipe in the right direction
        else if (_controller.value >= .5 ||
            data.primaryVelocity <
                -2500) // fully open if dragged a lot to left or on fast swipe to left
          _controller.animateTo(1.0);
        else // close if none of above
          _controller.animateTo(.0);
      },
      child: new Stack(
        children: <Widget>[
          new SlideTransition(position: animation, child: widget.child),
          new Positioned.fill(
            child: new LayoutBuilder(
              builder: (context, constraint) {
                return new AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return new Stack(
                      children: <Widget>[
                        new Positioned(
                          right: .0,
                          top: .0,
                          bottom: .0,
                          width: constraint.maxWidth * animation.value.dx * -1,
                          child: new Container(
                            color: Colors.black26,
                            child: new Row(
                              children: widget.menuItems.map((child) {
                                return new Expanded(
                                  child: child,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

// Column(
// children: [
// Row(
// children: [
// Padding(
// padding: EdgeInsets.all(8.0),
// child: FlutterLogo(),
// ),
// ExcludeSemantics(
// child: Padding(
// padding: EdgeInsets.all(8.0),
// child: Text(items[index]),
// ),
// ),
// Padding(
// padding: EdgeInsets.all(8.0),
// child: Text(DateTime.now().day.toString() +
// "/" +
// DateTime.now().month.toString() +
// "/" +
// DateTime.now().year.toString()),
// ),
// Semantics(
// label: "This is" + items[index],
// )
// ],)
// ]
// );
