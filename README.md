Here is the **README** for the **Custom Scroll Date Range Picker** GitHub repository with the necessary code:

---

# Custom Scroll Date Range Picker

**Custom Scroll Date Range Picker** is a Flutter package that allows users to easily select a date range using a scrollable and interactive interface. This package simplifies date selection by offering a smooth, intuitive user experience with day, month, and year precision.

![Custom Scroll Date Range Picker](https://github.com/user-attachments/assets/99803906-9a23-4144-82e5-a08d20577be0)

---

## Features

- **Scrollable Interface**: Allows users to scroll through dates for quick and precise selection.
- **Date Range Selection**: Users can choose both the start and end dates in an easy-to-use interface.
- **Customizable**: Offers flexibility in design and layout to suit various project needs.
- **Day, Month, and Year Navigation**: Provides smooth scrolling between days, months, and years, making it easy to pick date ranges for any time period.

---

![Scrollable Date Picker](https://github.com/user-attachments/assets/f27a272a-eee1-4447-ab83-312e33c116da)
![User Interface Example](https://github.com/user-attachments/assets/5960a313-3a49-4e46-8751-c31512845b91)

---

## Video Demo
[Screen_recording_20241006_101208-ezgif.com-video-to-gif-converter.webm](https://github.com/user-attachments/assets/07671eee-0356-4406-857e-2dd0bd7fa4cf)


---



---

## Installation

To use this package, add `custom_scroll_date_range_picker` to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  custom_scroll_date_range_picker: ^1.0.0
```

Then, run `flutter pub get` to install the package.

---

## Usage

### Example Code

To use the **Custom Scroll Date Range Picker**, simply include it in your Flutter app like this:

```dart
import 'package:custom_scroll_date_range_picker/custom_scroll_date_range_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  late DateTime initialStartDate = DateTime(DateTime.now().year - 1);
  late DateTime initialEndDate = DateTime(DateTime.now().year);
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
            Text("From Date: $fromDate End Date: $toDate"),
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
                      primaryColor: Colors.blue,
                    );
                  },
                ).then((value) {
                  if (value != null) {
                    var arr = value.split("-");
                    fromDate = arr[0];
                    toDate = arr[1];
                    initialStartDate = DateFormat("dd/MM/yyyy").parse(fromDate);
                    initialEndDate = DateFormat("dd/MM/yyyy").parse(toDate);
                    setState(() {});
                  }
                });
              },
              child: const Text("Pick Date Range"),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Key Parameters:
- `initialStartDate`: Starting date for the date range.
- `initialEndDate`: Ending date for the date range.
- `initialStartYear`: Minimum year available for selection.
- `initialEndYear`: Maximum year available for selection.
- `primaryColor`: The main color used for the picker UI.

---

## License

This package is open-source and available under the [MIT License](LICENSE).

---

For more information, visit the [Custom Scroll Date Range Picker on Pub.dev](https://pub.dev/packages/custom_scroll_date_range_picker).
