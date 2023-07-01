import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ExpandableTextWidget extends StatefulWidget {
  final String text;
  final double height;

  const ExpandableTextWidget({
    Key? key,
    required this.text,
    required this.height,
  }) : super(key: key);

  @override
  State<ExpandableTextWidget> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableTextWidget> {
  bool hiddenText = true;
  late String firstHalf;
  late String secondHalf;

  @override
  void initState() {
    super.initState();
    double textHeight = widget.height * 1.5;
    int textHeightInt = textHeight.toInt();
    if (widget.text.length > textHeight) {
      firstHalf = widget.text.substring(0, textHeightInt);
      secondHalf =
          widget.text.substring(textHeightInt + 1, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: secondHalf.isEmpty
          ? Text(
              firstHalf,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            )
          : Column(
              children: [
                Text(
                  hiddenText ? "$firstHalf..." : firstHalf + secondHalf,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      hiddenText = !hiddenText;
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        hiddenText ? "see-more-label".tr() : "see-less-label".tr(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        hiddenText
                            ? Icons.arrow_drop_down
                            : Icons.arrow_drop_up,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
