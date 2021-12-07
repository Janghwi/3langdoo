import 'package:flutter/material.dart';

class BarMenu extends StatelessWidget {
  const BarMenu({Key? key}) : super(key: key);
  static const String path = '/BarMenu';

  @override
  Widget build(BuildContext context) => TestView();
}

class TestView extends StatelessWidget {
  List<Widget> menus = [
    const Icon(Icons.height, color: Colors.white),
    const Icon(Icons.admin_panel_settings, color: Colors.white),
    const Icon(Icons.person, color: Colors.white),
    const Icon(Icons.person, color: Colors.white),
  ];
  List<Widget> menus1 = [
    TextButton(
      onPressed: () {
        // Respond to button press
      },
      child: const Text("테스트1", style: TextStyle(color: Colors.white)),
    ),
    TextButton(
      onPressed: () {
        // Respond to button press
      },
      child: const Text("테스트2", style: TextStyle(color: Colors.white)),
    ),
    TextButton(
      onPressed: () {
        // Respond to button press
      },
      child: const Text("테스트3", style: TextStyle(color: Colors.white)),
    ),
    TextButton(
      onPressed: () {
        // Respond to button press
      },
      child: const Text("테스트4", style: TextStyle(color: Colors.white)),
    ),
  ];

  Widget close = const Icon(Icons.close, color: Colors.white);

  TestView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
          // appBar: AppBar(title: Text("JamesUI")),
          body: Stack(
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Column(children: [
                  ...List<int>.generate(20, (index) => index)
                      .map<Widget>((int i) => Builder(builder: (context) {
                            return SingleChildScrollView(
                                child: const Text("Content"));
                          }))
                      .toList(),
                ]),
              )),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: JamesBar(
                color: Colors.red,
                axis: Axis.vertical,
                items: menus1,
                // closeIcon: close,
                cb: (int i) => print(i)),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: JamesBar(
                color: Colors.blue,
                axis: Axis.vertical,
                items: menus1,
                // closeIcon: close,
                cb: (int i) => print(i)),
          ),
          Positioned(
            right: 0,
            left: 0,
            bottom: 20.0,
            child: JamesBar(
                color: Colors.orange,
                items: menus1,
                // closeIcon: close,
                cb: (int i) => print(i)),
          ),
          Positioned(
            right: 0,
            left: 0,
            top: 0,
            child: JamesBar(
                color: Colors.purple,
                items: menus1,
                // closeIcon: close,
                cb: (int i) => print(i)),
          ),
        ],
      ));
}

class JamesBar extends StatefulWidget {
  final Axis axis;
  final List<Widget> items;
  final void Function(int) cb;
  final Color color;
  // final Widget closeIcon;
  const JamesBar(
      {Key? key,
      this.axis = Axis.horizontal,
      required this.items,
      required this.cb,
      required this.color})
      : super(key: key);

  @override
  State<JamesBar> createState() => _JamesBarState();
}

class _JamesBarState extends State<JamesBar>
    with SingleTickerProviderStateMixin {
  AnimationController? _act;
  Animation<double>? _anim;

  bool check = false;

  @override
  void initState() {
    _act =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300))
          ..addListener(() {
            if (!mounted) return;
            setState(() {});
          });
    super.initState();
  }

  @override
  void dispose() {
    _act?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      widget.axis == Axis.vertical ? _vertical(context) : _horizontal(context);

  Widget _vertical(BuildContext context) {
    _anim = Tween<double>(
            begin: 0,
            end: (-1 * MediaQuery.of(context).size.height) +
                (kToolbarHeight) +
                MediaQuery.of(context).padding.top +
                200.0)
        .animate(_act!);
    return Transform.translate(
      offset: Offset(0, _anim?.value ?? 0),
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        elevation: 4.0,
        color: widget.color,
        margin: const EdgeInsets.symmetric(vertical: 60.0, horizontal: 10.0),
        child: Container(
            width: 70.0,
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            height: MediaQuery.of(context).size.height -
                kToolbarHeight -
                MediaQuery.of(context).padding.top,
            child: Container(
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [..._bar()],
                    ),
                  ),
                  // Container(child: _trigger()),
                ],
              ),
            )),
      ),
    );
  }

  // Widget _trigger() => IconButton(
  //       icon: widget.closeIcon as Icon,
  //       onPressed: () {
  //         if (!check) {
  //           _act?.forward();
  //         } else {
  //           _act?.reverse();
  //         }
  //         check = !check;
  //       },
  //     );

  Widget _horizontal(BuildContext context) {
    _anim = Tween<double>(
            begin: 0, end: -1 * MediaQuery.of(context).size.width + 140.0)
        .animate(_act!);
    return Transform.translate(
      offset: Offset(_anim?.value ?? 0, 0),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        elevation: 4.0,
        color: widget.color,
        child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            height: 70.0,
            child: Container(
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [..._bar()],
                    ),
                  ),
                  // Container(child: _trigger()),
                ],
              ),
            )),
      ),
    );
  }

  List<Widget> _bar() => widget.items
      .map<Widget>((Widget item) => InkWell(
            onTap: () => widget.cb(widget.items.indexOf(item)),
            child: item,
          ))
      .toList();
}
