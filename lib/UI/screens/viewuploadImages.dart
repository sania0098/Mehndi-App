import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:m_design/UI/screens/designpreview.dart';
import 'package:m_design/UI/screens/uploadimages.dart';
import 'package:shimmer/shimmer.dart'; // Add shimmer effect

class Viewuploadimages extends StatefulWidget {
  final String? userId;

  const Viewuploadimages({super.key, required this.userId});

  @override
  State<Viewuploadimages> createState() => _ViewuploadimagesState();
}

class _ViewuploadimagesState extends State<Viewuploadimages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Uploaded Images",
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.brown,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Uploadimages()));
        },
        child: Icon(
          Icons.upload_outlined,
          color: Colors.white,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('mehndi_images')
            .where('userId', isEqualTo: widget.userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 6, // Placeholder shimmer items
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    color: Colors.grey,
                    margin: EdgeInsets.all(5),
                  ),
                );
              },
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No images uploaded yet!",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var imageData = snapshot.data!.docs[index];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FullScreenImage(
                                  imageUrl: imageData['imageUrl'])));
                    },
                    child: Image.network(
                      imageData['imageUrl'],
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            color: Colors.grey,
                            margin: EdgeInsets.all(5),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
