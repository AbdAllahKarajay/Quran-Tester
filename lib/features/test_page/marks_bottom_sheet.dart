import 'package:flutter/material.dart';
import 'package:quran/surah_data.dart';
import 'package:quran_tester/services/excel_services.dart';
import 'package:quran_tester/features/test_page/test_page.dart';

class MarksBottomSheet extends StatefulWidget {
  const MarksBottomSheet(
      {Key? key, this.isResult = false, required this.start, required this.end, this.isRandom = true})
      : super(key: key);
  final bool isRandom;
  final bool isResult;
  final int start;
  final int end;

  @override
  State<MarksBottomSheet> createState() => _MarksBottomSheetState();
}

class _MarksBottomSheetState extends State<MarksBottomSheet> {
  _MarksBottomSheetState();

  int questionCount = TestPage.questionNumber;
  List questions = TestPage.questions;

  final hesitation = 1;
  final correction = 4;
  final hesitationT = 3;
  final correctionT = 10;
  final taj = 1;

  late final List<double> cellsWidthEdit;
  final List<double> cellsWidthView = [60, 50, 30, 173, 30, 30, 55, 50, 35];

  @override
  void initState() {
    super.initState();
    cellsWidthEdit = (widget.isRandom)?
    [30, 50, 50, 60, 60, 40, 40, 40, 40]:
    [30, 50, 50, 60, 60, 50, 50, 50, 50];

  }

  bool isExcelSaved = false;


