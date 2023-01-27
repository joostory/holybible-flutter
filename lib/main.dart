import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:holybible/actions/actions.dart';
import 'package:holybible/components/loading.dart';
import 'package:holybible/middleware/middlewares.dart';
import 'package:holybible/reducers/app_reducer.dart';
import 'package:holybible/reducers/app_state.dart';
import 'package:holybible/screens/bible/biblelist_screen.dart';
import 'package:holybible/screens/bible/chapterlist_screen.dart';
import 'package:holybible/screens/hymn/hymnlist_screen.dart';
import 'package:holybible/screens/bible/verselist_screen.dart';
import 'package:holybible/screens/hymn/hymnscore_screen.dart';
import 'package:redux/redux.dart';
import 'components/navigation_bar.dart';
import 'firebase_options.dart';

void main() async {
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(HolyBibleApp());
}

class HolyBibleApp extends StatelessWidget {

  final Store<AppState> store = Store<AppState>(
      appReducer,
      initialState: AppState.newInstance(),
      middleware: createMiddleware()
  );

  HolyBibleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: _ThemeApp()
    );
  }
}

ThemeData makeThemeData(bool useDarkMode) => ThemeData(
  brightness: useDarkMode? Brightness.dark : Brightness.light,
  appBarTheme: AppBarTheme(
    color: useDarkMode? const Color(0xee404040) : const Color(0xee333333),
  ),
  primaryColor: const Color(0xff333333),
  colorScheme: useDarkMode? const ColorScheme.dark(
    primary: Color(0xff333333),
    secondary: Color(0xfff9dc41)
  ) : const ColorScheme.light(
    primary: Color(0xff333333),
    secondary: Color(0xfff9dc41),
  )
);

var _appNavigationItems = <AppNavigationItem>[
  AppNavigationItem(
    icon: Icons.book,
    title: '성경',
    app: _BibleApp()
  ),
  AppNavigationItem(
    icon: Icons.music_note,
    title: '찬송가',
    app: _HymnApp()
  )
];

class _ThemeApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ThemeAppState();
  }
}

class _ThemeAppState extends State<_ThemeApp> {
  int _navigationIndex = 0;

  @override
  Widget build(BuildContext context) {
    // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    // FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (BuildContext context, _ViewModel vm) {

        Widget home;
        if (vm.initialized) {
          home = Scaffold(
            body: _appNavigationItems[_navigationIndex].app,
            bottomNavigationBar: AppNavigationBar(
              index: _navigationIndex,
              onChange: (index) => setState(() {
                _navigationIndex = index;
              }),
              items: _appNavigationItems
            ),
          );
        } else {
          home = const Loading();
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: makeThemeData(vm.useDarkMode),
          // navigatorObservers: [observer],
          home: home,
        );
      },
      onInit: (store) => store.dispatch(LoadAppInfoAction()),
    );
  }
}



class _BibleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (BuildContext context, _ViewModel vm) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Holybible',
          theme: makeThemeData(vm.useDarkMode),
          initialRoute: BibleListScreen.routeName,
          routes: {
            BibleListScreen.routeName: (context) => const BibleListScreen(),
            ChapterListScreen.routeName: (context) => const ChapterListScreen(),
            VerseListScreen.routeName: (context) => const VerseListScreen(),
          },
        );
      },
    );
  }
}

class _HymnApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (BuildContext context, _ViewModel vm) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Holybible',
          theme: makeThemeData(vm.useDarkMode),
          initialRoute: HymnListScreen.routeName,
          routes: {
            HymnListScreen.routeName: (context) => const HymnListScreen(),
            HymnScoreScreen.routeName: (context) => const HymnScoreScreen(),
          },
        );
      },
    );
  }
}

class _ViewModel {
  final bool initialized;
  final bool useDarkMode;
  
  _ViewModel({
    required this.initialized,
    required this.useDarkMode
  });

  static _ViewModel fromStore(Store<AppState> store) => _ViewModel(
    initialized: store.state.initialized,
    useDarkMode: store.state.useDarkMode
  );
}
