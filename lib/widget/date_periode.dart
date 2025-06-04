import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class TextFieldDate extends StatefulWidget {
  String? label;
  TextEditingController? periode;

  TextFieldDate({this.periode, this.label});

  @override
  State<TextFieldDate> createState() => _TextFieldDateState();
}

class _TextFieldDateState extends State<TextFieldDate> {
  @override
  void initState() {
    DateTime? currentDate = DateTime.now();
    String formattedDate = DateFormat('yyyyMM').format(currentDate);
    widget.periode?.text = formattedDate;
    super.initState();
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system
        // navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
        keyboardType: TextInputType.number,
        controller: widget.periode,
        decoration: InputDecoration(
          prefixIcon: InkWell(
              onTap: () async {
                _showDialog(
                  CupertinoDatePicker(
                    dateOrder: DatePickerDateOrder.mdy,
                    mode: CupertinoDatePickerMode.monthYear,
                    // This is called when the user changes the date.
                    onDateTimeChanged: (DateTime newDate) {
                      setState(() {
                        widget.periode?.text =
                            DateFormat('yyyyMM').format(newDate);
                      });
                    },
                  ),
                );
              },
              child: const Icon(
                Icons.date_range,
                color: Colors.blue,
              )),
          label: Text(
            '${widget.label}',
            style: TextStyle(fontSize: 13),
          ),
          enabledBorder: const OutlineInputBorder(
              //Outline border type for TextFeild
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1,
              )),
          focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(
                color: Colors.blue,
                width: 1,
              )),
        ));
  }
}

class _DatePickerItem extends StatelessWidget {
  const _DatePickerItem({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: CupertinoColors.inactiveGray,
            width: 0.0,
          ),
          bottom: BorderSide(
            color: CupertinoColors.inactiveGray,
            width: 0.0,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children,
        ),
      ),
    );
  }
}



// DateTime currentDate = DateTime.now();
//                 DateTime? pickedDate = await showMonthPicker(
//                   context: context,
                  
//                   initialDate:
//                       currentDate, // Tanggal awal yang muncul saat membuka picker
//                   firstDate: DateTime(2000,
//                       1), // Tanggal pertama yang bisa dipilih (misalnya, 1 Januari 2000)
//                   lastDate:
//                       currentDate, // Tanggal terakhir yang bisa dipilih (misalnya, hari ini)
//                 );
//                 if (pickedDate != null) {
//                   setState(() {
//                     widget.periode?.text =
//                         DateFormat('yyyyMM').format(pickedDate);
//                   });
//                 }