  @override
  Widget build(BuildContext context) {
    questionCount = TestPage.questionNumber;
    questions = TestPage.questions;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          if (widget.isResult)
            const SizedBox(
              height: 20,
            ),
          SizedBox(
            height: (widget.isResult)
                ? 50
                : 40,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'العلامة: ${TestPage.mark}',
                      style: const TextStyle(
                          fontSize:20,
                          color: Colors.brown,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    TestPage.name,
                    style: const TextStyle(fontSize: 18),
                  ),
                )
              ],
            ),
          ),
          const Divider(
            color: Colors.brown,
            thickness: 0.5,
            height: 1,
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: (widget.isResult)? const BouncingScrollPhysics():const NeverScrollableScrollPhysics(),
              child: SizedBox(
                width: (!widget.isResult)
                    ? MediaQuery.of(context).size.width :570,
                child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    scrollDirection: Axis.vertical,
                    itemCount: (widget.isResult) ? questionCount * 2 + 2 :(questionCount == 0)? 2:4,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return SizedBox(
                          height: (widget.isResult)
                              ? 40
                                  : 55,
                          child: Row(children: [
                            if(widget.isRandom && !widget.isResult)
                              const IconButton(onPressed: null, icon: Icon(Icons.remove, color: Colors.transparent,)),
                            if(!widget.isResult && widget.isRandom)
                              const SizedBox(width: 10),if(widget.isResult)
                            const SizedBox(width: 6),
                            if(widget.isResult)
                              SizedBox(
                                width: (!widget.isResult)
                                    ? cellsWidthEdit[0]
                                    : cellsWidthView[0],
                                child: const Text(
                                  'رقم السؤال',
                                  style: TextStyle(
                                      color: Colors.brown,
                                      fontSize: 15),
                                )),
                            if(!widget.isRandom)
                              SizedBox(
                              width: (widget.isResult)
                                  ? 14
                                      :5,
                          ),
                            if(widget.isResult)
                              SizedBox(
                                width: (!widget.isResult)
                                    ? cellsWidthEdit[1]
                                    : cellsWidthView[1],
                                child: Text(
                                  'السورة',
                                  style: TextStyle(
                                      color: Colors.brown,
                                      fontSize: (widget.isResult)
                                          ? 15: 17,
                                ))),
                            if(widget.isResult)
                            SizedBox(
                              width: (widget.isResult)
                                  ? 8:15,
                            ),
                            if(widget.isResult)
                            SizedBox(
                                width: (widget.isResult)
                                    ? cellsWidthEdit[2]
                                    : cellsWidthView[2],
                                child: Text(
                                  'الآية',
                                  style: TextStyle(
                                      color: Colors.brown,
                                      fontSize: (widget.isResult)
                                          ? 15 : 17),
                                )),
                            if(widget.isResult)
                            SizedBox(
                              width: (widget.isResult)
                                  ? 0
                                  : 20,
                            ),
                            if(widget.isResult)
                              SizedBox(
                                width: cellsWidthEdit[3] + 40,
                                child: Text(
                                  'السؤال',
                                  style: TextStyle(
                                      color: Colors.brown,
                                      fontSize: (widget.isResult)
                                          ? 15
                                          : 17),
                                )),
                            if(widget.isResult)
                              SizedBox(
                              width: (widget.isResult)
                                  ? 8
                                  : 27,
                            ),
                            SizedBox(
                                width: (!widget.isResult)
                                    ? cellsWidthEdit[4]
                                    : cellsWidthView[4],
                                child: Text(
                                  'تلكؤ',
                                  style: TextStyle(
                                      color: Colors.brown,
                                      fontSize: (widget.isResult)
                                          ? 15
                                          : 17),
                                )),
                            SizedBox(
                              width: (widget.isResult)
                                  ? 8
                                  : 4,
                            ),
                            SizedBox(
                                width: (!widget.isResult)
                                    ? cellsWidthEdit[5]
                                    : cellsWidthView[5],
                                child: Text(
                                  'ردة',
                                  style: TextStyle(
                                      color: Colors.brown,
                                      fontSize: (widget.isResult)
                                          ? 15
                                          : 17),
                                )),
                            SizedBox(
                              width: (widget.isResult)
                                  ? 8
                                  : 20,
                            ),
                            SizedBox(
                                width: (!widget.isResult)
                                    ? cellsWidthEdit[6]
                                    : cellsWidthView[6],
                                child: Text(
                                  'تلكؤ تشكيل',
                                  style: TextStyle(
                                      color: Colors.brown,
                                      fontSize: (widget.isResult)
                                          ? 13
                                          : 17),
                                )),
                            SizedBox(
                              width: (widget.isResult)
                                  ? 8
                                  : 20,
                            ),
                            SizedBox(
                                width: (!widget.isResult)
                                    ? cellsWidthEdit[7]
                                    : cellsWidthView[7],
                                child: Text(
                                  'ردة تشكيل',
                                  style: TextStyle(
                                      color: Colors.brown,
                                      fontSize: (widget.isResult)
                                          ? 13
                                          : 17),
                                )),
                            SizedBox(
                              width: (widget.isResult)
                                  ? 8
                                  : 19,
                            ),
                            SizedBox(
                                width: (!widget.isResult)
                                    ? cellsWidthEdit[8]
                                    : cellsWidthView[8],
                                child: Text(
                                  'تجويد',
                                  style: TextStyle(
                                      color: Colors.brown,
                                      fontSize: (widget.isResult)
                                          ? 14
                                          : 17),
                                )),
                            const SizedBox(
                              width: 12,
                            ),
                          ]),
                        );
                      }
                      if (index == questionCount * 2 + 1 || !widget.isResult && index == 3) {
                        if (widget.isResult) {
                          return SizedBox(
                            height: 50.0 * TestPage.notes.length + 100,
                            child: Column(
                              children: List.generate(
                                  TestPage.notes.length + 1, (index) {
                                if (index == 0) {
                                  return SizedBox(
                                    height: 50,
                                    child: Column(
                                      children: const [
                                        Divider(
                                          thickness: 0.5,
                                        ),
                                        Center(
                                          child: Text('الملاحظات'),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                return Row(
                                  children: [
                                    Text('ملاحظة $index'),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: SizedBox(
                                            height: 50,
                                            child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(TestPage
                                                    .notes[index - 1])))),
                                  ],
                                );
                              }).toList(),
                            ),
                          );
                        }
                        return SizedBox(
                          height: 55.0 * TestPage.notes.length + 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                                TestPage.notes.length + 1, (index) {
                              if (index == 0){
                                return Padding(
                                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                          onPressed: () {
                                            String note = '';
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Dialog(
                                                    child:
                                                        SingleChildScrollView(
                                                      child: SizedBox(
                                                        height: 250,
                                                        child: Stack(
                                                          children: [
                                                            Align(
                                                              alignment:
                                                                  Alignment
                                                                      .bottomCenter,
                                                              child:
                                                                  Padding(
                                                                padding:
                                                                    const EdgeInsets.all(8.0),
                                                                child: ElevatedButton(
                                                                    onPressed: () {
                                                                      TestPage.notes.add(note);
                                                                      Navigator.of(context).pop();
                                                                      setState(() {});
                                                                    },
                                                                    child: const Text('تم')),
                                                              ),
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  Alignment
                                                                      .bottomLeft,
                                                              child:
                                                                  Padding(
                                                                padding:
                                                                    const EdgeInsets.all(8.0),
                                                                child: ElevatedButton(
                                                                    onPressed: () {
                                                                      Navigator.of(context).pop();
                                                                    },
                                                                    child: const Text('الغاء')),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets.all(
                                                                      8.0),
                                                              child:
                                                                  Center(
                                                                child:
                                                                    TextField(
                                                                  decoration:
                                                                      InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                                                                  textAlign:
                                                                      TextAlign.center,
                                                                  textAlignVertical:
                                                                      TextAlignVertical.center,
                                                                  onSubmitted:
                                                                      (value) {
                                                                    TestPage.notes.add(note);
                                                                    Navigator.of(context).pop();
                                                                    setState(() {});
                                                                  },
                                                                  onChanged: (value) =>
                                                                      note = value,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                });
                                          },
                                          child: const Text(
                                              'اضافة ملاحظة')),
                                      ElevatedButton(
                                          onPressed: () => (!widget.isResult)
                                              ? Navigator.of(context)
                                              .push(MaterialPageRoute(
                                              builder: (context) => Scaffold(
                                                body: MarksBottomSheet(
                                                  isResult: true,
                                                  start: widget.start,
                                                  end: widget.end,
                                                ),
                                              )))
                                              : Navigator.of(context).pop(),
                                          child: Text((widget.isResult) ? 'تعديل' : 'عرض'))
                                    ],
                                  ),
                                );
                              }
                              return Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 7.0),
                                    child: IconButton(
                                      onPressed: () {
                                        TestPage.notes.remove(
                                            TestPage.notes[index - 1]);
                                        setState(() {});
                                      },
                                      icon: const Icon(
                                          Icons.remove_circle_outline),
                                      color: Colors.red,
                                    ),
                                  ),
                                  Text('ملاحظة $index'),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: SizedBox(
                                          height: 50,
                                          child: Align(
                                              alignment:
                                                  Alignment.centerRight,
                                              child: Text(TestPage
                                                  .notes[index - 1])))),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        );
                      }
                      if (index % 2 != 0) {
                        return const Divider(
                          thickness: 0.5,
                        );
                      }
                      if (!widget.isResult)index = questionCount * 2;
                      return SizedBox(
                        height: (widget.isResult)
                            ? 24
                            : 66,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if(widget.isResult)
                              const SizedBox(width:20),
                            if (!widget.isResult && widget.isRandom)
                              IconButton(
                                onPressed: () {
                                  TestPage.questionNumber--;
                                  questionCount--;
                                  TestPage.questions
                                      .removeAt(index ~/ 2 - 1);
                                  TestPage.mark += hesitation *
                                      TestPage.faults[index ~/ 2 - 1][0];
                                  TestPage.mark += correction *
                                      TestPage.faults[index ~/ 2 - 1][1];
                                  TestPage.mark += hesitationT *
                                      TestPage.faults[index ~/ 2 - 1][2];
                                  TestPage.mark += correctionT *
                                      TestPage.faults[index ~/ 2 - 1][3];
                                  TestPage.mark += taj *
                                      TestPage.faults[index ~/ 2 - 1][4];
                                  TestPage.faults
                                      .removeAt(index ~/ 2 - 1);
                                  setState(() {});
                                },
                                icon: const Icon(
                                    Icons.remove_circle_outline),
                                color: Colors.red,
                              ),
                            if(!widget.isResult && widget.isRandom)
                              const SizedBox(width: 10),
                            if(widget.isResult)
                              SizedBox(
                                width: (!widget.isResult)
                                    ? cellsWidthEdit[0]
                                    : cellsWidthView[0],
                                child: Text(
                                  '${index ~/ 2}',
                                  style: TextStyle(
                                      color: Colors.brown,
                                      fontSize: (widget.isResult)
                                          ? 15
                                          : MediaQuery.of(context).size.height*0.025),
                                )),
                            if(widget.isResult)
                              SizedBox(
                                width: (!widget.isResult)
                                    ? cellsWidthEdit[1]
                                    : cellsWidthView[1],
                                child: Text(
                                  '${surah[questions[index ~/ 2 -1]['surah_number'] - 1]['arabic']}',
                                  style: TextStyle(
                                      color: Colors.brown,
                                      fontSize: (widget.isResult)
                                          ? 15
                                          : 17),
                            )),
                            if(widget.isResult)
                              const SizedBox(
                            width:8,
                          ),
                            if(widget.isResult)
                              SizedBox(
                                width: (!widget.isResult)
                                    ? cellsWidthEdit[2]
                                    : cellsWidthView[2],
                                child: Text(
                                  '${questions[index ~/ 2 - 1]['verse_number']}',
                                  style: TextStyle(
                                      color: Colors.brown,
                                      fontSize: (widget.isResult)
                                          ? 15
                                          : 17),
                                )),
                            if(widget.isResult)
                              SizedBox(
                              width: (widget.isResult)
                                  ? 8
                                  : 12,
                            ),
                            if(widget.isResult)
                              SizedBox(
                                width: cellsWidthEdit[3] + 40,
                                child: Text(
                                  '${questions[index ~/ 2 - 1]['content'].substring(
                                    0,
                                    (questions[index ~/ 2 - 1]['content']
                                                .length >
                                            40)
                                        ? 40
                                        : questions[index ~/ 2 - 1]
                                                ['content']
                                            .length,
                                  )}',
                                  style: const TextStyle(
                                      color: Colors.brown,
                                      fontSize: 12),
                                )), //سؤال
                            if(widget.isResult)
                              SizedBox(
                              width: (widget.isResult)
                                  ? 12
                                  : 17,
                            ),
                            SizedBox(
                                width: (!widget.isResult)
                                    ? cellsWidthEdit[4]
                                    : cellsWidthView[4],
                                child: Row(
                                  mainAxisAlignment: (widget.isResult)
                                      ? MainAxisAlignment.center
                                      : MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    if (!widget.isResult)
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                              width: 30,
                                              height: 30,
                                              child: IconButton(
                                                onPressed: () =>
                                                    setState(() {
                                                  TestPage.mark -=
                                                      hesitation;
                                                  TestPage.faults[
                                                          index ~/ 2 - 1]
                                                      [0]++;
                                                }),
                                                icon: const Icon(
                                                  Icons.add_circle,
                                                  size: 26,
                                                ),
                                                color: Colors.brown,
                                              )),
                                          const SizedBox(
                                            height: 6,
                                          ),
                                          SizedBox(
                                              width: 30,
                                              height: 30,
                                              child: IconButton(
                                                onPressed: () =>
                                                    setState(() {
                                                  if (TestPage.faults[
                                                          index ~/ 2 -
                                                              1][0] >
                                                      0) {
                                                    TestPage.mark +=
                                                        hesitation;
                                                    TestPage.faults[
                                                        index ~/ 2 -
                                                            1][0]--;
                                                  }
                                                }),
                                                icon: const Icon(
                                                  Icons.remove_circle,
                                                  size: 25,
                                                ),
                                                color: Colors.brown,
                                              )),
                                        ],
                                      ),
                                    Text(
                                      '${TestPage.faults[index ~/ 2 - 1][0]}',
                                      style: TextStyle(
                                          color: Colors.brown,
                                          fontSize: (widget.isResult)
                                              ? 15
                                              : 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )), //تلكؤ
                            SizedBox(
                              width: (widget.isResult)
                                  ? 12
                                  : 5,
                            ),
                            SizedBox(
                                width: (!widget.isResult)
                                    ? cellsWidthEdit[5]
                                    : cellsWidthView[5],
                                child: Row(
                                  mainAxisAlignment: (widget.isResult)
                                      ? MainAxisAlignment.center
                                      : MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    if (!widget.isResult)
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                              width: 30,
                                              height: 30,
                                              child: IconButton(
                                                onPressed: () =>
                                                    setState(() {
                                                  TestPage.mark -=
                                                      correction;
                                                  TestPage.faults[
                                                          index ~/ 2 - 1]
                                                      [1]++;
                                                }),
                                                icon: const Icon(
                                                  Icons.add_circle,
                                                  size: 25,
                                                ),
                                                color: Colors.brown,
                                              )),
                                          const SizedBox(
                                            height: 6,
                                          ),
                                          SizedBox(
                                              width: 30,
                                              height: 30,
                                              child: IconButton(
                                                onPressed: () =>
                                                    setState(() {
                                                  if (TestPage.faults[
                                                          index ~/ 2 -
                                                              1][1] >
                                                      0) {
                                                    TestPage.mark +=
                                                        correction;
                                                    TestPage.faults[
                                                        index ~/ 2 -
                                                            1][1]--;
                                                  }
                                                }),
                                                icon: const Icon(
                                                  Icons.remove_circle,
                                                  size: 25,
                                                ),
                                                color: Colors.brown,
                                              )),
                                        ],
                                      ),
                                    Text(
                                      '${TestPage.faults[index ~/ 2 - 1][1]}',
                                      style: TextStyle(
                                          color: Colors.brown,
                                          fontSize: (widget.isResult)
                                              ? 15
                                              : 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )), //ردة
                            SizedBox(
                              width: (widget.isResult)
                                  ? 12
                                  : 20,
                            ),
                            SizedBox(
                                width: (!widget.isResult)
                                    ? cellsWidthEdit[6]
                                    : cellsWidthView[6],
                                child: Row(
                                  mainAxisAlignment: (widget.isResult)
                                      ? MainAxisAlignment.center
                                      : MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    if (!widget.isResult)
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                              width: 30,
                                              height: 30,
                                              child: IconButton(
                                                onPressed: () =>
                                                    setState(() {
                                                  TestPage.mark -=
                                                      hesitationT;
                                                  TestPage.faults[
                                                          index ~/ 2 - 1]
                                                      [2]++;
                                                }),
                                                icon: const Icon(
                                                  Icons.add_circle,
                                                  size: 25,
                                                ),
                                                color: Colors.brown,
                                              )),
                                          const SizedBox(
                                            height: 6,
                                          ),
                                          SizedBox(
                                              width: 30,
                                              height: 30,
                                              child: IconButton(
                                                onPressed: () =>
                                                    setState(() {
                                                  if (TestPage.faults[
                                                          index ~/ 2 -
                                                              1][2] >
                                                      0) {
                                                    TestPage.mark +=
                                                        hesitationT;
                                                    TestPage.faults[
                                                        index ~/ 2 -
                                                            1][2]--;
                                                  }
                                                }),
                                                icon: const Icon(
                                                  Icons.remove_circle,
                                                  size: 25,
                                                ),
                                                color: Colors.brown,
                                              )),
                                        ],
                                      ),
                                    Text(
                                      '${TestPage.faults[index ~/ 2 - 1][2]}',
                                      style: TextStyle(
                                          color: Colors.brown,
                                          fontSize: (widget.isResult)
                                              ? 15
                                              : 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )), //تلكؤ تشكيل
                            SizedBox(
                              width: (widget.isResult)
                                  ? 6
                                  : 24,
                            ),
                            SizedBox(
                                width: (!widget.isResult)
                                    ? cellsWidthEdit[7]
                                    : cellsWidthView[7],
                                child: Row(
                                  mainAxisAlignment: (widget.isResult)
                                      ? MainAxisAlignment.center
                                      : MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    if (!widget.isResult)
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                              width: 30,
                                              height: 30,
                                              child: IconButton(
                                                onPressed: () =>
                                                    setState(() {
                                                  TestPage.mark -=
                                                      correctionT;
                                                  TestPage.faults[
                                                          index ~/ 2 - 1]
                                                      [3]++;
                                                }),
                                                icon: const Icon(
                                                  Icons.add_circle,
                                                  size: 25,
                                                ),
                                                color: Colors.brown,
                                              )),
                                          const SizedBox(
                                            height: 6,
                                          ),
                                          SizedBox(
                                              width: 30,
                                              height: 30,
                                              child: IconButton(
                                                onPressed: () =>
                                                    setState(() {
                                                  if (TestPage.faults[
                                                          index ~/ 2 -
                                                              1][3] >
                                                      0) {
                                                    TestPage.mark +=
                                                        correctionT;
                                                    TestPage.faults[
                                                        index ~/ 2 -
                                                            1][3]--;
                                                  }
                                                }),
                                                icon: const Icon(
                                                  Icons.remove_circle,
                                                  size: 25,
                                                ),
                                                color: Colors.brown,
                                              )),
                                        ],
                                      ),
                                    Text(
                                      '${TestPage.faults[index ~/ 2 - 1][3]}',
                                      style: TextStyle(
                                          color: Colors.brown,
                                          fontSize: (widget.isResult)
                                              ? 15
                                              : 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )), //ردة تشكيل
                            SizedBox(
                              width: (widget.isResult)
                                  ? 6
                                  : 22,
                            ),
                            SizedBox(
                                width: (!widget.isResult)
                                    ? cellsWidthEdit[8]
                                    : cellsWidthView[8],
                                child: Row(
                                  mainAxisAlignment: (widget.isResult)
                                      ? MainAxisAlignment.center
                                      : MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    if (!widget.isResult)
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                              width: 30,
                                              height: 30,
                                              child: IconButton(
                                                onPressed: () =>
                                                    setState(() {
                                                  TestPage.mark -= taj;
                                                  TestPage.faults[
                                                          index ~/ 2 - 1]
                                                      [4]++;
                                                }),
                                                icon: const Icon(
                                                  Icons.add_circle,
                                                  size: 25,
                                                ),
                                                color: Colors.brown,
                                              )),
                                          const SizedBox(
                                            height: 6
                                          ),
                                          SizedBox(
                                              width: 30,
                                              height: 30,
                                              child: IconButton(
                                                onPressed: () =>
                                                    setState(() {
                                                  if (TestPage.faults[
                                                          index ~/ 2 -
                                                              1][4] >
                                                      0) {
                                                    TestPage.mark += taj;
                                                    TestPage.faults[
                                                        index ~/ 2 -
                                                            1][4]--;
                                                  }
                                                }),
                                                icon: const Icon(
                                                  Icons.remove_circle,
                                                  size: 25,
                                                ),
                                                color: Colors.brown,
                                              )),
                                        ],
                                      ),
                                    Text(
                                      '${TestPage.faults[index ~/ 2 - 1][4]}',
                                      style: TextStyle(
                                          color: Colors.brown,
                                          fontSize: (widget.isResult)
                                              ? 15
                                              : 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )), //تجويد
                            if (widget.isResult)
                              const SizedBox(
                                width: 12,
                              ),
                          ],
                        ),
                      );
                    }),
              ),
            ),
          ),
          if (widget.isResult)
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isExcelSaved)
                    Material(
                      child: Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Ink(
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.brown,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: InkWell(
                              onTap: () {
                                ExcelServices.excelStyle?.openExcel();
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Center(
                                    child: Text(
                                  'فتح الملف',
                                  style: TextStyle(color: Colors.white),
                                )),
                              )),
                        ),
                      ),
                    ),
                  Material(
                    child: Ink(
                      height: 38,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.brown,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: InkWell(
                        onTap: () async {
                          ExcelServices excelStyle = ExcelServices(
                              faults: TestPage.faults,
                              notes: TestPage.notes,
                              juzs: [widget.start, widget.end],
                              mark: TestPage.mark,
                              questions: TestPage.questions,
                              name: TestPage.name);
                          excelStyle.makeExcel();
                          isExcelSaved = await excelStyle.saveExcel();
                          setState(() {});
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0),
                          child: Stack(
                            children: [
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: SizedBox(
                                      height: 25,
                                      child: Image.asset(
                                          'assets/excel.png'))),
                              const Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'تخريج ملف اكسل',
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // ElevatedButton(
                  //     onPressed: () async {
                  //       ExcelServices excelStyle = ExcelServices(faults: TestPage.faults, notes: TestPage.notes, juzs: [widget.start, widget.end], mark: TestPage.mark, questions: TestPage.questions, name: TestPage.name);
                  //       excelStyle.makeExcel();
                  //       isExcelSaved = await excelStyle.saveExcel();
                  //       setState(() {});
                  //     }, child: const Align(alignment: Alignment.centerRight,child: Text('تخريج ملف اكسل'))),
                ],
              ),
            ),
        ],
      ),
      );
  }
}
