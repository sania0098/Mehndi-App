import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:m_design/UI/Auth/profile/profile.dart';
import 'package:m_design/UI/screens/categoryscreen.dart';
import 'package:m_design/UI/screens/favoritescreen.dart';
import 'package:m_design/UI/screens/viewuploadImages.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = "Arabic";
  String selectedSubcategory = "Simple";
  List<String> categories = [
    "Arabic",
    "Indian",
    "Pakistani",
    "Traditional",
    "Modern",
    'Western_style',
  ];
  List<String> images = [
    "asset/arabic2.jpg",
    "asset/indian_design2.jpg",
    "asset/pakistani_design.jpg",
    "asset/traditional_design.jpg",
    "asset/moderan_design.jpg",
    'asset/western_design2.jpg',
  ];
  List<String> subcategories = ["Simple", "Bridal", "Hand", "Feet"];

  String? get currentUserId => FirebaseAuth.instance.currentUser?.uid;

  void navigateToFavoriteScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FavoritesScreen(),
      ),
    );
  }

  void navigateToUploadedImagesScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Viewuploadimages(userId: currentUserId)),
    );
  }

  void navigateToCategoryScreen(String categoryName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryScreen(categoryName: categoryName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        title: Center(
          child: Text(
            'Mehndi Designs',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.brown,
        actions: [
          PopupMenuButton<int>(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              switch (value) {
                case 0:
                  navigateToFavoriteScreen();
                  break;
                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Profile()),
                  );
                  break;
                case 2:
                  navigateToUploadedImagesScreen();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 0,
                child: Row(
                  children: [
                    Icon(Icons.favorite, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Favorites'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    Icon(Icons.person, color: Colors.brown),
                    SizedBox(width: 8),
                    Text('Profile'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: Row(
                  children: [
                    Icon(Icons.upload, color: Colors.brown),
                    SizedBox(width: 8),
                    Text('Uploads'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: categories.map((category) {
                      return GestureDetector(
                        onTap: () => navigateToCategoryScreen(category),
                        child: Column(
                          children: [
                            Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 4),
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  images[categories.indexOf(
                                      category)], 
                                  fit: BoxFit.cover,
                                  width:
                                      150, 
                                  height: 150,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              category,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
