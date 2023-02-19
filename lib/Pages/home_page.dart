import 'package:firebase_auth/firebase_auth.dart';
import 'package:login/auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget title() {
    return const Text('Home page');
  }

  Widget _userUid() {
    return Text(user?.email ?? 'user email');
  }

  Widget _signOutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
      child: Container(
        width: 150,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment(2.4, 0.9),
            colors: <Color>[
              Color(0xff386680),
              Color(0xffE4F5FF),
            ],
            //tileMode: TileMode.mirror,
          ),
          borderRadius: BorderRadius.all(Radius.circular(40.0)),
        ),
        child: TextButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          ),
          onPressed: () {
            signOut();
          },
          child: const Text(
            'Sign out',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: title(),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              height: 300,
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: DrawerHeader(
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.grey),
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _userUid(),
                  _signOutButton(),
                ],
              ),
            )
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(child: Text('signed in as')),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              user?.email ?? 'user email',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
          ),
          // Center(child: _signOutButton()),
        ],
      ),
    );
  }
}
