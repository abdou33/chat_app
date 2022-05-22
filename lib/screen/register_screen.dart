import 'package:chat_app/screen/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class registrationscreen extends StatefulWidget {
  const registrationscreen({Key? key}) : super(key: key);

  @override
  State<registrationscreen> createState() => _registrationscreenState();
}

class _registrationscreenState extends State<registrationscreen> {
  final auth = FirebaseAuth.instance;
  // our form key
  final formkey = GlobalKey<FormState>();
  //editing keys
  final nameeditingcontroller = new TextEditingController();
  final pass1editingcontroller = new TextEditingController();
  final pass2editingcontroller = new TextEditingController();
  var focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    //name field
    final emailField = TextFormField(
      focusNode: focusNode,
      autofocus: false,
      controller: nameeditingcontroller,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please enter a username");
        }
        //reg expression for email validation
        /*if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("this username has already been taken");
        }*/
        return null;
      },
      onSaved: (value) {
        nameeditingcontroller.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.accessible_forward_outlined),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "username",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    //pass1 field
    final password1Field = TextFormField(
      autofocus: false,
      obscureText: true,
      controller: pass1editingcontroller,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        //if !password
        if (value!.isEmpty) {
          return ("Password is required");
        }
        //if password < 6
        if (!regex.hasMatch(value)) {
          return ("Enter a password with at least 6 characters");
        }
      },
      onSaved: (value) {
        pass1editingcontroller.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    //pass2 field
    final password2Field = TextFormField(
      autofocus: false,
      obscureText: true,
      controller: pass2editingcontroller,
      validator: (value) {
        if (pass2editingcontroller.text != pass1editingcontroller.text) {
          return "password dont match";
        }
        return null;
      },
      onSaved: (value) {
        pass2editingcontroller.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "confirm password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    //submit button
    final signupbutton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.green.shade400,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          //String newemail = "";
          signup(nameeditingcontroller.text + "@froggo.com",
              pass1editingcontroller.text);
        },
        child: Text(
          "SignUp",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.green,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
              child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                  key: formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 150,
                        child: Image.asset(
                          "assets/logo.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(
                        height: 45,
                      ),
                      emailField,
                      SizedBox(
                        height: 20,
                      ),
                      password1Field,
                      SizedBox(
                        height: 20,
                      ),
                      password2Field,
                      SizedBox(
                        height: 35,
                      ),
                      //loginbutton,
                      signupbutton,
                    ],
                  )),
            ),
          )),
        ));
  }
  /*FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password).then((user) {

    // do whatever you want to do with new user object

  }).catchError((e) {
    print(e.details); // code, message, details
  });*/

  void signup(String email, String pass) async {
    if (formkey.currentState!.validate()) {
      await auth
          .createUserWithEmailAndPassword(email: email, password: pass)
          .then((value) => {postDetailsToFirebase()})
          .catchError((e) {
        print(e!.message);
        if (e!.message ==
            "The email address is already in use by another account.") {
          nameeditingcontroller.clear();
          focusNode.requestFocus();
          //nameeditingcontroller.
        }
        Fluttertoast.showToast(
          msg: "this username already exists!",
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Color.fromARGB(255, 11, 11, 11),
          textColor: Colors.white,
          fontSize: 18.0,
          );
      });
    }
  }

  postDetailsToFirebase() async {
    //calling our firestore
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = auth.currentUser;

    Fluttertoast.showToast(msg: "account created successfully");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => Homescreen()),
        (route) => false);
  }
}
