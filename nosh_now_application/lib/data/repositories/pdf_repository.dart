import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:nosh_now_application/data/models/top_food.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

class PdfRepository {
  static Future<File?> saveDocument({
    required String name,
    required pw.Document pdf,
  }) async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      final bytes = await pdf.save();
      final dir = await getApplicationDocumentsDirectory();

      final file = await File('${dir.path}/$name').create(recursive: true);
      await file.writeAsBytes(bytes);
      return file;
    }
    return null;
  }

  static Future openFile(File file) async {
    final url = file.path;
    await OpenFile.open(url);
  }

  static Future<File?> generateMerchantStatistics(String title, double revenue,
      int totalOrders, List<TopFood> topFoods) async {
    final font = await rootBundle.load("assets/fonts/Roboto-Medium.ttf");
    final roboto = pw.Font.ttf(font);
    final pdf = pw.Document();
    pdf.addPage(MultiPage(
      build: (context) => [
        buildTitle(title, totalOrders, revenue, roboto),
        buildTopFood(topFoods, roboto),
      ],
      footer: (context) => SizedBox(height: 0),
    ));
    print('generate successful');
    return saveDocument(name: 'statistics-$title.pdf', pdf: pdf);
  }

  static Widget buildTitle(
          String title, int totalOrders, double revenue, Font font) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'STATISTICS $title',
            style: TextStyle(fontSize: 22, font: font),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          Row(children: [
            Text("Total orders: ", style: TextStyle(fontSize: 16, font: font)),
            Text(NumberFormat.currency(locale: 'vi_VN').format(totalOrders),
                style: TextStyle(fontSize: 16, font: font)),
          ]),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          Row(children: [
            Text(
              "Revenue: ",
              style: TextStyle(
                fontSize: 16,
                font: font,
              ),
            ),
            Text(
              NumberFormat.currency(locale: 'vi_VN', symbol: 'VND')
                  .format(revenue),
              style: TextStyle(
                fontSize: 16,
                font: font,
              ),
            ),
          ]),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          Text(
            'TOP 5 FOOD $title',
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, font: font),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildTopFood(List<TopFood> foodData, Font font) {
    final headers = [
      'No',
      'Food name',
      'Quantity',
      'Total',
    ];
    int no = 1;
    final data = foodData.map((item) {
      return [
        no++,
        item.foodName,
        item.quantity,
        NumberFormat.currency(locale: 'vi_VN', symbol: 'VND')
            .format(item.revenue)
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold, font: font),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
      },
    );
  }
}
