import 'dart:convert';
import 'dart:io';

import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:venushr_10_dipo_mobile/core/components/styles.dart';
import 'package:venushr_10_dipo_mobile/core/core.dart';
import '../../../core/assets/assets.gen.dart';
import '../../../core/components/custom_date_picker.dart';
import '../../../core/components/spaces.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/variables.dart';
import '../../../data/datasource/auth_local_datasource.dart';

class ReportAttendanceLog extends StatefulWidget {
  const ReportAttendanceLog({super.key});

  @override
  State<ReportAttendanceLog> createState() => _ReportAttendanceLogState();
}

class _ReportAttendanceLogState extends State<ReportAttendanceLog> {
  List<dynamic> listReport = [];
  TextEditingController? fromController = new TextEditingController();
  TextEditingController? toController = new TextEditingController();
  bool? isLoading = false;
  String? getEmployeeName;
  String? getEmployeeID;

  btnSearch() async {
    try {
      setState(() {
        isLoading = true;
      });
      print(
          "is after : ${DateFormat('yyyy-MM-dd').parse(toController!.text..toString()).isAfter(DateFormat('yyyy-MM-dd').parse(fromController!.text))}");
      if (DateFormat('yyyy-MM-dd')
          .parse(fromController!.text.toString())
          .isAfter(
              DateFormat('yyyy-MM-dd').parse(toController!.text.toString()))) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(
              seconds: 2,
            ),
            content: Text("From Date harus lebih kecil dari pada To Date"),
            backgroundColor: AppColors.red,
          ),
        );
        setState(() {
          isLoading = false;
        });
      } else {
        final getUser = await AuthLocalDatasource().getAuthData();
        final response = await http.get(Uri.parse(
            "${Variables.baseUrl}/getListAttendanceLog/${getUser?.employeeID}/${fromController!.text}/${toController!.text}"));
        if (response.statusCode == 200) {
          setState(() {
            isLoading = false;
            listReport = List.from(jsonDecode(response.body));
            getEmployeeName = getUser!.userId;
            getEmployeeID = getUser.employeeID;
          });
        }
      }
    } catch (e) {
      print("Error get Attendance Log : ${e}");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> requestStoragePermission() async {
    setState(() {
      isLoading = true;
    });
    if (await Permission.storage.request().isGranted) {
      print("Izin diberikan");
      generatePDF();
    } else if (await Permission.storage.isPermanentlyDenied) {
      setState(() {
        isLoading = false;
      });

      openAppSettings();
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Storage permission not granted"),
          backgroundColor: AppColors.red,
        ),
      );
    }
  }

  pw.Widget buildPdfTable(List<dynamic> listReport) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      columnWidths: {
        0: pw.FlexColumnWidth(2),
        1: pw.FlexColumnWidth(2),
        2: pw.FlexColumnWidth(3),
        3: pw.FlexColumnWidth(2),
        4: pw.FlexColumnWidth(3),
      },
      children: [
        // Header
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.blue50),
          children: [
            pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Text('Date',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
            pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Text('Check In',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
            pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Text('Loc In',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
            pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Text('Check Out',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
            pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Text('Loc Out',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
          ],
        ),
        // Data Rows
        ...listReport.map((entry) {
          return pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Text(
                    '${DateFormat('MM/dd/yyyy').parse('${entry['TADate']}').toFormattedDate()}'),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Text('${entry['CheckIn'] ?? '-'}'),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Text('${entry['CheckInLoc'] ?? '-'}'),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Text('${entry['CheckOut'] ?? '-'}'),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Text('${entry['CheckOutLoc'] ?? '-'}'),
              ),
            ],
          );
        }).toList(),
      ],
    );
  }

  generatePDF() async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) => [
                  pw.Text(
                    "Attendance Report",
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(
                    "(${DateFormat('yyyy-MM-dd').format(DateTime.parse(fromController!.text))} - ${DateFormat('yyyy-MM-dd').format(DateTime.parse(toController!.text))})",
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(
                    height: 10,
                  ),
                  pw.Divider(),
                  pw.SizedBox(
                    height: 15,
                  ),
                  buildPdfTable(listReport),
                ]),
      );
      final directory = Directory('/storage/emulated/0/Download');
      print("direcctory : ${directory.uri}");
      final path =
          "${directory.path}/Report_Attendance_${DateTime.now().millisecondsSinceEpoch}.pdf";

      final file = File(path);

      if (await file.exists()) {
        await file.delete();
      }
      await file.writeAsBytes(await pdf.save());
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Download Berhasil"),
            content: Text("PDF berhasil diunduh di:\n$path"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Tutup popup
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error print pdf : ${e}");
    }
  }

  String formatDate(DateTime date) {
    final dateFormatter = DateFormat('yyyy-MM-dd');
    return dateFormatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Report'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomDatePicker(
                    label: 'From Date',
                    onDateSelected: (selectedDate) {
                      setState(() {
                        fromController!.text = formatDate(selectedDate);
                        print("fromController!.text : ${fromController!.text}");
                      });
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  CustomDatePicker(
                    label: 'To Date',
                    onDateSelected: (selectedDate) {
                      setState(() {
                        toController!.text = formatDate(selectedDate);
                        print("toController!.text : ${toController!.text}");
                      });
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                        Colors.blue,
                      )),
                      onPressed: () {
                        btnSearch();
                      },
                      child: Text(
                        "Search",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              isLoading == true
                  ? Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Center(
                          child: loadingSpin,
                        )
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        listReport.isNotEmpty
                            ? InkWell(
                                onTap: () => requestStoragePermission(),
                                child: Container(
                                  width: 120,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(
                                              0.1), // Warna bayangan dan opasitas
                                          spreadRadius:
                                              1, // Jarak penyebaran bayangan
                                          blurRadius: 2, // Radius blur bayangan
                                          offset: Offset(0,
                                              1), // Offset (x, y) dari bayangan
                                        ),
                                      ],
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.download,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "Export PDF",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        SizedBox(
                          height: 10,
                        ),
                        listReport.isNotEmpty
                            ? Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color.fromARGB(122, 158, 158,
                                          158), // Warna abu-abu untuk border
                                      width: 1.0, // Lebar border
                                    ),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "Date",
                                              style: GoogleFonts.lato(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              "Check In",
                                              style: GoogleFonts.lato(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              "Loc In",
                                              style: GoogleFonts.lato(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              "Check Out",
                                              style: GoogleFonts.lato(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              "Loc Out",
                                              style: GoogleFonts.lato(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(),
                                        ],
                                      ),
                                      Divider(),
                                      Column(
                                          children: listReport.map((e) {
                                        return Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    child: Text(
                                                      "${e['TADate']}",
                                                      style: GoogleFonts.lato(
                                                        fontSize: 9,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    child: Text(
                                                      "${e['CheckIn'] ?? '-'}",
                                                      style: GoogleFonts.lato(
                                                        fontSize: 9,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    width: 50,
                                                    child: Text(
                                                      "${e['CheckInLoc'] ?? '-'}",
                                                      maxLines: 50,
                                                      style: GoogleFonts.lato(
                                                        fontSize: 9,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    child: Text(
                                                      "${e['CheckOut'] ?? '-'}",
                                                      style: GoogleFonts.lato(
                                                        fontSize: 9,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    width: 70,
                                                    child: Text(
                                                      "${e['CheckOutLoc'] ?? '-'}",
                                                      maxLines: 20,
                                                      style: GoogleFonts.lato(
                                                        fontSize: 9,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Divider(),
                                          ],
                                        );
                                      }).toList())
                                    ],
                                  ),
                                ),
                              )
                            : Stack(),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
