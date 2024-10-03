library;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class CustomSDRP extends StatefulWidget {
  final DateTime initialStartDate;
  final DateTime initialEndDate;
  final int initialStartYear;
  final int initialEndYear;
  final Color primaryColor;

  const CustomSDRP(
      {super.key,
        required this.initialStartDate,
        required this.initialEndDate,
        required this.initialStartYear,
        required this.initialEndYear,
        required this.primaryColor});

  @override
  State<CustomSDRP> createState() => _CustomSDRPState();
}

class _CustomSDRPState extends State<CustomSDRP> {
  late List<String> weekList = [
    "Sun",
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat"
  ];
  late List<String> monthList = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  late int yearLen;
  late int month, year, day;
  late int sMonth, sYear, sDay;
  late String currentMonth, currentYear;

  late int startPosition = 0;
  late int endDate;
  late int sendDate;

  late FixedExtentScrollController lYearController =
  FixedExtentScrollController();
  late FixedExtentScrollController lMonthController =
  FixedExtentScrollController();
  late FixedExtentScrollController lDateController =
  FixedExtentScrollController();
  late FixedExtentScrollController sYearController =
  FixedExtentScrollController();
  late FixedExtentScrollController sMonthController =
  FixedExtentScrollController();
  late FixedExtentScrollController sDateController =
  FixedExtentScrollController();
  late int selectedYearIndex = 0;
  late int selectedMonthIndex = 0;
  late int selectedDateIndex = 0;
  late int selectedSYearIndex = 0;
  late int selectedSMonthIndex = 0;
  late int selectedSDateIndex = 0;

  //EDITOR
  late TextEditingController fromDateController = TextEditingController();
  late TextEditingController toDateController = TextEditingController();
  late DateTime startDate;
  late DateTime toDate;

  late bool validatorLDate = true;
  late String lDate = "Value Can't be Empty";
  late String sDate = "Value Can't be Empty";
  late bool validatorSDate = true;
  late bool pickEditor = false;
  late double height;
  late double width;
  late double paddingHeight;
  late double paddingWidth;
  late bool isTab;
  late DateTime now = DateTime.now();

  @override
  void initState() {
    startDate = widget.initialStartDate;
    toDate = widget.initialEndDate;
    fromDateController.text =
        DateFormat("dd/MM/yyyy").format(widget.initialStartDate);
    toDateController.text =
        DateFormat("dd/MM/yyyy").format(widget.initialEndDate);
    //YEAR LEN
    yearLen = (widget.initialEndYear - widget.initialStartYear) + 1;

    month = widget.initialStartDate.month;
    year = widget.initialStartDate.year;
    day = widget.initialStartDate.day;
    for (int i = 0; i < yearLen; i++) {
      if (widget.initialStartYear + i == year) {
        selectedYearIndex = i;
        break;
      }
    }
    selectedMonthIndex = month - 1;
    selectedDateIndex = day - 1;

    sMonth = widget.initialEndDate.month;
    sYear = widget.initialEndDate.year;
    sDay = widget.initialEndDate.day;

    for (int i = 0; i < yearLen; i++) {
      if ((widget.initialStartYear + i) == sYear) {
        selectedSYearIndex = i;
        break;
      }
    }

    selectedSMonthIndex = sMonth - 1;
    selectedSDateIndex = sDay - 1;
    var date = DateTime(year, month + 1, 0);
    endDate = date.day.toInt();
    var sDates = DateTime(sYear, month + 1, 0);
    sendDate = sDates.day.toInt();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    final data = MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.single);
    isTab = data.size.shortestSide < 600 ? false : true;
    paddingWidth = isTab ? (width * 0.02) : (width * 0.03);
    paddingHeight = (height * 0.15);

