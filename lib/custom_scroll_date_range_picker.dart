library custom_scroll_date_range_picker;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class CustomSDRP extends StatefulWidget {
  final DateTime initialStartDate;
  final DateTime initialEndDate;
  final int initialStartYear;
  final int initialEndYear;
  final Color color;

  CustomSDRP(
      {super.key,
        required this.initialStartDate,
        required this.initialEndDate,
        required this.initialStartYear,
        required this.initialEndYear,
        required this.color});

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
  late int smonth, syear, sday;
  late String currentMonth, currentYear;

  late int startPosition = 0;
  late int endDate;
  late int sendDate;

  late FixedExtentScrollController lyearController =
  FixedExtentScrollController();
  late FixedExtentScrollController lmonthController =
  FixedExtentScrollController();
  late FixedExtentScrollController ldateController =
  FixedExtentScrollController();
  late FixedExtentScrollController syearController =
  FixedExtentScrollController();
  late FixedExtentScrollController smonthController =
  FixedExtentScrollController();
  late FixedExtentScrollController sdateController =
  FixedExtentScrollController();
  late int selectedYearIndex = 0;
  late int selectedMonthIndex = 0;
  late int selectedDateIndex = 0;
  late int selectedSYearIndex = 0;
  late int selectedSMonthIndex = 0;
  late int selectedSDateIndex = 0;

  //EDITOR
  late TextEditingController lDateController = TextEditingController();
  late TextEditingController sDateController = TextEditingController();
  late bool validatorLDate = true;
  late String lDate = "Value Can't be Empty";
  late String sDate = "Value Can't be Empty";
  late bool validatorSDate = true;
  late bool pickEditor = false;

  @override
  void initState() {
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

    smonth = widget.initialEndDate.month;
    syear = widget.initialEndDate.year;
    sday = widget.initialEndDate.day;

    for (int i = 0; i < yearLen; i++) {
      if ((widget.initialStartYear + i) == syear) {
        selectedSYearIndex = i;
        break;
      }
    }



    selectedSMonthIndex = smonth - 1;
    selectedSDateIndex = sday - 1;
    var date = DateTime(year, month + 1, 0);
    endDate = date.day.toInt();
    var sdate = DateTime(syear, month + 1, 0);
    sendDate = sdate.day.toInt();


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    lyearController =
        FixedExtentScrollController(initialItem: selectedYearIndex);
    lmonthController =
        FixedExtentScrollController(initialItem: selectedMonthIndex);
    ldateController =
        FixedExtentScrollController(initialItem: selectedDateIndex);
    syearController =
        FixedExtentScrollController(initialItem: selectedSYearIndex);
    smonthController =
        FixedExtentScrollController(initialItem: selectedSMonthIndex);
    sdateController =
        FixedExtentScrollController(initialItem: selectedSDateIndex);
    //return Container(child:openDialog());
    return openDialog();
  }

  Widget openDialog() {
    return StatefulBuilder(
      builder: (context, setStateDialog) {
        if (pickEditor) {
          return openEditor();
        } else {
          return AlertDialog(
            title:const  Text("Custom Date Range",
                style: TextStyle(fontWeight: FontWeight.bold)),
            actions: [
              Column(
                children: [
                  //DATE
                  Wrap(
                    direction: MediaQuery.of(context).size.shortestSide > 600
                        ? Axis.horizontal
                        : Axis.vertical,
                    children: [
                      //START
                      Column(
                        children: [
                          const  Text("From Date",
                              textAlign: TextAlign.end,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Padding(
                            padding: EdgeInsets.all(15),
                            child: Row(children: [
                              //MONTH
                              SizedBox(
                                  height: 50,
                                  width: 80,
                                  child: ListWheelScrollView.useDelegate(
                                      itemExtent: 20,
                                      squeeze: 1.2,
                                      diameterRatio: 1,
                                      controller: lmonthController,
                                      onSelectedItemChanged: (value) {

                                        var date = DateTime(year, value + 2, 0);
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
                                          children: List<Widget>.generate(
                                              monthList.length, (index) {
                                            return Text(
                                              monthList[index],
                                              style: selectedMonthIndex ==
                                                  index
                                                  ? TextStyle(
                                                color: widget.color,
                                                fontWeight:
                                                FontWeight.w700,
                                              )
                                                  : const TextStyle(
                                                  color: Colors.black),
                                              textAlign: TextAlign.center,
                                            );
                                          }))
                                          : ListWheelChildListDelegate(
                                          children: List<Widget>.generate(
                                              monthList.length, (index) {
                                            return Text(
                                              monthList[index],
                                              style: selectedMonthIndex ==
                                                  index
                                                  ? TextStyle(
                                                color: widget.color,
                                                fontWeight:
                                                FontWeight.w700,
                                              )
                                                  : const TextStyle(
                                                  color: Colors.black),
                                              textAlign: TextAlign.center,
                                            );
                                          })))),

                              const  Text("/"),
                              //DATE
                              SizedBox(
                                  height: 50,
                                  width: 80,
                                  child: ListWheelScrollView.useDelegate(
                                      itemExtent: 20,
                                      squeeze: 1.2,
                                      diameterRatio: 1,
                                      physics: const FixedExtentScrollPhysics(),
                                      controller: ldateController,
                                      onSelectedItemChanged: (value) {

                                        setStateDialog(() {
                                          selectedDateIndex = value;
                                          day = value + 1;
                                        });
                                      },
                                      childDelegate: selectedDateIndex ==
                                          endDate - 4
                                          ? ListWheelChildLoopingListDelegate(
                                          children: List<Widget>.generate(
                                              endDate, (index) {
                                            return Text(
                                              (index + 1).toString(),
                                              style: selectedDateIndex ==
                                                  index
                                                  ? TextStyle(
                                                color: widget.color,
                                                fontWeight:
                                                FontWeight.w700,
                                              )
                                                  : const TextStyle(
                                                  color: Colors.black),
                                              textAlign: TextAlign.center,
                                            );
                                          }))
                                          : ListWheelChildListDelegate(
                                          children: List<Widget>.generate(
                                              endDate, (index) {
                                            return Text(
                                              (index + 1).toString(),
                                              style: selectedDateIndex ==
                                                  index
                                                  ? TextStyle(
                                                color: widget.color,
                                                fontWeight:
                                                FontWeight.w700,
                                              )
                                                  :const  TextStyle(
                                                  color: Colors.black),
                                              textAlign: TextAlign.center,
                                            );
                                          })))),
                              const   Text("/"),
                              //YEAR
                              SizedBox(
                                  height: 50,
                                  width: 80,
                                  child: ListWheelScrollView.useDelegate(
                                      itemExtent: 20,
                                      squeeze: 1.2,
                                      diameterRatio: 1,
                                      physics: const FixedExtentScrollPhysics(),
                                      controller: lyearController,
                                      onSelectedItemChanged: (value) {

                                        var date = DateTime(
                                            widget.initialStartYear + value,
                                            month + 1,
                                            0);
                                        endDate = date.day.toInt();

                                        setStateDialog(() {
                                          selectedYearIndex = value;
                                          year =
                                              widget.initialStartYear + value;
                                          endDate;
                                        });
                                      },
                                      childDelegate: selectedYearIndex ==
                                          yearLen - 4
                                          ? ListWheelChildLoopingListDelegate(
                                          children: List<Widget>.generate(
                                              yearLen, (index) {
                                            return Text(
                                              ((widget.initialStartYear) +
                                                  index)
                                                  .toString(),
                                              style: selectedYearIndex ==
                                                  index
                                                  ? TextStyle(
                                                color: widget.color,
                                                fontWeight:
                                                FontWeight.w700,
                                              )
                                                  :const  TextStyle(
                                                  color: Colors.black),
                                              textAlign: TextAlign.center,
                                            );
                                          }))
                                          : ListWheelChildListDelegate(
                                          children: List<Widget>.generate(
                                              yearLen, (index) {
                                            return Text(
                                              ((widget.initialStartYear) +
                                                  index)
                                                  .toString(),
                                              style: selectedYearIndex ==
                                                  index
                                                  ? TextStyle(
                                                color: widget.color,
                                                fontWeight:
                                                FontWeight.w700,
                                              )
                                                  : TextStyle(
                                                  color: Colors.black),
                                              textAlign: TextAlign.center,
                                            );
                                          })))),
                            ]),
                          ),
                        ],
                      ),
                      const  Text("-"),
                      //END
                      Column(
                        children: [
                          const  Text("To Date",
                              textAlign: TextAlign.end,
                              style:  TextStyle(fontWeight: FontWeight.bold)),
                          Padding(
                            padding: EdgeInsets.all(15),
                            child: Row(children: [
                              //MONTH
                              SizedBox(
                                  height: 50,
                                  width: 80,
                                  child: ListWheelScrollView.useDelegate(
                                      itemExtent: 20,
                                      squeeze: 1.2,
                                      diameterRatio: 1,
                                      controller: smonthController,
                                      onSelectedItemChanged: (value) {

                                        var date =
                                        DateTime(syear, value + 2, 0);
                                        sendDate = date.day.toInt();

                                        setStateDialog(() {
                                          selectedSMonthIndex = value;
                                          smonth = value + 1;
                                          sendDate;
                                        });
                                      },
                                      childDelegate: selectedSMonthIndex ==
                                          monthList.length - 4
                                          ? ListWheelChildLoopingListDelegate(
                                          children: List<Widget>.generate(
                                              monthList.length, (index) {
                                            return Text(
                                              monthList[index],
                                              style: selectedSMonthIndex ==
                                                  index
                                                  ? TextStyle(
                                                color: widget.color,
                                                fontWeight:
                                                FontWeight.w700,
                                              )
                                                  : TextStyle(
                                                  color: Colors.black),
                                              textAlign: TextAlign.center,
                                            );
                                          }))
                                          : ListWheelChildListDelegate(
                                          children: List<Widget>.generate(
                                              monthList.length, (index) {
                                            return Text(
                                              monthList[index],
                                              style: selectedSMonthIndex ==
                                                  index
                                                  ? TextStyle(
                                                color: widget.color,
                                                fontWeight:
                                                FontWeight.w700,
                                              )
                                                  : TextStyle(
                                                  color: Colors.black),
                                              textAlign: TextAlign.center,
                                            );
                                          })))),

                              const  Text("/"),
                              //DATE
                              SizedBox(
                                  height: 50,
                                  width: 80,
                                  child: ListWheelScrollView.useDelegate(
                                      itemExtent: 20,
                                      squeeze: 1.2,
                                      diameterRatio: 1,
                                      physics: const FixedExtentScrollPhysics(),
                                      controller: sdateController,
                                      onSelectedItemChanged: (value) {

                                        setStateDialog(() {
                                          selectedSDateIndex = value;
                                          sday = value + 1;
                                        });
                                      },
                                      childDelegate: selectedSDateIndex ==
                                          sendDate - 4
                                          ? ListWheelChildLoopingListDelegate(
                                          children: List<Widget>.generate(
                                              sendDate, (index) {
                                            return Text(
                                              (index + 1).toString(),
                                              style: selectedSDateIndex ==
                                                  index
                                                  ? TextStyle(
                                                color: widget.color,
                                                fontWeight:
                                                FontWeight.w700,
                                              )
                                                  :const  TextStyle(
                                                  color: Colors.black),
                                              textAlign: TextAlign.center,
                                            );
                                          }))
                                          : ListWheelChildListDelegate(
                                          children: List<Widget>.generate(
                                              sendDate, (index) {
                                            return Text(
                                              (index + 1).toString(),
                                              style: selectedSDateIndex ==
                                                  index
                                                  ? TextStyle(
                                                color: widget.color,
                                                fontWeight:
                                                FontWeight.w700,
                                              )
                                                  :const  TextStyle(
                                                  color: Colors.black),
                                              textAlign: TextAlign.center,
                                            );
                                          })))),
                              const    Text("/"),
                              //YEAR
                              SizedBox(
                                  height: 50,
                                  width: 80,
                                  child: ListWheelScrollView.useDelegate(
                                      itemExtent: 20,
                                      squeeze: 1.2,
                                      diameterRatio: 1,
                                      physics: const FixedExtentScrollPhysics(),
                                      controller: syearController,
                                      onSelectedItemChanged: (value) {

                                        var date = DateTime(
                                            widget.initialStartYear + value,
                                            smonth + 1,
                                            0);
                                        sendDate = date.day.toInt();

                                        setStateDialog(() {
                                          selectedSYearIndex = value;
                                          syear =
                                              widget.initialStartYear + value;
                                          sendDate;
                                        });
                                      },
                                      childDelegate: selectedSYearIndex ==
                                          yearLen - 4
                                          ? ListWheelChildLoopingListDelegate(
                                          children: List<Widget>.generate(
                                              yearLen, (index) {
                                            return Text(
                                              ((widget.initialStartYear) +
                                                  index)
                                                  .toString(),
                                              style: selectedSYearIndex ==
                                                  index
                                                  ? TextStyle(
                                                color: widget.color,
                                                fontWeight:
                                                FontWeight.w700,
                                              )
                                                  : const TextStyle(
                                                  color: Colors.black),
                                              textAlign: TextAlign.center,
                                            );
                                          }))
                                          : ListWheelChildListDelegate(
                                          children: List<Widget>.generate(
                                              yearLen, (index) {
                                            return Text(
                                              ((widget.initialStartYear) +
                                                  index)
                                                  .toString(),
                                              style: selectedSYearIndex ==
                                                  index
                                                  ? TextStyle(
                                                color: widget.color,
                                                fontWeight:
                                                FontWeight.w700,
                                              )
                                                  : const TextStyle(
                                                  color: Colors.black),
                                              textAlign: TextAlign.center,
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
                          icon:const  Icon(
                            Icons.edit_calendar_rounded,
                          )),

                      //CANCEL OK
                      Row(
                        children: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Cancel",
                                  style: TextStyle(
                                      color: widget.color,
                                      fontWeight: FontWeight.w700))),
                          Padding(
                              padding:const  EdgeInsets.fromLTRB(15, 0, 15, 0),
                              child: TextButton(
                                onPressed: () {
                                  //fromDate
                                  DateTime ltime = DateFormat("dd MMM yyyy")
                                      .parse(
                                      "$day ${monthList[month - 1]} $year");
                                  String Lformat =
                                  DateFormat("dd/MM/yyy").format(ltime);

                                  DateTime stime = DateFormat("dd MMM yyyy").parse(
                                      "$sday ${monthList[smonth - 1]} $syear");
                                  String Sformat =
                                  DateFormat("dd/MM/yyy").format(stime);


                                  if (year > syear) {
                                    toastMessage(
                                        "End Year is not less than Start Year");
                                  } else if (month > smonth && year == syear) {
                                    toastMessage(
                                        "End Month is not less than Start Month");
                                  } else {
                                    Navigator.pop(context, "$Lformat-$Sformat");
                                  }
                                },
                                child: Text("OK",
                                    style: TextStyle(
                                        color: widget.color,
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

  Widget openEditor() {
    return AlertDialog(
        title: const Text("Custom Date Range",
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          //EDITOR
          Row(
            children: [
              //FROM DATE
              Flexible(
                child: TextField(
                  textInputAction: TextInputAction.next,
                  //keyboardType: TextInputType.datetime,
                  controller: lDateController,
                  onChanged: (value) {
                    if (mounted) {
                      setState(() {
                        if (value.isEmpty) {
                          lDate = "From Date Can't be Empty";
                          validatorLDate = false;
                        } else {
                          lDate = "";
                          validatorLDate = true;
                        }
                      });
                    }
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "30/12/2012",
                    errorText: validatorLDate ? null : lDate,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: widget.color),
                        borderRadius: BorderRadius.circular(8)),
                    errorBorder: OutlineInputBorder(
                        borderSide:const  BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(8)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8)),
                    labelText: "From Date",
                  ),
                ),
              ),
              //TO DATE
              Flexible(
                  child: Padding(
                    padding:const  EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: TextField(
                      textInputAction: TextInputAction.next,
                      //keyboardType: TextInputType.datetime,
                      controller: sDateController,
                      onChanged: (value) {
                        if (mounted) {
                          setState(() {
                            if (value.isEmpty) {
                              sDate = "To Date Can't be Empty";
                              validatorSDate = false;
                            } else {
                              sDate = "";
                              validatorSDate = true;
                            }
                          });
                        }
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "30/12/2012",
                        errorText: validatorSDate ? null : sDate,
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: widget.color),
                            borderRadius: BorderRadius.circular(8)),
                        errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(8)),
                        enabledBorder: OutlineInputBorder(
                            borderSide:const  BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8)),
                        labelText: "To Date",
                      ),
                    ),
                  )),
            ],
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
                          color: widget.color, fontWeight: FontWeight.w700))),
              //OK
              Padding(
                  padding:const  EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: TextButton(
                    onPressed: () {
                      if (validatorLDate && validatorSDate) {
                        DateTime lFormat = DateFormat("dd/mm/yyyy")
                            .parse(lDateController.text.trim().toString());
                        String lTime = DateFormat("dd MMM yyyy")
                            .format(lFormat)
                            .toString();
                        var lstr = lTime.split(" ");
                        for (int i = 0; i < monthList.length; i++) {
                          if (monthList[i].toString() == lstr[1]) {
                            month = i;
                            break;
                          }
                        }
                        year = int.parse(lstr[2]);
                        DateTime sFormat = DateFormat("dd/mm/yyyy")
                            .parse(sDateController.text.trim().toString());
                        String sTime =
                        DateFormat("dd MMM yyyy").format(sFormat);
                        var sstr = sTime.split(" ");
                        for (int i = 0; i < monthList.length; i++) {
                          if (monthList[i].toString() == sstr[1]) {
                            smonth = i;
                            break;
                          }
                        }
                        syear = int.parse(sstr[2]);

                        if (widget.initialStartYear > year ||
                            widget.initialEndYear < syear) {
                          if (year > syear) {
                            toastMessage(
                                "End Year is not less than Start Year");
                          }
                          else{
                            toastMessage(
                                "End Year is not less than Start Year");
                          }
                        } else if (month > smonth && year == syear) {
                          toastMessage(
                              "End Month is not less than Start Month");
                        } else {
                          Navigator.pop(context,
                              "${lDateController.text.trim()}-${sDateController.text.trim()}");
                        }
                      }
                    },
                    child: Text("OK",
                        style: TextStyle(
                            color: widget.color, fontWeight: FontWeight.bold)),
                  ))
            ],
          )
        ]);
  }

  void toastMessage(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }
}