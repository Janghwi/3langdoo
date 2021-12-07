// ignore_for_file: unnecessary_this

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(Todo());

class Todo extends StatelessWidget {
  const Todo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // CupertinoApp
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TodoController>(
            create: (BuildContext context) => TodoController())
      ],
      child: MaterialApp(
        // home: , // Navigator 1.0
        // -> 2.0 : WEB
        /// rest api
        /// /
        onGenerateRoute: (RouteSettings route) {
          // CupertinoPageRoute
          return MaterialPageRoute(
              settings: RouteSettings(name: MainPage.path),
              builder: (BuildContext context) => MainPage());
        },
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);
  static const String path = "/";

  @override
  Widget build(BuildContext context) {
    TodoController todoController = Provider.of<TodoController>(context);
    return kIsWeb
        ? MainWebPage(todoController)
        : MainMobilePage(todoController);
  }
}

class MainWebPage extends StatelessWidget {
  final TodoController todoController;
  const MainWebPage(this.todoController);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class Model {
  String txt;
  bool check;
  Model({required this.txt, this.check = false});

  void change(String newText) {
    txt = newText;
  }

  void changeCheck() {
    check = !check;
  }
}

class TodoController with ChangeNotifier {
  List<Model>? todos;

  ///  = [];
  TodoController() {
    todos = [];
  }

  void add(Model model) {
    this.todos!.add(model);
    this.notifyListeners();
  }

  void removeAt(int index) {
    this.todos!.removeAt(index);
    this.notifyListeners();
  }

  void change(int index) {
    this.todos![index].changeCheck();
    this.notifyListeners();
  }

  void update(int index, String updateData) {
    this.todos![index].change(updateData);
    this.notifyListeners();
  }
}

class MainMobilePage extends StatefulWidget {
  final TodoController todoController;
  const MainMobilePage(this.todoController);

  @override
  State<MainMobilePage> createState() => _MainMobilePageState();
}

class _MainMobilePageState extends State<MainMobilePage> {
  List<Model>? todos; // null // [] // [todo1...]
  final TextEditingController controller = TextEditingController();

  /// TodoController? todoController;
  @override
  void initState() {
    this.controller.addListener(() {
      if (!this.mounted) return; // -> Anim, HTTP
      this.setState(() {});
    });

    this.todos = [];
    if (!this.mounted) return;
    this.setState(() {});
    super.initState();

    // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
    //   /// Build 함수 호출 이후 '한번만' 실행
    //   todoController = Provider.of<TodoController>(context);
    //   if(!this.mounted) return;
    //   this.setState(() {});
    // });
  }

  @override
  void dispose() {
    this.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// if(todoController == null){
    ///   todoController = Provider.of<TodoController>(context);
    /// }
    return Scaffold(
      floatingActionButton: this.controller.text.isEmpty
          ? null
          : FloatingActionButton(
              child: Icon(Icons.check),
              onPressed: () {
                // if(!this.controller.hasListeners) return; // -> Controller
                // print( this.controller.text ); // "" // null
                /// if(todoController == null) return;
                if (widget.todoController.todos == null) return;
                // this.setState(() {
                //   this.todos!.add( Model(txt: this.controller.text) );
                // });
                widget.todoController.add(Model(txt: this.controller.text));
                this.controller.clear();
              },
            ),
      appBar: AppBar(
        title: Text("Todo"),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(
                child: TextField(
              controller: this.controller,
            )),
            Expanded(
                child:

                    /// todoController == null
                    ///   ? Container()
                    ///   :
                    widget.todoController.todos == null
                        ? Center(
                            child: Text("Load..."),
                          )
                        : widget.todoController.todos!.isEmpty
                            ? Center(
                                child: Text("Empty !"),
                              )
                            : ListView.builder(
                                itemCount: widget.todoController.todos!.length,
                                itemBuilder: (BuildContext context,
                                        int index) =>
                                    ListTile(
                                      title: Text(
                                        widget.todoController.todos![index].txt,
                                        style: TextStyle(
                                          color: widget.todoController
                                                  .todos![index].check
                                              ? Colors.grey
                                              : Colors.black,
                                        ),
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () async {
                                          // await Navigator.of(context).push<bool>() ?? false;
                                          /// 삭제
                                          bool check = await showDialog<bool>(
                                                  context: context,
                                                  builder: (BuildContext
                                                          context) =>
                                                      AlertDialog(
                                                        title: Text("삭제?"),
                                                        actions: [
                                                          TextButton(
                                                            child: Text("제거"),
                                                            onPressed: () =>
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(true),
                                                          ),
                                                          TextButton(
                                                            child: Text("닫기"),
                                                            onPressed: () =>
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(false),
                                                          )
                                                        ],
                                                      )) ??
                                              false;
                                          if (!check) return;
                                          // setState(() => this.todos!.removeAt(index));
                                          widget.todoController.removeAt(index);
                                        },
                                      ),
                                      onTap: () {
                                        /// 활성/비활성
                                        // this.todos![index].check = !this.todos![index].check;
                                        // setState(() {
                                        //   this.todos![index].changeCheck();
                                        // });
                                        widget.todoController.change(index);
                                      },
                                      onLongPress: () async {
                                        /// Update
                                        /// 팝업 ++
                                        String updateData = await Navigator.of(
                                                    context)
                                                .push<String>(MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        UpdatePage(
                                                            data: widget
                                                                .todoController
                                                                .todos![index]
                                                                .txt))) ??
                                            "";
                                        if (updateData.isEmpty) return;
                                        // setState(() {
                                        //   // this.todos![index].txt = updateData;
                                        //   this.todos![index].change(updateData);
                                        // });
                                        widget.todoController
                                            .update(index, updateData);
                                      },
                                    )))
          ],
        ),
      ),
    );
  }
}

class UpdatePage extends StatefulWidget {
  final String data;
  const UpdatePage({Key? key, required this.data}) : super(key: key);

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  TextEditingController? controller;

  @override
  void initState() {
    controller = TextEditingController(text: widget.data);
    super.initState();
  }

  @override
  void dispose() {
    this.controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            TextField(
              controller: this.controller,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    child: Text("변경"),
                    onPressed: () {
                      if (this.widget.data == this.controller!.text) {
                        return Navigator.of(context).pop();
                      }
                      return Navigator.of(context).pop(this.controller!.text);
                    },
                  ),
                  TextButton(
                    child: Text("취소"),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
