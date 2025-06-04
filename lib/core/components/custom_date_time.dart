// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// import '../core.dart';

// class CustomDateTime extends StatefulWidget {
//   final void Function(DateTime selectedDate)? onDateSelected;
//   late final DateTime? dateTime;
//   final TextEditingController? textEditingController;
//   final Widget? prefix;
//   final String label;
//   final bool showLabel;

//    CustomDateTime({
//     super.key,
//     required this.label,
//     this.showLabel = true,
//     this.dateTime,
//     this.textEditingController,
//     this.onDateSelected,
//     this.prefix,
//   });

//   @override
//   State<CustomDateTime> createState() => _CustomDateTimeState();
// }

// class _CustomDateTimeState extends State<CustomDateTime> {




//   @override
//   void dispose() {
//     widget.textEditingController!.dispose();
//     super.dispose();
//   }

//   Future<void> _selectTime(BuildContext context) async {
//     DateTime? pickedDate = await showDatePicker(
//         context: context,
//         initialDate: DateTime.now(),
//         firstDate: DateTime(
//             2000), //DateTime.now() - not to allow to choose before today.
//         lastDate: DateTime(2101));
//     setState(() {
//       widget.dateTime = pickedDate;
//     });
//     if (pickedDate != null) {
//       print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
//       String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
//       print(
//           formattedDate); //formatted date output using intl package =>  2021-03-16
//       //you can implement different kind of Date Format here according to your requirement

//       setState(() {
//         widget.textEditingController!.text =
//             formattedDate; //set output date to TextField value.
//       });
//     } else {
//       print("Date is not selected");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (widget.showLabel) ...[
//           Text(
//             widget.label,
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           const SizedBox(height: 12.0),
//         ],
//         TextFormField(
//           controller: widget.textEditingController,
//           onTap: () => _selectTime(context),
//           readOnly: true,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(16.0),
//               borderSide: const BorderSide(color: Colors.grey),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(16.0),
//               borderSide: const BorderSide(color: Colors.grey),
//             ),
//             prefixIcon: Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Assets.icons.calendar.svg(),
//             ),
//             hintText: widget.initialDate != null
//                 ? selectedDate.toFormattedDate()
//                 : widget.label,
//           ),
//         ),
//       ],
//     );
//   }
// }
