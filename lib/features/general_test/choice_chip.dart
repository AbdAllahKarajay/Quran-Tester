import 'package:flutter/material.dart';

class MyChoiceChips extends StatelessWidget {
  final int startPoint;
  final int selected;
  final int endPoint;
  final Color color;
  final Function(int) whenSelect;

  const MyChoiceChips({
    super.key,
    required this.color,
    required this.whenSelect,
    this.startPoint = 1,
    this.endPoint = 30,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    int length = endPoint - startPoint + 1;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        height: 50,
        child: Center(
          child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: length * 2 + 1,
              itemBuilder: (context, index) {
                if (index.isEven) return const SizedBox(width: 5);
                int number = index ~/ 2 + startPoint;
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
                    selected: selected == number,
                    backgroundColor: color,
                    selectedColor: color.withOpacity(0.4),
                    onSelected: (value) {
                      whenSelect(number);
                    },
                  ),
                );
              }),
        ),
      ),
    );
  }
}
