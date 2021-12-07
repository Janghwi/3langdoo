import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

import 'package:todaylang/page/translation/langtranslate.dart';
import 'package:todaylang/widget/homepage.dart';

import 'controllers/phrase_loader.dart';
import 'widget/google_signin_prov.dart';
import 'widget/logged_in_widget.dart';
import 'widget/sign_up_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// global RouteObserver

// this is the name given to the background fetch
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

/// Initialize the [FlutterLocalNotificationsPlugin] package.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // Set the background messaging handler early on, as a named top-level function
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // channel = const AndroidNotificationChannel(
  //     'high_importance_channel', // id
  //     'High Importance Notifications', // title
  //     // 'This channel is used for important notifications.', // description
  //     importance: Importance.high,
  //     playSound: true);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  //----------------------------------------------------get put------------------
  // Get.put(PhrasesLoader());

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  static const String title = '플러터테스트';

  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // FirebaseMessaging.instance
    //     .getInitialMessage()
    //     .then((RemoteMessage? message) {
    //   // if (message != null) {
    //   //   Navigator.pushNamed(context, '/message',
    //   //       arguments: MessageArguments(message, true));
    //   // }
    // });

    ThemeMode themeMode = ThemeMode.light;
    // ThemeMode themeMode = ThemeMode.light;

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: "todaylang",
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'launch_background',
                playSound: true,
                color: Colors.blue,
              ),
            ));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title!),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body!)],
                  ),
                ),
              );
            });
      }
      // Navigator.pushNamed(context, '/message',
      //     arguments: MessageArguments(message, true));
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(Get.deviceLocale);
    return ChangeNotifierProvider(
      create: (context) {
        return GoogleSignInProvider();
      },
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        translations: LangTranslations(),
        // locale: Locale('en', 'US'),
        locale: Get.deviceLocale,
        fallbackLocale: Locale('en', 'US'),
        title: MyApp.title,
        theme: ThemeData(
          fontFamily: GoogleFonts.notoSerif().fontFamily,
        ),
        // Use the above dark or light theme based on active themeMode.
        home: HomePage(),
        // home: LoginPage(),
      ),
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      //   elevatedButtonTheme: ElevatedButtonThemeData(
      //     style: ElevatedButton.styleFrom(
      //       elevation: 8,
      //       primary: Colors.white,
      //       shape: StadiumBorder(),
      //       minimumSize: Size.square(30),
      //     ),
      //   ),
      // ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              return LoggedInWidget();
            } else if (snapshot.hasError) {
              return Center(child: Text('Something Went Wrong!'));
            } else {
              // return HomePage();
              return SignUpWidget();
            }
          },
        ),
        // bottomNavigationBar: BottomNavigationBar(
        //   currentIndex: 0,
        //   onTap: (index) {
        //     print(index);
        //   },
        //   backgroundColor: Colors.white,
        //   items: const <BottomNavigationBarItem>[
        //     BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        //     BottomNavigationBarItem(icon: Icon(Icons.mail), label: "Messages"),
        //     BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        //   ],
        // ),
      );
}
//
//print("유저네임은 : ${      }");
/*
기본조건문
bool isRun =true;
if (isRun){
  참입니다.
} else {
  거짓입니다.
}

삼항연산자(조건 ? 데이터1 :데이터 2)
String s = isRun ? '참' : '거짓'

엘비스(Elvis)연산자: null값확인 
String data = name ?? '홍길동';      >>>name이 null이면  홍길동을 넣고 null이 아니면 nme값을 넣어라
accout = input ?? 0;       >>> 0를 넣어아라

메소드 
- 다트는 리턴타입 정이 안해도 됨 
- 메소드가 1급 객체이기때문에 변수에 저장할 수 없음 
Function hihi = () {};
var hihihi = () {};   >>> 한번 정해지면 type전환이 안됨
dynamic hihihi = () {};  >>>type전환됨
- return이 한줄이면 =>을 사용하여 표현할 수 있다 ... 리턴문을 생략


반복문 
void main() {
  var list = [1,2,3,4];
  for (var i =0; i < list.lenght; i++ ){
    print(list[i]);
  }

for (var e in list){
    print(e);                    >>>좋음
  }

list.forEach((e)=> print(e)); >>>좋지않음

list.forEach((e){
  print(e);
});

}
배열의 복사 에서 기본 반복은 for in문이 좋고, 빈복후 리턴은 map이 좋고, 필터링을 할때는 spread가 좋다.
얉은복사 sms 주소복사이다.
var newList = list;

깊은복사 
var mapList = list.map((e)=>e +1);  >>>리스트를 각각 읽어서 값을 1로 더해서 return한다.장점은 연산하여 리턴한다.
print(mapList)

var spreadList = [...list]; // [1,2,3,4]와 똑같다.깊은 복사로 흩뿌린다는 개념.단점은 연산을 못한다.
                   장점은 [10, ...list, 100] = [10,1,2,3,4,100]이 된다.

배열에서 어떤 값을 필터링한뒤 깊은 복사 하는 법 /깊은 복사란 새로운 저장소를 만든다
var filterList = list.where((e)=> e == 2); 값을 리스트네에서 읽다가 2의 값을 만나면 true가 리턴된다
그리고 true의 값만 filterlist에 넣어라.
          where는 bool type의 
var filterList = list.where((e)=> e != 2); [1,2,3,4]가 있으면 2가 아닌 숫자만 리턴한다.


final은 변경 불가(실행중에 값이 결정)  const는 컴파일시에 값이 결정 

클래스(오브젝트)를 사용하는 이유는 여러가지 데이터를 담을수 있다.... 변수는 안된다. 
클래스는 메모리에 뜨지 않는다.찾을수 잇는 방법이 없다. 메모리에 올려야 사용할 수 있다. 

class Dog {
  var name = "초롱";  프로퍼티(속성)
  var age = 2;
}
main(){
  Dog d =new Dog();   이때 메모리에 올린다.
}


*/