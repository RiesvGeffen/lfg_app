import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ModalPickerWidget extends StatefulWidget {
  final Function(int) onChange;
  final String title;
  final List values;
  final int initialValue;

  const ModalPickerWidget(
      {Key key, this.title, this.values, this.onChange, this.initialValue})
      : super(key: key);

  @override
  ModalPickerWidgetState createState() => ModalPickerWidgetState();
}

class ModalPickerWidgetState extends State<ModalPickerWidget> {
  @override
  void initState() {
    super.initState();
    if (widget.initialValue == -1) {
      widget.onChange(0);
    }
  }

  Widget picker() {
    return CupertinoPicker(
      scrollController: FixedExtentScrollController(
          initialItem: widget.initialValue == -1 ? 0 : widget.initialValue),
      magnification: 1.1,
      onSelectedItemChanged: (value) {
        widget.onChange(value);
      },
      children: widget.values
          .map((value) => Text(
                value.toString(),
                style: TextStyle(color: Colors.white),
              ))
          .toList(),
      itemExtent: 28,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 20),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Center(
                          child: picker(),
                        )),
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
