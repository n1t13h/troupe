import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:troupe/Screens/HomePage.dart';
import 'package:troupe/Screens/SplashScreen.dart';
import 'package:troupe/Screens/WelcomeScreen.dart';
import 'package:troupe/Screens/pages/CategoryLinks.dart';
import 'package:troupe/Values/AppColors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:troupe/Values/Routes.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uni_links/uni_links.dart';
import 'package:velocity_x/velocity_x.dart';

enum UniLinksType { string, uri }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _latestLink = 'Unknown';
  Uri _latestUri;

  StreamSubscription _sub;

  UniLinksType _type = UniLinksType.string;

  List<Widget> intersperse(Iterable<Widget> list, Widget item) {
    List<Widget> initialValue = [];
    return list.fold(initialValue, (all, el) {
      if (all.length != 0) all.add(item);
      all.add(el);
      return all;
    });
  }

  List<String> getCmds() {
    String cmd;
    String cmdSuffix = '';

    if (Platform.isIOS) {
      cmd = '/usr/bin/xcrun simctl openurl booted';
    } else if (Platform.isAndroid) {
      cmd = '\$ANDROID_HOME/platform-tools/adb shell \'am start'
          ' -a android.intent.action.VIEW'
          ' -c android.intent.category.BROWSABLE -d';
      cmdSuffix = "'";
    } else {
      return null;
    }

    // https://orchid-forgery.glitch.me/mobile/redirect/
    return [
      '$cmd "unilinks://host/path/subpath"$cmdSuffix',
      '$cmd "unilinks://example.com/path/portion/?uid=123&token=abc"$cmdSuffix',
      '$cmd "unilinks://example.com/?arr%5b%5d=123&arr%5b%5d=abc'
          '&addr=1%20Nowhere%20Rd&addr=Rand%20City%F0%9F%98%82"$cmdSuffix',
    ];
  }

  final TextStyle _cmdStyle = const TextStyle(
      fontFamily: 'Courier', fontSize: 12.0, fontWeight: FontWeight.w700);
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  initState() {
    super.initState();
    initPlatformState();
  }

  @override
  dispose() {
    if (_sub != null) _sub.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    if (_type == UniLinksType.string) {
      await initPlatformStateForStringUniLinks();
    } else {
      await initPlatformStateForUriUniLinks();
    }
  }

  initPlatformStateForStringUniLinks() async {
    // Attach a listener to the links stream
    _sub = getLinksStream().listen((String link) {
      if (!mounted) return;
      setState(() {
        _latestLink = link ?? 'Unknown';
        _latestUri = null;
        try {
          if (link != null) _latestUri = Uri.parse(link);
        } on FormatException {}
      });
    }, onError: (err) {
      if (!mounted) return;
      setState(() {
        _latestLink = 'Failed to get latest link: $err.';
        _latestUri = null;
      });
    });

    // Attach a second listener to the stream
    getLinksStream().listen((String link) {
      print('got link: $link');
    }, onError: (err) {
      print('got err: $err');
    });

    // Get the latest link
    String initialLink;
    Uri initialUri;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      initialLink = await getInitialLink();
      print('initial link: $initialLink');
      if (initialLink != null) initialUri = Uri.parse(initialLink);
    } on PlatformException {
      initialLink = 'Failed to get initial link.';
      initialUri = null;
    } on FormatException {
      initialLink = 'Failed to parse the initial link as Uri.';
      initialUri = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _latestLink = initialLink;
      _latestUri = initialUri;
    });
  }

  /// An implementation using the [Uri] convenience helpers
  initPlatformStateForUriUniLinks() async {
    // Attach a listener to the Uri links stream
    _sub = getUriLinksStream().listen((Uri uri) {
      if (!mounted) return;
      setState(() {
        _latestUri = uri;
        _latestLink = uri?.toString() ?? 'Unknown';
      });
    }, onError: (err) {
      if (!mounted) return;
      setState(() {
        _latestUri = null;
        _latestLink = 'Failed to get latest link: $err.';
      });
    });

    // Attach a second listener to the stream
    getUriLinksStream().listen((Uri uri) {
      print('got uri: ${uri?.path} ${uri?.queryParametersAll}');
    }, onError: (err) {
      print('got err: $err');
    });

    // Get the latest Uri
    Uri initialUri;
    String initialLink;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      initialUri = await getInitialUri();
      print('initial uri: ${initialUri?.path}'
          ' ${initialUri?.queryParametersAll}');
      initialLink = initialUri?.toString();
      print(initialLink);
    } on PlatformException {
      initialUri = null;
      initialLink = 'Failed to get initial uri.';
    } on FormatException {
      initialUri = null;
      initialLink = 'Bad parse the initial link as Uri.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _latestUri = initialUri;
      _latestLink = initialLink;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(360, 690),
        allowFontScaling: false,
        builder: () => MaterialApp.router(
              title: "Trouppe",
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primaryColor: orange,
                highlightColor: peach,
              ),
              routeInformationParser: VxInformationParser(),
              routerDelegate: VxNavigator(routes: {
                "/": (_, __) => MaterialPage(child: SplashScreen()),
                "/home": (_, __) => MaterialPage(child: HomePage()),
                "/welcome": (_, __) => MaterialPage(child: WelcomeScreen()),
                "/collection": (uri, params) {
                  var id = uri.queryParameters['id'];
                  var uid = uri.queryParameters['uid'];
                  return MaterialPage(child: CategoryLink(id, uid));
                },
              }),
            ));
  }
}
