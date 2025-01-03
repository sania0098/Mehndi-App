import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shimmer/shimmer.dart';

import 'package:m_design/UI/Auth/login/login.dart';
import 'package:m_design/UI/Auth/signup/signup.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  File? _profileImage;
  String? _profileImageUrl;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      setState(() {
        _profileImageUrl = userDoc['profileImage'] ?? null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error (e.g., user document does not exist)
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
      await _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (_profileImage == null) return;

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images/${currentUser.uid}.jpg');

      await storageRef.putFile(_profileImage!);

      String downloadUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .set({
        'profileImage': downloadUrl,
      }, SetOptions(merge: true));

      setState(() {
        _profileImageUrl = downloadUrl;
      });
    } catch (e) {
      // Handle error (e.g., show a Snackbar or Dialog)
    }
  }

  void _viewImage() {
    if (_profileImageUrl != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FullScreenImage(
            imageUrl: _profileImageUrl!,
            userName: currentUser.displayName ?? 'No Name Provided',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 'Logout') {
                FirebaseAuth.instance.signOut().then((v) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Login()));
                });
              } else if (value == 'Delete Account') {
                FirebaseAuth.instance.currentUser!.delete().then((v) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const Signup()));
                });
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'Logout',
                  child: Text('Logout'),
                ),
                const PopupMenuItem(
                  value: 'Delete Account',
                  child: Text('Delete Account'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(children: [
          const SizedBox(height: 20),
          // Profile Picture with Edit Icon
          Center(
            child: Stack(
              children: [
                _isLoading
                    ? Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey.shade300,
                        ),
                      )
                    : GestureDetector(
                        onTap: _viewImage,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: _profileImageUrl != null
                              ? NetworkImage(_profileImageUrl!)
                              : const AssetImage('assets/default_profile.png')
                                  as ImageProvider,
                          backgroundColor: Colors.grey.shade300,
                        ),
                      ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.brown,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Display User Name and Email
          // Text(
          //   currentUser.displayName ?? 'No Name Provided',
          //   style: const TextStyle(
          //     fontSize: 18,
          //     fontWeight: FontWeight.bold,
          //     color: Colors.black,
          //   ),
          // ),
          const SizedBox(height: 5),
          Text(
            currentUser.email ?? 'No Email Provided',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ]),
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;
  final String userName;

  const FullScreenImage({
    required this.imageUrl,
    required this.userName,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(userName, style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Hero(
          tag: imageUrl,
          child: Image.network(imageUrl),
        ),
      ),
    );
  }
}
