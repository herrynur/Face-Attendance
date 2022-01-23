import 'package:flutter/material.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:face_net_authentication/sqlite/sql_helper.dart';
import 'package:intl/intl.dart';

class Createxcel extends StatefulWidget {
  @override
  _CreatexcelState createState() => _CreatexcelState();
}

class _CreatexcelState extends State<Createxcel> {
  List<Map<String, dynamic>> _journals = [];
  List<Map<String, dynamic>> _jam = [];
  List<Map<String, dynamic>> _date = [];

  bool _isLoading = true;
  String jam = "";
  String tanggal = "";
  String tanggalnama = "";

  void _refreshJournals() async {
    final data = await SQLHelper.getItemsName();
    final jam_ = await SQLHelper.getItemsjam();
    final date_ = await SQLHelper.getItemsDate();

    setState(() {
      _journals = data;
      _jam = jam_;
      _date = date_;
      _isLoading = false;
      jam = DateFormat('kk:mm:ss').format(DateTime.now());
      tanggal = DateFormat('d/M/y').format(DateTime.now());
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals();
  }

  Future<void> _createExcel() async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    sheet.getRangeByName('A1').setText('Hello World!');
    final List<int> list = workbook.saveAsStream();
    workbook.dispose();
    final directory = await getExternalStorageDirectory();
    final path = directory?.path;
    File file = File('$path/Output.xlsx');
    await file.writeAsBytes(list, flush: true);
    OpenFile.open('$path/Output.xlsx');
  }

  Future<void> _createExcelist() async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    sheet.getRangeByName('A1').setText('Nama');
    sheet.getRangeByName('B1').setText('Jam Masuk');
    sheet.getRangeByName('C1').setText('Tanggal');
    final int firstRow = 2;
    final int firstColumn = 1;
    final bool isVertical = true;
    //--
    final int firstRow1 = 2;
    final int firstColumn1 = 2;
    //--
    final int firstRow2 = 2;
    final int firstColumn2 = 3;
    //--
    sheet.importList(_journals, firstRow, firstColumn, isVertical);
    sheet.importList(_jam, firstRow1, firstColumn1, isVertical);
    sheet.importList(_date, firstRow2, firstColumn2, isVertical);
    sheet.autoFitColumn(1);
    final directory = await getExternalStorageDirectory();
    final path = directory?.path;
    final List<int> bytes = workbook.saveAsStream();
    File('$path/dataexcel.xlsx').writeAsBytes(bytes);
    workbook.dispose();
    OpenFile.open('$path/dataexcel.xlsx');
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.file_download),
      onPressed: () {
        _refreshJournals();
        _createExcelist();
      },
    );
  }
}
