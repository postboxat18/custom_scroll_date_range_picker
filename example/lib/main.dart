import 'package:custom_scroll_date_range_picker/custom_scroll_date_range_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late DateTime initialStartDate = DateTime(DateTime
      .now()
      .year - 1);
  late DateTime initialEndDate = DateTime(DateTime
      .now()
      .year);
  late String fromDate = "";

  late String toDate = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //FROM DATE AND TO DATE
              Text("From Date=>$fromDate End Date=>$toDate"),
              //RANGE
              ElevatedButton(
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (context) {

                        return CustomSDRP(
                          initialStartDate: initialStartDate,
                          initialEndDate: initialEndDate,
                          initialEndYear: 2050,
                          initialStartYear: 2010,
                          color: Colors.deepPurple,
                        );
                      },
                    ).then((value) {
                      print("Value=>$value");

                      if (value != null) {
                        var arr = value.split("-");
                        fromDate = arr[0];
                        toDate = arr[1];
                        initialStartDate =
                            DateFormat("dd/MM/yyyy").parse(fromDate);
                        initialEndDate = DateFormat("dd/MM/yyyy").parse(toDate);
                        setState(() {
                          fromDate;
                          toDate;
                          initialStartDate;
                          initialEndDate;
                        });
                      }
                    });
                  },
                  child: Text("Range")),
            ],
          ),
        ));
  }
}
