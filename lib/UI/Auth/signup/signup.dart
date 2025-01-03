import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:m_design/UI/Auth/login/login.dart';
import 'package:m_design/UI/screens/homescreen.dart';

import 'package:m_design/utils/flutter_toast.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final formKey = GlobalKey<FormState>(); // Form key for validation
  final ref = FirebaseFirestore.instance.collection('user');
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  bool isLoading = false;

  void signupFunction() {
    if (formKey.currentState!.validate()) {
      if (passwordController.text != confirmPasswordController.text) {
        fluttertoas().showpopup(Colors.red, 'Passwords do not match');
        return;
      }
      setState(() {
        isLoading = true;
      });
      print('this is user${emailController.text.trim()}');
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      )
          .then((v) {
        ref.doc(v.user!.uid).set({
          'name': usernameController.text.trim().toString(),
          'email': emailController.text.trim().toString(),
          'uid': v.user!.uid,
        });
        fluttertoas().showpopup(Colors.green, 'Signup successful');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }).catchError((error) {
        fluttertoas().showpopup(Colors.red, error.toString());
      }).whenComplete(() {
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'asset/mehndi2.jpeg',
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              ),
              Container(
                height: 620,
                width: 300,
                decoration: BoxDecoration(
                    color: Colors.brown,
                    borderRadius: BorderRadius.circular(25)),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        'Sign up',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Create your account',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Username Field
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          controller: usernameController,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Username',
                            prefixIcon: Icon(Icons.person, color: Colors.black),
                            hintStyle: const TextStyle(fontSize: 14),
                            fillColor: Colors.brown,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a username';
                            }
                            if (value.length < 3) {
                              return 'Username must be at least 3 characters';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Email Field
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          controller: emailController,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Email',
                            prefixIcon: Icon(Icons.email, color: Colors.black),
                            hintStyle: const TextStyle(fontSize: 14),
                            fillColor: Colors.brown,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email';
                            }
                            if (!RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Password Field
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Password',
                            prefixIcon: Icon(Icons.lock, color: Colors.black),
                            hintStyle: const TextStyle(fontSize: 14),
                            fillColor: Colors.brown,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Confirm Password Field
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          controller: confirmPasswordController,
                          obscureText: true,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Confirm Password',
                            prefixIcon:
                                Icon(Icons.lock_outline, color: Colors.black),
                            hintStyle: const TextStyle(fontSize: 14),
                            fillColor: Colors.brown,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Forgot your password?',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      
                      GestureDetector(
                        onTap: signupFunction,
                        child: Container(
                          height: 50,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: isLoading
                              ? Center(
                                  child: SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: CircularProgressIndicator(
                                      color: Colors
                                          .brown, // Ensure contrast with background
                                      strokeWidth: 3.0,
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      color: Colors.brown,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                        ),
                      ),

                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(color: Colors.black),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()),
                              );
                            },
                            child: const Text(
                              'Log in',
                              style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                                decorationThickness: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
