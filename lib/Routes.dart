import 'package:flutter/material.dart';
import 'package:barcode_scan_example/Screens/Login/index.dart'; 

import 'package:flutter/material.dart';

import './pages/home_page.dart';
class Routes {
  Routes() {
    runApp(new MaterialApp(
      title: "Dribbble Animation App",
      debugShowCheckedModeBanner: false,
      home: new LoginScreen(),
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/login':
            return new MyCustomRoute(
              builder: (_) => new LoginScreen(),
              settings: settings,
            );

          case '/home':
 
          home: new MainPage();
    
              //Hérna má næsti skjár koma
             // builder: (_) => new HomeScreen(),
              //settings: settings,
        
        }
      },
    ));
  }
}

class MyCustomRoute<T> extends MaterialPageRoute<T> { 
  MyCustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings); 

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) return child;
    return new FadeTransition(opacity: animation, child: child);
  }
}
