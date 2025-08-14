import 'package:flutter/material.dart';
import 'package:foodie_delivery/constants/app_colors.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int trimLength;

  const ExpandableText({super.key, required this.text, this.trimLength = 40});

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final displayText = _isExpanded || widget.text.length <= widget.trimLength
        ? widget.text
        : widget.text.substring(0, widget.trimLength) + '...';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(displayText, style: const TextStyle(color: AppColors.primary)),
        if (widget.text.length > widget.trimLength)
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Text(
              _isExpanded ? 'Read less' : 'Read more',
              style: const TextStyle(
                color: AppColors.textGray,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}
