// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:m_design/UI/Auth/signup/signup.dart';

// import 'package:m_design/UI/screens/homescreen.dart';

// import 'package:m_design/utils/flutter_toast.dart';

// class Login extends StatefulWidget {
//   const Login({super.key});

//   @override
//   State<Login> createState() => _LoginState();
// }

// class _LoginState extends State<Login> {
//   final formKey = GlobalKey<FormState>(); // Form key for validation
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   bool isLoading = false;

//   void loginFunction() {
//     if (formKey.currentState!.validate()) {
//       setState(() {
//         isLoading = true;
//       });

//       FirebaseAuth.instance
//           .signInWithEmailAndPassword(
//         email: emailController.text.trim(),
//         password: passwordController.text.trim(),
//       )
//           .then((_) {
//         fluttertoas().showpopup(Colors.green, 'Login successful');
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => HomeScreen()),
//         );
//       }).catchError((error) {
//         if (error is FirebaseAuthException) {
//           fluttertoas()
//               .showpopup(Colors.red, error.message ?? "An error occurred");
//         } else {
//           fluttertoas().showpopup(Colors.red, "An unexpected error occurred");
//         }
//       }).whenComplete(() {
//         setState(() {
//           isLoading = false;
//         });
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: SingleChildScrollView(
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               Image.asset(
//                 'asset/mehndi2.jpeg',
//                 fit: BoxFit.cover,
//                 height: MediaQuery.of(context).size.height,
//                 width: MediaQuery.of(context).size.width,
//               ),
//               Container(
//                 height: 500,
//                 width: 300,
//                 decoration: BoxDecoration(
//                     color: Colors.brown,
//                     borderRadius: BorderRadius.circular(25)),
//                 child: Form(
//                   key: formKey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       const SizedBox(height: 20),
//                       Text(
//                         'Login',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 40,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       Text(
//                         'Welcome back!',
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       // Email Field
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 10),
//                         child: TextFormField(
//                           controller: emailController,
//                           style: TextStyle(fontSize: 16, color: Colors.black),
//                           decoration: InputDecoration(
//                             hintText: 'Email',
//                             prefixIcon: Icon(Icons.email, color: Colors.black),
//                             hintStyle: const TextStyle(fontSize: 14),
//                             fillColor: Colors.brown,
//                             filled: true,
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                               borderSide: BorderSide(color: Colors.black),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                               borderSide: BorderSide(color: Colors.black),
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter an email';
//                             }
//                             if (!RegExp(
//                                     r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
//                                 .hasMatch(value)) {
//                               return 'Please enter a valid email';
//                             }
//                             return null;
//                           },
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       // Password Field
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 10),
//                         child: TextFormField(
//                           controller: passwordController,
//                           obscureText: true,
//                           style: TextStyle(fontSize: 16, color: Colors.black),
//                           decoration: InputDecoration(
//                             hintText: 'Password',
//                             prefixIcon: Icon(Icons.lock, color: Colors.black),
//                             hintStyle: const TextStyle(fontSize: 14),
//                             fillColor: Colors.brown,
//                             filled: true,
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                               borderSide: BorderSide(color: Colors.black),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                               borderSide: BorderSide(color: Colors.black),
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter your password';
//                             }
//                             return null;
//                           },
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       Padding(
//                         padding: const EdgeInsets.only(right: 10),
//                         child: Align(
//                           alignment: Alignment.centerRight,
//                           child: Text(
//                             'Forgot your password?',
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 30),

//                       GestureDetector(
//                         onTap: loginFunction,
//                         child: isLoading
//                             ? CircularProgressIndicator()
//                             : Container(
//                                 height: 50,
//                                 width: 200,
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(10),
//                                     color: Colors.white),
//                                 child: Center(
//                                   child: Text(
//                                     'login',
//                                     style: TextStyle(
//                                         color: Colors.brown,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ),
//                               ),
//                       ),

//                       SizedBox(
//                         height: 50,
//                       ),

//                       SizedBox(
//                         height: 15,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Text(
//                             'Don\'t have an account? ',
//                             style: TextStyle(color: Colors.black),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => Signup()),
//                               );
//                             },
//                             child: const Text(
//                               'sign up',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 decoration: TextDecoration.underline,
//                                 decorationThickness: 2,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:m_design/UI/Auth/signup/signup.dart';

import 'package:m_design/UI/screens/admin_screen.dart';

import 'package:m_design/UI/screens/homescreen.dart'; // User home screen
import 'package:m_design/utils/flutter_toast.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>(); // Form key for validation
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  void loginFunction() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        final email = emailController.text.trim();
        final password = passwordController.text.trim();

        // Hardcoded admin credentials
        const adminEmail = "admin@gmail.com";
        const adminPassword = "admin123";

        if (email == adminEmail && password == adminPassword) {
          // Navigate to Admin Dashboard
          fluttertoas().showpopup(Colors.green, 'Welcome Admin!');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminDashboard()),
          );
        } else {
          // Check if the user exists in Firebase Auth
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password,
          );

          // Navigate to User Home Screen
          fluttertoas().showpopup(Colors.green, 'Login successful');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }
      } on FirebaseAuthException catch (e) {
        fluttertoas().showpopup(Colors.red, e.message ?? "An error occurred");
      } catch (e) {
        fluttertoas().showpopup(Colors.red, "An unexpected error occurred");
      } finally {
        setState(() {
          isLoading = false;
        });
      }
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
                height: 500,
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
                        'Login',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Welcome back!',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Email Field
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          cursorColor: Colors.white,
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
                          cursorColor: Colors.white,
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
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
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
                        onTap: loginFunction,
                        child: isLoading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Container(
                                height: 50,
                                width: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                child: Center(
                                  child: Text(
                                    'login',
                                    style: TextStyle(
                                        color: Colors.brown,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                      ),

                      const SizedBox(height: 50),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Don\'t have an account? ',
                            style: TextStyle(color: Colors.black),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Signup()),
                              );
                            },
                            child: const Text(
                              'sign up',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
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
