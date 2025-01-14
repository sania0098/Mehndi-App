// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:m_design/UI/Auth/login/login.dart';

// class AdminPanel extends StatefulWidget {
//   const AdminPanel({super.key});

//   @override
//   State<AdminPanel> createState() => _AdminPanelState();
// }

// class _AdminPanelState extends State<AdminPanel> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Admin Panel",
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: Colors.brown,
//         leading: GestureDetector(
//           onTap: () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => Login()),
//             );
//           },
//           child: Icon(
//             Icons.arrow_back,
//             color: Colors.white,
//           ),
//         ),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('mehndi_images')
//             .where('status', isEqualTo: 'Pending')
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text("No pending images."));
//           }

//           final images = snapshot.data!.docs;

//           return ListView.builder(
//             itemCount: images.length,
//             itemBuilder: (context, index) {
//               final image = images[index];
//               final imageData = image.data() as Map<String, dynamic>;

//               return Card(
//                 margin: EdgeInsets.all(10),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Image.network(
//                       imageData['imageUrl'],
//                       height: 200,
//                       width: double.infinity,
//                       fit: BoxFit.cover,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Category: ${imageData['category']}",
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           Text("Subcategory: ${imageData['subcategory']}"),
//                           SizedBox(height: 10),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               ElevatedButton(
//                                 onPressed: () {
//                                   FirebaseFirestore.instance
//                                       .collection('mehndi_images')
//                                       .doc(image.id)
//                                       .update({
//                                     'status': 'Approved'
//                                   }); // Update status to Approved
//                                 },
//                                 child: Text("Approve"),
//                                 style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.brown),
//                               ),
//                               ElevatedButton(
//                                 onPressed: () {
//                                   _showRejectionDialog(image.id);
//                                 },
//                                 child: Text("Reject"),
//                                 style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.red),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   void _showRejectionDialog(String imageId) {
//     final TextEditingController reasonController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("Reject Image"),
//           content: TextField(
//             controller: reasonController,
//             decoration: InputDecoration(hintText: "Enter rejection reason"),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text("Cancel"),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 final reason = reasonController.text;

//                 if (reason.isNotEmpty) {
//                   FirebaseFirestore.instance
//                       .collection('mehndi_images')
//                       .doc(imageId)
//                       .update({
//                     'status': 'Rejected',
//                     'rejectionReason': reason,
//                   });

//                   Navigator.pop(context);
//                 }
//               },
//               child: Text("Reject"),
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
