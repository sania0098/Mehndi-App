

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class CUstomButton extends StatelessWidget {
//   const CUstomButton(
//       {super.key,
//       required this.text,
//       required this.btncolor,
//       this.isloading = false,
//       required this.ontap});
//   final text;
//   final btncolor;
//   final ontap;
//   final isloading;
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: ontap,
//       child: Container(
//         height: 40.h,
//         width: 280,
//         decoration: BoxDecoration(
//             color: btncolor, borderRadius: BorderRadius.circular(10.r)),
//         child: isloading
//             ? Center(
//                 child: SizedBox(
//                     height: 35.h,
//                     width: 40.w,
//                     child: const CircularProgressIndicator(
//                       color:Colors.brown ,
//                     )))
//             : Center(
//                 child: Text(
//                   text,
//                   style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
//                 ),
//               ),
//      ),
// );
// }
// }