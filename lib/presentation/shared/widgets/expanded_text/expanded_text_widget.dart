import 'package:flutter/material.dart';

class ExpandableRichText extends StatefulWidget {
  final Widget richTextWidget;
  final String text; // Thêm text vào để đo chiều dài
  final int maxLines;

  const ExpandableRichText({
    super.key,
    required this.richTextWidget,
    required this.text,
    this.maxLines = 2,
  });

  @override
  _ExpandableRichTextState createState() => _ExpandableRichTextState();
}

class _ExpandableRichTextState extends State<ExpandableRichText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // Để kiểm tra xem văn bản có bị tràn dòng hay không, chúng ta có thể sử dụng layoutBuilder
    // hoặc TextPainter như ví dụ trước.
    // Cách dưới đây là sử dụng LayoutBuilder để đảm bảo kích thước widget cha đã được xác định.
    return LayoutBuilder(
      builder: (context, size) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: widget.text,
            style: DefaultTextStyle.of(context).style,
          ),
          maxLines: widget.maxLines,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: size.maxWidth);

        final bool isOverflowed = textPainter.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Widget RichText của bạn
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              child: ConstrainedBox(
                constraints:
                    _isExpanded
                        ? const BoxConstraints()
                        : BoxConstraints(
                          maxHeight: textPainter.size.height,
                        ), // Giới hạn chiều cao
                child: widget.richTextWidget,
              ),
            ),

            // Nút "Read more/Read less"
            if (isOverflowed)
              InkWell(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Text(
                  _isExpanded ? '...Read less' : '...Read more',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
          ],
        );
      },
    );
  }
}
