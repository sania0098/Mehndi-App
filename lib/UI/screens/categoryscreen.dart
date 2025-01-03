import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:m_design/UI/screens/designpreview.dart';
import 'package:m_design/utils/flutter_toast.dart';
import 'package:shimmer/shimmer.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CategoryScreen extends StatefulWidget {
  final String categoryName;

  const CategoryScreen({super.key, required this.categoryName});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<String> categoryImages = [];
  List<String> favoriteImages = [];
  String selectedSubcategory = "Simple";
  bool isLoading = true;

  final fluttertoas toast = fluttertoas();

  String? get currentUserId => FirebaseAuth.instance.currentUser?.uid;

  void fetchCategoryImages() async {
    setState(() => isLoading = true);
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('mehndi_images')
          .where('category', isEqualTo: widget.categoryName)
          .where('subcategory', isEqualTo: selectedSubcategory)
          .get();

      List<String> fetchedImages = [];
      for (var doc in snapshot.docs) {
        if (doc.data().containsKey('imageUrl') &&
            doc['imageUrl'] is String &&
            doc['imageUrl'] != null) {
          fetchedImages.add(doc['imageUrl']);
        }
      }

      setState(() {
        categoryImages = fetchedImages;
      });
    } catch (e) {
      print("Error fetching images: $e");
      toast.showpopup(Colors.red, "Error fetching images. Please try again.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void fetchFavoriteImages() async {
    if (currentUserId == null) return;

    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('favorites')
          .where('userId', isEqualTo: currentUserId)
          .get();

      setState(() {
        favoriteImages =
            snapshot.docs.map((doc) => doc['imageUrl'].toString()).toList();
      });
    } catch (e) {
      print("Error fetching favorites: $e");
    }
  }

  void toggleFavorite(String imageUrl) async {
    if (currentUserId == null) {
      toast.showpopup(Colors.red, "You must be logged in to use favorites.");
      return;
    }

    try {
      if (favoriteImages.contains(imageUrl)) {
        var snapshot = await FirebaseFirestore.instance
            .collection('favorites')
            .where('imageUrl', isEqualTo: imageUrl)
            .where('userId', isEqualTo: currentUserId)
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
        toast.showpopup(Colors.green, "Removed from favorites!");
      } else {
        await FirebaseFirestore.instance.collection('favorites').add({
          'imageUrl': imageUrl,
          'category': widget.categoryName,
          'subcategory': selectedSubcategory,
          'userId': currentUserId, // Associate favorite with the current user
        });

        setState(() {
          favoriteImages.add(imageUrl);
        });
        toast.showpopup(Colors.green, "Added to favorites!");
      }
    } catch (e) {
      print("Error toggling favorite: $e");
      toast.showpopup(Colors.red, "Failed to update favorites.");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCategoryImages();
    fetchFavoriteImages();
  }

  void showFullScreenImage(String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImage(imageUrl: imageUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.categoryName} Designs',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.brown,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          SizedBox(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: ["Simple", "Bridal", "Hand", "Feet"].map((subcategory) {
                final isSelected = subcategory == selectedSubcategory;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedSubcategory = subcategory;
                        fetchCategoryImages();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isSelected ? Colors.brown : Colors.brown.shade100,
                      foregroundColor: isSelected ? Colors.white : Colors.black,
                    ),
                    child: Text(subcategory),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: isLoading
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
                : categoryImages.isEmpty
                    ? Center(
                        child: Text('No images found for this subcategory.'))
                    : GridView.builder(
                        padding: EdgeInsets.all(16.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                        ),
                        itemCount: categoryImages.length,
                        itemBuilder: (context, index) {
                          String imageUrl = categoryImages[index];
                          bool isFavorite = favoriteImages.contains(imageUrl);

                          return GestureDetector(
                            onTap: () => showFullScreenImage(imageUrl),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    height: double.infinity,
                                    width: double.infinity,
                                  ),
                                ),
                                Positioned(
                                  bottom: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () {
                                      toggleFavorite(imageUrl);
                                    },
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 300),
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: isFavorite
                                            ? Colors.red
                                            : Colors.brown.withOpacity(0.8),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