    lYearController =
        FixedExtentScrollController(initialItem: selectedYearIndex);
    lMonthController =
        FixedExtentScrollController(initialItem: selectedMonthIndex);
    lDateController =
        FixedExtentScrollController(initialItem: selectedDateIndex);
    sYearController =
        FixedExtentScrollController(initialItem: selectedSYearIndex);
    sMonthController =
        FixedExtentScrollController(initialItem: selectedSMonthIndex);
    sDateController =
        FixedExtentScrollController(initialItem: selectedSDateIndex);
    //return Container(child:openDialog());
    return openDialog();
  }

  Widget openDialog() {
    return StatefulBuilder(
      builder: (context, setStateDialog) {
        if (pickEditor) {
          return openEditor(setStateDialog);
        } else {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25)),
            title: const Text("Custom Date Range",
                style: TextStyle(fontWeight: FontWeight.bold)),
            actions: [
              Column(
                children: [
                  //DATE
                  Wrap(
                    direction: MediaQuery.of(context).size.shortestSide < 600
                        ? Axis.vertical
                        : Axis.horizontal,
                    children: [
                      //START
                      Column(
                        children: [
                          const Text("From Date",
                              textAlign: TextAlign.end,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Padding(
                            padding: EdgeInsets.all(15),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  //MONTH
                                  SizedBox(
                                      height: 50,
                                      width: width / 8,
                                      child: ListWheelScrollView.useDelegate(
                                          itemExtent: 20,
                                          squeeze: 1.2,
                                          diameterRatio: 0.8,
                                          controller: lMonthController,
                                          onSelectedItemChanged: (value) {
                                            var date =
                                            DateTime(year, value + 2, 0);
                                            endDate = date.day.toInt();
                                            setStateDialog(() {
                                              selectedMonthIndex = value;
                                              month = value + 1;
                                              endDate;
                                            });
                                          },
                                          childDelegate: selectedMonthIndex ==
                                              monthList.length - 4
                                              ? ListWheelChildLoopingListDelegate(
                                              children:
                                              List<Widget>.generate(
                                                  monthList.length,
                                                      (index) {
                                                    return Text(
                                                      monthList[index],
                                                      style:
                                                      selectedMonthIndex ==
                                                          index
                                                          ? TextStyle(
                                                        color: widget
                                                            .primaryColor,
                                                        fontWeight:
                                                        FontWeight
                                                            .w700,
                                                      )
                                                          : const TextStyle(
                                                          color: Colors
                                                              .grey),
                                                      textAlign:
                                                      TextAlign.center,
                                                    );
                                                  }))
                                              : ListWheelChildListDelegate(
                                              children:
                                              List<Widget>.generate(
                                                  monthList.length,
                                                      (index) {
                                                    return Text(
                                                      monthList[index],
                                                      style:
                                                      selectedMonthIndex ==
                                                          index
                                                          ? TextStyle(
                                                        color: widget
                                                            .primaryColor,
                                                        fontWeight:
                                                        FontWeight
                                                            .w700,
                                                      )
                                                          : const TextStyle(
                                                          color: Colors
                                                              .grey),
                                                      textAlign:
                                                      TextAlign.center,
                                                    );
                                                  })))),

                                  const Text("/"),
                                  //DATE
                                  SizedBox(
                                      height: 50,
                                      width: width / 8,
                                      child: ListWheelScrollView.useDelegate(
                                          itemExtent: 20,
                                          squeeze: 1.2,
                                          diameterRatio: 0.8,
                                          physics:
                                          const FixedExtentScrollPhysics(),
                                          controller: lDateController,
                                          onSelectedItemChanged: (value) {
                                            setStateDialog(() {
                                              selectedDateIndex = value;
                                              day = value + 1;
                                            });
                                          },
                                          childDelegate: selectedDateIndex ==
                                              endDate - 4
                                              ? ListWheelChildLoopingListDelegate(
                                              children:
                                              List<Widget>.generate(
                                                  endDate, (index) {
                                                return Text(
                                                  (index + 1).toString(),
                                                  style:
                                                  selectedDateIndex ==
                                                      index
                                                      ? TextStyle(
                                                    color: widget
                                                        .primaryColor,
                                                    fontWeight:
                                                    FontWeight
                                                        .w700,
                                                  )
                                                      : const TextStyle(
                                                      color: Colors
                                                          .grey),
                                                  textAlign:
                                                  TextAlign.center,
                                                );
                                              }))
                                              : ListWheelChildListDelegate(
                                              children:
                                              List<Widget>.generate(
                                                  endDate, (index) {
                                                return Text(
                                                  (index + 1).toString(),
                                                  style:
                                                  selectedDateIndex ==
                                                      index
                                                      ? TextStyle(
                                                    color: widget
                                                        .primaryColor,
                                                    fontWeight:
                                                    FontWeight
                                                        .w700,
                                                  )
                                                      : const TextStyle(
                                                      color: Colors
                                                          .grey),
                                                  textAlign:
                                                  TextAlign.center,
                                                );
                                              })))),
                                  const Text("/"),
                                  //YEAR
                                  SizedBox(
                                      height: 50,
                                      width: width / 8,
                                      child: ListWheelScrollView.useDelegate(
                                          itemExtent: 20,
                                          squeeze: 1.2,
                                          diameterRatio: 0.8,
                                          physics:
                                          const FixedExtentScrollPhysics(),
                                          controller: lYearController,
                                          onSelectedItemChanged: (value) {
                                            var date = DateTime(
                                                widget.initialStartYear +
                                                    value,
                                                month + 1,
                                                0);
                                            endDate = date.day.toInt();

                                            setStateDialog(() {
                                              selectedYearIndex = value;
                                              year = widget.initialStartYear +
                                                  value;
                                              endDate;
                                            });
                                          },
                                          childDelegate: selectedYearIndex ==
                                              yearLen - 4
                                              ? ListWheelChildLoopingListDelegate(
                                              children:
                                              List<Widget>.generate(
                                                  yearLen, (index) {
                                                return Text(
                                                  ((widget.initialStartYear) +
                                                      index)
                                                      .toString(),
                                                  style:
                                                  selectedYearIndex ==
                                                      index
                                                      ? TextStyle(
                                                    color: widget
                                                        .primaryColor,
                                                    fontWeight:
                                                    FontWeight
                                                        .w700,
                                                  )
                                                      : const TextStyle(
                                                      color: Colors
                                                          .grey),
                                                  textAlign:
                                                  TextAlign.center,
                                                );
                                              }))
                                              : ListWheelChildListDelegate(
                                              children:
                                              List<Widget>.generate(
                                                  yearLen, (index) {
                                                return Text(
                                                  ((widget.initialStartYear) +
                                                      index)
                                                      .toString(),
                                                  style:
                                                  selectedYearIndex ==
                                                      index
                                                      ? TextStyle(
                                                    color: widget
                                                        .primaryColor,
                                                    fontWeight:
                                                    FontWeight
                                                        .w700,
                                                  )
                                                      : const TextStyle(
                                                      color: Colors
                                                          .grey),
                                                  textAlign:
                                                  TextAlign.center,
                                                );
                                              })))),
                                ]),
                          ),
                        ],
                      ),

                      //END
                      Column(
                        children: [
                          const Text("To Date",
                              textAlign: TextAlign.end,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Padding(
                            padding: EdgeInsets.all(15),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  //MONTH
                                  SizedBox(
                                      height: 50,
                                      width: width / 8,
                                      child: ListWheelScrollView.useDelegate(
                                          itemExtent: 20,
                                          squeeze: 1.2,
                                          diameterRatio: 0.8,
                                          controller: sMonthController,
                                          onSelectedItemChanged: (value) {
                                            var date =
                                            DateTime(sYear, value + 2, 0);
                                            sendDate = date.day.toInt();

                                            setStateDialog(() {
                                              selectedSMonthIndex = value;
                                              sMonth = value + 1;
                                              sendDate;
                                            });
                                          },
                                          childDelegate: selectedSMonthIndex ==
                                              monthList.length - 4
                                              ? ListWheelChildLoopingListDelegate(
                                              children:
                                              List<Widget>.generate(
                                                  monthList.length,
                                                      (index) {
                                                    return Text(
                                                      monthList[index],
                                                      style:
                                                      selectedSMonthIndex ==
                                                          index
                                                          ? TextStyle(
                                                        color: widget
                                                            .primaryColor,
                                                        fontWeight:
                                                        FontWeight
                                                            .w700,
                                                      )
                                                          : const TextStyle(
                                                          color: Colors
                                                              .grey),
                                                      textAlign:
                                                      TextAlign.center,
                                                    );
                                                  }))
                                              : ListWheelChildListDelegate(
                                              children:
                                              List<Widget>.generate(
                                                  monthList.length,
                                                      (index) {
                                                    return Text(
                                                      monthList[index],
                                                      style:
                                                      selectedSMonthIndex ==
                                                          index
                                                          ? TextStyle(
                                                        color: widget
                                                            .primaryColor,
                                                        fontWeight:
                                                        FontWeight
                                                            .w700,
                                                      )
                                                          : const TextStyle(
                                                          color: Colors
                                                              .grey),
                                                      textAlign:
                                                      TextAlign.center,
                                                    );
                                                  })))),

                                  const Text("/"),
                                  //DATE
                                  SizedBox(
                                      height: 50,
                                      width: width / 8,
                                      child: ListWheelScrollView.useDelegate(
                                          itemExtent: 20,
                                          squeeze: 1.2,
                                          diameterRatio: 0.8,
                                          physics:
                                          const FixedExtentScrollPhysics(),
                                          controller: sDateController,
                                          onSelectedItemChanged: (value) {
                                            setStateDialog(() {
                                              selectedSDateIndex = value;
                                              sDay = value + 1;
                                            });
                                          },
                                          childDelegate: selectedSDateIndex ==
                                              sendDate - 4
                                              ? ListWheelChildLoopingListDelegate(
                                              children:
                                              List<Widget>.generate(
                                                  sendDate, (index) {
                                                return Text(
                                                  (index + 1).toString(),
                                                  style:
                                                  selectedSDateIndex ==
                                                      index
                                                      ? TextStyle(
                                                    color: widget
                                                        .primaryColor,
                                                    fontWeight:
                                                    FontWeight
                                                        .w700,
                                                  )
                                                      : const TextStyle(
                                                      color: Colors
                                                          .grey),
                                                  textAlign:
                                                  TextAlign.center,
                                                );
                                              }))
                                              : ListWheelChildListDelegate(
                                              children:
                                              List<Widget>.generate(
                                                  sendDate, (index) {
                                                return Text(
                                                  (index + 1).toString(),
                                                  style:
                                                  selectedSDateIndex ==
                                                      index
                                                      ? TextStyle(
                                                    color: widget
                                                        .primaryColor,
                                                    fontWeight:
                                                    FontWeight
                                                        .w700,
                                                  )
                                                      : const TextStyle(
                                                      color: Colors
                                                          .grey),
                                                  textAlign:
                                                  TextAlign.center,
                                                );
                                              })))),
                                  const Text("/"),
                                  //YEAR
                                  SizedBox(
                                      height: 50,
                                      width: width / 8,
                                      child: ListWheelScrollView.useDelegate(
                                          itemExtent: 20,
                                          squeeze: 1.2,
                                          diameterRatio: 0.8,
                                          physics:
                                          const FixedExtentScrollPhysics(),
                                          controller: sYearController,
                                          onSelectedItemChanged: (value) {
                                            var date = DateTime(
                                                widget.initialStartYear +
                                                    value,
                                                sMonth + 1,
                                                0);
                                            sendDate = date.day.toInt();

                                            setStateDialog(() {
                                              selectedSYearIndex = value;
                                              sYear =
                                                  widget.initialStartYear +
                                                      value;
                                              sendDate;
                                            });
                                          },
                                          childDelegate: selectedSYearIndex ==
                                              yearLen - 4
                                              ? ListWheelChildLoopingListDelegate(
                                              children:
                                              List<Widget>.generate(
                                                  yearLen, (index) {
                                                return Text(
                                                  ((widget.initialStartYear) +
                                                      index)
                                                      .toString(),
                                                  style:
                                                  selectedSYearIndex ==
                                                      index
                                                      ? TextStyle(
                                                    color: widget
                                                        .primaryColor,
                                                    fontWeight:
                                                    FontWeight
                                                        .w700,
                                                  )
                                                      : const TextStyle(
                                                      color: Colors
                                                          .grey),
                                                  textAlign:
                                                  TextAlign.center,
                                                );
                                              }))
                                              : ListWheelChildListDelegate(
                                              children:
                                              List<Widget>.generate(
                                                  yearLen, (index) {
                                                return Text(
                                                  ((widget.initialStartYear) +
                                                      index)
                                                      .toString(),
                                                  style:
                                                  selectedSYearIndex ==
                                                      index
                                                      ? TextStyle(
                                                    color: widget
                                                        .primaryColor,
                                                    fontWeight:
                                                    FontWeight
                                                        .w700,
                                                  )
                                                      : const TextStyle(
                                                      color: Colors
                                                          .grey),
                                                  textAlign:
                                                  TextAlign.center,
                                                );
                                              })))),
                                ]),
                          ),
                        ],
                      )
                    ],
                  ),
                  // CANCEL OK
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //EDIT
                      IconButton(
                          onPressed: () {
                            setState(() {
                              pickEditor = true;
                            });
                          },
                          icon: const Icon(Icons.edit_outlined)),

                      //CANCEL OK
                      Row(
                        children: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Cancel",
                                  style: TextStyle(
                                      color: widget.primaryColor,
                                      fontWeight: FontWeight.w700))),
                          Padding(
                              padding:
                              const EdgeInsets.fromLTRB(15, 0, 15, 0),
                              child: TextButton(
                                onPressed: () {
                                  //fromDate
                                  DateTime lTime = DateFormat("dd MMM yyyy")
                                      .parse(
                                      "$day ${monthList[month - 1]} $year");
                                  String lFormat =
                                  DateFormat("dd/MM/yyy").format(lTime);

                                  DateTime sTime = DateFormat("dd MMM yyyy")
                                      .parse(
                                      "$sDay ${monthList[sMonth - 1]} $sYear");
                                  String sFormat =
                                  DateFormat("dd/MM/yyy").format(sTime);

                                  if (year > sYear) {
                                    toastMessage(
                                        "End Year is not less than Start Year");
                                  } else if (month > sMonth &&
                                      year == sYear) {
                                    toastMessage(
                                        "End Month is not less than Start Month");
                                  } else {
                                    Navigator.pop(
                                        context, "$lFormat-$sFormat");
                                  }
                                },
                                child: Text("OK",
                                    style: TextStyle(
                                        color: widget.primaryColor,
                                        fontWeight: FontWeight.bold)),
                              ))
                        ],
                      ),
                    ],
                  )
                ],
              )
            ],
          );
        }
      },
    );
  }

  Widget openEditor(StateSetter setStateDialog) {
    return MaterialApp(
      theme: ThemeData(
          useMaterial3: false,
          colorScheme:
          ColorScheme.fromSwatch().copyWith(primary: widget.primaryColor)),
      home:AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          title: const Text("Custom Date Range",
              style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            //EDITOR
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  //FROM DATE
                  TextField(
                    textInputAction: TextInputAction.next,
                    controller: fromDateController,
                    readOnly: true,
                    keyboardType: TextInputType.none,
                    cursorHeight: 0,
                    cursorWidth: 0,
                    onTap: () async {
                      DateTime? picker2 = await showDatePicker(
                        context: context,
                        initialDate: startDate,
                        firstDate: DateTime(now.year - 50),
                        lastDate: toDate,
                      );
                      if (picker2 != null) {
                        setStateDialog(() {
                          startDate = picker2;
                          toDate = picker2;
                          fromDateController.text =
                              DateFormat('dd/MM/yyyy').format(picker2);
                          toDateController.text = "";
                          validatorLDate = fromDateController.text.isNotEmpty;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: const Icon(
                        Icons.calendar_month_outlined,
                        color: Colors.grey,
                      ),
                      errorText: validatorLDate ? null : lDate,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: widget.primaryColor),
                          borderRadius: BorderRadius.circular(8)),
                      errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(8)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8)),
                      labelText: "From Date",
                    ),
                  ),
                  //TO DATE
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: TextField(
                      textInputAction: TextInputAction.next,
                      controller: toDateController,
                      readOnly: true,
                      keyboardType: TextInputType.none,
                      cursorHeight: 0,
                      cursorWidth: 0,
                      onTap: () async {
                        DateTime? picker2 = await showDatePicker(
                          context: context,
                          initialDate: toDate,
                          firstDate: startDate,
                          lastDate: DateTime(now.year + 50),
                        );
                        if (picker2 != null) {
                          setStateDialog(() {
                            toDate = picker2;
                            toDateController.text =
                                DateFormat('dd/MM/yyyy').format(picker2);
                            validatorSDate = toDateController.text.isNotEmpty;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: Icon(
                          Icons.calendar_month_outlined,
                          color: Colors.grey,
                        ),
                        errorText: validatorSDate ? null : lDate,
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: widget.primaryColor),
                            borderRadius: BorderRadius.circular(8)),
                        errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(8)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8)),
                        labelText: "To Date",
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // CANCEL OK
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //CANCEL
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel",
                        style: TextStyle(
                            color: widget.primaryColor,
                            fontWeight: FontWeight.w700))),
                //OK
                Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: TextButton(
                      onPressed: () {
                        validatorLDate = fromDateController.text.isNotEmpty;
                        validatorSDate = toDateController.text.isNotEmpty;
                        if (validatorLDate && validatorSDate) {
                          Navigator.pop(context,
                              "${fromDateController.text.trim()}-${toDateController.text.trim()}");
                        } else {
                          setStateDialog(() {
                            validatorLDate;
                            validatorSDate;
                          });
                        }
                      },
                      child: Text("OK",
                          style: TextStyle(
                              color: widget.primaryColor,
                              fontWeight: FontWeight.bold)),
                    ))
              ],
            )
          ]),);
  }

  void toastMessage(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }
}
