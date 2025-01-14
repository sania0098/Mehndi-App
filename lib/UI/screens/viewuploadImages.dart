import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:m_design/UI/screens/designpreview.dart';
import 'package:m_design/UI/screens/uploadimages.dart';
import 'package:shimmer/shimmer.dart';

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
              itemCount: 6,
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







// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:m_design/UI/screens/designpreview.dart';
// import 'package:m_design/UI/screens/uploadimages.dart';
// import 'package:shimmer/shimmer.dart';

// class Viewuploadimages extends StatefulWidget {
//   final String? userId;

//   const Viewuploadimages({super.key, required this.userId});

//   @override
//   State<Viewuploadimages> createState() => _ViewuploadimagesState();
// }

// class _ViewuploadimagesState extends State<Viewuploadimages> {
//   void deleteImage(String docId) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('mehndi_images')
//           .doc(docId)
//           .delete();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Image deleted successfully!")),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to delete image: $e")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Uploaded Images",
//           style: TextStyle(
//               color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.brown,
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.brown,
//         onPressed: () {
//           Navigator.push(
//               context, MaterialPageRoute(builder: (context) => Uploadimages()));
//         },
//         child: Icon(
//           Icons.upload_outlined,
//           color: Colors.white,
//         ),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('mehndi_images')
//             .where('userId', isEqualTo: widget.userId)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return GridView.builder(
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 10,
//                 mainAxisSpacing: 10,
//               ),
//               itemCount: 6,
//               itemBuilder: (context, index) {
//                 return Shimmer.fromColors(
//                   baseColor: Colors.grey.shade300,
//                   highlightColor: Colors.grey.shade100,
//                   child: Container(
//                     color: Colors.grey,
//                     margin: EdgeInsets.all(5),
//                   ),
//                 );
//               },
//             );
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(
//               child: Text(
//                 "No images uploaded yet!",
//                 style: TextStyle(fontSize: 16, color: Colors.grey),
//               ),
//             );
//           }

//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: GridView.builder(
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 10,
//                 mainAxisSpacing: 10,
//               ),
//               itemCount: snapshot.data!.docs.length,
//               itemBuilder: (context, index) {
//                 var imageData = snapshot.data!.docs[index];
//                 return Column(
//                   children: [
//                     Expanded(
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(10),
//                         child: GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => FullScreenImage(
//                                         imageUrl: imageData['imageUrl'])));
//                           },
//                           child: Stack(
//                             children: [
//                               Image.network(
//                                 imageData['imageUrl'],
//                                 fit: BoxFit.cover,
//                                 loadingBuilder:
//                                     (context, child, loadingProgress) {
//                                   if (loadingProgress == null) return child;
//                                   return Shimmer.fromColors(
//                                     baseColor: Colors.grey.shade300,
//                                     highlightColor: Colors.grey.shade100,
//                                     child: Container(
//                                       color: Colors.grey,
//                                       margin: EdgeInsets.all(5),
//                                     ),
//                                   );
//                                 },
//                               ),
//                               Positioned(
//                                 top: 5,
//                                 right: 5,
//                                 child: IconButton(
//                                   icon: Icon(Icons.delete, color: Colors.red),
//                                   onPressed: () {
//                                     showDialog(
//                                       context: context,
//                                       builder: (context) => AlertDialog(
//                                         title: Text("Delete Image"),
//                                         content: Text(
//                                             "Are you sure you want to delete this image?"),
//                                         actions: [
//                                           TextButton(
//                                             onPressed: () {
//                                               Navigator.pop(context);
//                                             },
//                                             child: Text("Cancel"),
//                                           ),
//                                           TextButton(
//                                             onPressed: () {
//                                               deleteImage(imageData.id);
//                                               Navigator.pop(context);
//                                             },
//                                             child: Text("Delete"),
//                                           ),
//                                         ],
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 5),
//                     Text(
//                       "Status: ${imageData['status']}",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: imageData['status'] == 'Rejected'
//                             ? Colors.red
//                             : Colors.green,
//                       ),
//                     ),
//                     if (imageData['status'] == 'Rejected')
//                       Text(
//                         "Reason: ${imageData['rejectionReason']}",
//                         style: TextStyle(color: Colors.red),
//                       ),
//                   ],
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
