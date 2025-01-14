import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:m_design/UI/screens/designpreview.dart';
import 'package:m_design/utils/flutter_toast.dart';
import 'package:shimmer/shimmer.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<String> favoriteImages = [];
  List<String> selectedImages = [];
  bool isLoading = true;
  bool isSelectionMode = false;

  final fluttertoas toast = fluttertoas();
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    fetchCurrentUser();
  }

  void fetchCurrentUser() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        currentUserId = user.uid;
      });
      fetchFavorites();
    } else {
      toast.showpopup(Colors.red, 'User not logged in!');
    }
  }

  void fetchFavorites() async {
    if (currentUserId == null) return;

    setState(() => isLoading = true);
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('favorites')
          .where('userId', isEqualTo: currentUserId) // Filter by userId
          .get();

      setState(() {
        favoriteImages =
            snapshot.docs.map((doc) => doc['imageUrl'].toString()).toList();
      });
    } catch (e) {
      print("Error fetching favorites: $e");
      toast.showpopup(Colors.red, 'Error fetching favorites!');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void deleteSelectedFavorites() async {
    if (currentUserId == null) return;

    try {
      for (var imageUrl in selectedImages) {
        var snapshot = await FirebaseFirestore.instance
            .collection('favorites')
            .where('imageUrl', isEqualTo: imageUrl)
            .where('userId', isEqualTo: currentUserId) // Filter by userId
            .get();

        for (var doc in snapshot.docs) {
          await FirebaseFirestore.instance
              .collection('favorites')
              .doc(doc.id)
              .delete();
        }

        setState(() {
          favoriteImages.remove(imageUrl);
        });
      }
      selectedImages.clear();
      isSelectionMode = false;
      toast.showpopup(Colors.brown, 'Selected favorites deleted!');
    } catch (e) {
      print("Error deleting favorites: $e");
      toast.showpopup(Colors.red, 'Failed to delete selected favorites!');
    }
  }

  void toggleSelectionMode(String imageUrl) {
    setState(() {
      if (selectedImages.contains(imageUrl)) {
        selectedImages.remove(imageUrl);
      } else {
        selectedImages.add(imageUrl);
      }
    });
  }

  void selectAllFavorites() {
    setState(() {
      if (selectedImages.length == favoriteImages.length) {
        selectedImages.clear();
      } else {
        selectedImages = List.from(favoriteImages);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isSelectionMode ? "${selectedImages.length} Selected" : "Favorites",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.brown,
        actions: isSelectionMode
            ? [
                IconButton(
                  icon: Icon(
                    Icons.select_all,
                    color: Colors.white,
                  ),
                  onPressed: selectAllFavorites,
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  onPressed: deleteSelectedFavorites,
                ),
              ]
            : [],
      ),
      body: isLoading
          ? GridView.builder(
              padding: EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                );
              },
            )
          : favoriteImages.isEmpty
              ? Center(child: Text('No favorites added yet!'))
              : GridView.builder(
                  padding: EdgeInsets.all(16.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                  ),
                  itemCount: favoriteImages.length,
                  itemBuilder: (context, index) {
                    String imageUrl = favoriteImages[index];
                    bool isSelected = selectedImages.contains(imageUrl);
                    return GestureDetector(
                      onLongPress: () {
                        setState(() {
                          isSelectionMode = true;
                          toggleSelectionMode(imageUrl);
                        });
                      },
                      onTap: () {
                        if (isSelectionMode) {
                          toggleSelectionMode(imageUrl);
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FullScreenImage(imageUrl: imageUrl),
                            ),
                          );
                        }
                      },
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                          if (isSelected)
                            Container(
                              color: Colors.black54,
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 40,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
