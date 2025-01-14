import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:m_design/utils/flutter_toast.dart';

class Uploadimages extends StatefulWidget {
  const Uploadimages({super.key});

  @override
  State<Uploadimages> createState() => _UploadimagesState();
}

class _UploadimagesState extends State<Uploadimages> {
  String selectedCategory = "Arabic";
  String selectedSubcategory = "Simple";
  List<String> categories = [
    "Arabic",
    "Indian",
    "Pakistani",
    "Traditional",
    "Modern"
  ];
  List<String> subcategories = ["Simple", "Bridal", "Hand", "Feet"];
  bool isUploading = false;
  List<File> selectedImages = [];
  final fluttertoas toast = fluttertoas();

  String? get currentUserId => FirebaseAuth.instance.currentUser?.uid;

  Future<void> selectImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();

    if (images != null && images.isNotEmpty) {
      setState(() {
        selectedImages.addAll(images.map((img) => File(img.path)));
      });
    }
  }

  Future<void> uploadImages() async {
    if (selectedImages.isEmpty) {
      toast.showpopup(Colors.red, "Please select images to upload!");
      return;
    }

    setState(() {
      isUploading = true;
    });

    try {
      for (File image in selectedImages) {
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference ref = storage.ref().child(
            'mehndi_images/${selectedCategory}_${selectedSubcategory}/${DateTime.now().millisecondsSinceEpoch}.jpg');

        await ref.putFile(image);

        String imageUrl = await ref.getDownloadURL();

        FirebaseFirestore.instance.collection('mehndi_images').add({
          'userId': currentUserId,
          'imageUrl': imageUrl,
          'category': selectedCategory,
          'subcategory': selectedSubcategory,
        });
      }

      toast.showpopup(Colors.green, "Images uploaded successfully!");

      setState(() {
        selectedImages.clear();
      });
    } catch (e) {
      toast.showpopup(Colors.red, "Failed to upload images: $e");
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  void removeImage(int index) {
    setState(() {
      selectedImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade100,
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(
          'Upload design',
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 0),
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [

                              Image.asset(
                                'asset/designimage.jpg',
                                fit: BoxFit.cover,
                              ),

                              Positioned(
                                bottom: 20,
                                left: 20,
                                child: Text(
                                  'Here you can upload your design',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.8),
                                        blurRadius: 5,
                                        offset: Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Select Category",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: selectedCategory,
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedCategory = newValue;
                            });
                          }
                        },
                        items: categories.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.brown.shade400,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.brown, width: 2),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Select Subcategory",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: selectedSubcategory,
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedSubcategory = newValue;
                            });
                          }
                        },
                        items: subcategories.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.brown.shade400,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.brown),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.brown, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: selectImages,
                    child: Text(
                      "Select Images",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(selectedImages.length, (index) {
                    return Stack(
                      children: [
                        Image.file(
                          selectedImages[index],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => removeImage(index),
                            child: Icon(Icons.cancel, color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                SizedBox(height: 10),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: isUploading ? null : uploadImages,
                    icon: Icon(
                      Icons.upload,
                      color: Colors.white,
                    ),
                    label: Text(
                      isUploading ? "Uploading..." : "Upload Images",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isUploading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(color: Colors.brown),
              ),
            ),
        ],
      ),
    );
  }
}






// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// import 'package:m_design/utils/flutter_toast.dart';

// class Uploadimages extends StatefulWidget {
//   const Uploadimages({super.key});

//   @override
//   State<Uploadimages> createState() => _UploadimagesState();
// }

// class _UploadimagesState extends State<Uploadimages> {
//   String selectedCategory = "Arabic";
//   String selectedSubcategory = "Simple";
//   List<String> categories = [
//     "Arabic",
//     "Indian",
//     "Pakistani",
//     "Traditional",
//     "Modern"
//   ];
//   List<String> subcategories = ["Simple", "Bridal", "Hand", "Feet"];
//   bool isUploading = false;
//   List<File> selectedImages = [];
//   final fluttertoas toast = fluttertoas();

//   String? get currentUserId => FirebaseAuth.instance.currentUser?.uid;

//   Future<void> selectImages() async {
//     final ImagePicker picker = ImagePicker();
//     final List<XFile>? images = await picker.pickMultiImage();

//     if (images != null && images.isNotEmpty) {
//       setState(() {
//         selectedImages.addAll(images.map((img) => File(img.path)));
//       });
//     }
//   }

//   Future<void> uploadImages() async {
//     if (selectedImages.isEmpty) {
//       toast.showpopup(Colors.red, "Please select images to upload!");
//       return;
//     }

//     setState(() {
//       isUploading = true;
//     });

//     try {
//       for (File image in selectedImages) {
//         FirebaseStorage storage = FirebaseStorage.instance;
//         Reference ref = storage.ref().child(
//             'mehndi_images/${selectedCategory}_${selectedSubcategory}/${DateTime.now().millisecondsSinceEpoch}.jpg');

//         await ref.putFile(image);

//         String imageUrl = await ref.getDownloadURL();

//         // Save image data to Firestore with status as "Pending"
//         FirebaseFirestore.instance.collection('mehndi_images').add({
//           'userId': currentUserId,
//           'imageUrl': imageUrl,
//           'category': selectedCategory,
//           'subcategory': selectedSubcategory,
//           'status': 'Pending', // New field
//           'uploadTime': FieldValue.serverTimestamp(), // Optional, for sorting
//         });
//       }

//       toast.showpopup(Colors.brown, "Images uploading.....!");

//       setState(() {
//         selectedImages.clear();
//       });
//     } catch (e) {
//       toast.showpopup(Colors.red, "Failed to upload images: $e");
//     } finally {
//       setState(() {
//         isUploading = false;
//       });
//     }
//   }

//   void removeImage(int index) {
//     setState(() {
//       selectedImages.removeAt(index);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.brown.shade100,
//       appBar: AppBar(
//         backgroundColor: Colors.brown,
//         title: Text(
//           'Upload design',
//           style: TextStyle(
//               color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 10),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(height: 0),
//                       Container(
//                         width: double.infinity,
//                         height: 200,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(20),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.2),
//                               blurRadius: 10,
//                               offset: Offset(0, 5),
//                             ),
//                           ],
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(20),
//                           child: Stack(
//                             fit: StackFit.expand,
//                             children: [
//                               Image.asset(
//                                 'asset/designimage.jpg',
//                                 fit: BoxFit.cover,
//                               ),
//                               Positioned(
//                                 bottom: 20,
//                                 left: 20,
//                                 child: Text(
//                                   'Here you can upload your design',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold,
//                                     shadows: [
//                                       Shadow(
//                                         color: Colors.black.withOpacity(0.8),
//                                         blurRadius: 5,
//                                         offset: Offset(2, 2),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       Text(
//                         "Select Category",
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(height: 10),
//                       DropdownButtonFormField<String>(
//                         value: selectedCategory,
//                         onChanged: (String? newValue) {
//                           if (newValue != null) {
//                             setState(() {
//                               selectedCategory = newValue;
//                             });
//                           }
//                         },
//                         items: categories.map((String value) {
//                           return DropdownMenuItem<String>(
//                             value: value,
//                             child: Text(value),
//                           );
//                         }).toList(),
//                         decoration: InputDecoration(
//                           filled: true,
//                           fillColor: Colors.brown.shade400,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: BorderSide(color: Colors.grey),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide:
//                                 BorderSide(color: Colors.brown, width: 2),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       Text(
//                         "Select Subcategory",
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(height: 10),
//                       DropdownButtonFormField<String>(
//                         value: selectedSubcategory,
//                         onChanged: (String? newValue) {
//                           if (newValue != null) {
//                             setState(() {
//                               selectedSubcategory = newValue;
//                             });
//                           }
//                         },
//                         items: subcategories.map((String value) {
//                           return DropdownMenuItem<String>(
//                             value: value,
//                             child: Text(value),
//                           );
//                         }).toList(),
//                         decoration: InputDecoration(
//                           filled: true,
//                           fillColor: Colors.brown.shade400,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: BorderSide(color: Colors.brown),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide:
//                                 BorderSide(color: Colors.brown, width: 2),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Center(
//                   child: ElevatedButton(
//                     onPressed: selectImages,
//                     child: Text(
//                       "Select Images",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.brown,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Wrap(
//                   spacing: 10,
//                   runSpacing: 10,
//                   children: List.generate(selectedImages.length, (index) {
//                     return Stack(
//                       children: [
//                         Image.file(
//                           selectedImages[index],
//                           width: 100,
//                           height: 100,
//                           fit: BoxFit.cover,
//                         ),
//                         Positioned(
//                           top: 0,
//                           right: 0,
//                           child: GestureDetector(
//                             onTap: () => removeImage(index),
//                             child: Icon(Icons.cancel, color: Colors.red),
//                           ),
//                         ),
//                       ],
//                     );
//                   }),
//                 ),
//                 SizedBox(height: 10),
//                 Center(
//                   child: ElevatedButton.icon(
//                     onPressed: isUploading ? null : uploadImages,
//                     icon: Icon(
//                       Icons.upload,
//                       color: Colors.white,
//                     ),
//                     label: Text(
//                       isUploading ? "Uploading..." : "Upload Images",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.brown,
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           if (isUploading)
//             Container(
//               color: Colors.black.withOpacity(0.5),
//               child: Center(
//                 child: CircularProgressIndicator(color: Colors.brown),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
