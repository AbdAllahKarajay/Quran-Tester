import 'dart:io';

import 'package:flutter/material.dart';

import 'main.dart';

class MyChoiceChips extends StatefulWidget {
  SelectedStart? start;

  MyChoiceChips(
      {super.key,
      required this.count,
      required this.color,
      func,
      required this.notifyParent,
      this.start});

  final int count;
  final Color color;
  final Function(int) notifyParent;

  @override
  State<MyChoiceChips> createState() => _MyChoiceChipsState();
}

class _MyChoiceChipsState extends State<MyChoiceChips> {
  int _indexSelected = 1;

  @override
  Widget build(BuildContext context) {
    if (widget.start != null) {
      widget.start?.addListener(() => setState(() {}), ['tst']);
    }
    int length = widget.start == null
        ? widget.count
        : widget.count - widget.start!.selected + 1;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        height: 50,
        child: Center(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              // shrinkWrap: true,
              itemCount: length * 2 + 1,
              itemBuilder: (context, index) {
                if (index.isEven) return const SizedBox(width: 5);
                int number = index ~/ 2 +
                    (widget.start != null ? widget.start!.selected : 1);
                return SizedBox(
                  width: 35,
                  child: ChoiceChip(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    label: Builder(
                      builder: (context) {
                        return SizedBox(
                            width: 35,
                            height: 35,
                            child: Center(
                                child: Text(
                              '$number',
                              style: const TextStyle(color: Colors.white),
                            )));
                      },
                    ),
                    selected: _indexSelected == number,
                    backgroundColor: widget.color,
                    // shadowColor: Colors.greenAccent.shade400,
                    selectedColor: widget.color.withOpacity(0.4),
                    onSelected: (value) {
                      if (_indexSelected != number) {
                        setState(() {
                          _indexSelected = number;
                        });
                        widget.notifyParent(number);
                      }
                    },
                  ),
                );
              }),
        ),
      ),
    );
  }
}
