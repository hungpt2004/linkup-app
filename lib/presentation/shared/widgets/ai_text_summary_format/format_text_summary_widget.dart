import 'package:flutter/material.dart';

Widget buildFormatSummaryText(String caption) {
  // Phân tích chuỗi và tách các phần
  String summaryTitle = "Bản tóm tắt:";
  String titleTitle = "Tiêu đề:";

  int summaryIndex = caption.indexOf(summaryTitle);
  int titleIndex = caption.indexOf(titleTitle);

  // Nếu không tìm thấy, trả về widget rỗng hoặc thông báo
  if (summaryIndex == -1 || titleIndex == -1 || titleIndex <= summaryIndex) {
    return const Text('Không có dữ liệu tóm tắt hợp lệ');
  }

  summaryIndex += summaryTitle.length;

  String summaryContent = caption.substring(summaryIndex, titleIndex).trim();
  String titleContent =
      caption.substring(titleIndex + titleTitle.length).trim();

  summaryContent = summaryContent.replaceAll('**', '').trim();
  titleContent = titleContent.replaceAll('**', '').replaceAll('"', '').trim();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Bản tóm tắt:',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      SizedBox(height: 8),
      Text(summaryContent, style: TextStyle(fontSize: 14)),
      SizedBox(height: 16),
      Text(
        'Tiêu đề:',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      SizedBox(height: 8),
      Text(
        titleContent,
        style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
      ),
    ],
  );
}
