import 'package:email_validator/email_validator.dart';
import 'package:login/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;
  final formKey = GlobalKey<FormState>();

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await Auth().signInWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
    //to dismiss the loading indicator after signup
    Navigator.pop(context);
  }

  Future<void> createUserWithEmailAndPassword() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await Auth().createUserWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
    Navigator.pop(context);
  }

  Widget _entryField(String title, TextEditingController controller) {
    return Padding(
        padding: const EdgeInsets.only(top: 36),
        child: Container(
          decoration: const BoxDecoration(
              // creates inner shadow for the text field
              color: Color(0xFFE7E7E7),
              borderRadius: BorderRadius.all(Radius.circular(12))),
          padding: const EdgeInsets.all(6),
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
                boxShadow: [
                  BoxShadow(color: Colors.white, blurRadius: 6, spreadRadius: 4)
                ]),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => title == 'password'
                    ? value != null && value.length < 6
                        ? 'Enter min.6 characters'
                        : null
                    : value != null && !EmailValidator.validate(value)
                        ? 'Enter a valid email'
                        : null,
                obscureText: title == 'password' ? true : false,
                controller: controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: title,
                ),
              ),
            ),
          ),
        ));
  }

  Widget _errorMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Text(
        errorMessage == '' ? '' : '$errorMessage',
        style: const TextStyle(color: Colors.deepOrangeAccent),
      ),
    );
  }

  Widget _submitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
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
          ),
          borderRadius: BorderRadius.all(Radius.circular(40.0)),
        ),
        child: TextButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          ),
          onPressed: isLogin
              ? signInWithEmailAndPassword
              : createUserWithEmailAndPassword,
          child: Text(
            isLogin ? 'Login' : 'Sign up',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _loginOrRegistrationSelector() {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            setState(() {
              isLogin = !isLogin;
            });
          },
          child: Row(
            children: [
              isLogin
                  ? Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('Don\'t have an account?'),
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text('Sign up instead',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                )),
                          )
                        ],
                      ),
                    )
                  : Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('Already have an account?'),
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text('login instead',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                )),
                          )
                        ],
                      ),
                    ),
            ],
          )),
    );
  }

  Widget _image() {
    return Container(
      width: 150,
      height: 150,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/login.png'),
          fit: BoxFit.cover,
        ),
        shape: BoxShape.circle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _image(),
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Text(
                  isLogin ? 'Login' : 'Sign up',
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.w600),
                ),
              ),
              _entryField('email', _controllerEmail),
              _entryField('password', _controllerPassword),
              _errorMessage(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _submitButton(),
                ],
              ),
              _loginOrRegistrationSelector()
            ],
          ),
        ),
      ),
    );
  }
}
