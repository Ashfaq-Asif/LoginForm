import 'package:login/auth.dart';
import 'package:login/Pages/home_page.dart';
import 'package:login/Pages/login_register_page.dart';
import 'package:flutter/material.dart';

class PageNavigator extends StatefulWidget {
  const PageNavigator({Key? key}) : super(key: key);

  @override
  State<PageNavigator> createState() => _PageNavigatorState();
}

//display's home page when logged in, if not login/register page is displayed

class _PageNavigatorState extends State<PageNavigator> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        //determines if the user was logged in or not
        stream: Auth().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return (const Center(
              child: Text('something went wrong'),
            ));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return (const Center(
              child: CircularProgressIndicator(),
            ));
          } else if (snapshot.hasData) {
            return HomePage();
          } else {
            return const LoginPage();
          }
        });
  }
}
