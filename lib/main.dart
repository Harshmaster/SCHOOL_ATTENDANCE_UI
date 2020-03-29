import 'dart:convert';

import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CalendarController _controller;
  String totalDays = '';
  String absentDays = '';
  String holidays = '';
  String lateDays = '';
  String percentage = '';
  String presentDays = '';
  var exportData;

  Future<String> getTeacherStudent() async {
    var body = jsonEncode(
        {"user_id": 4, "from_date": "2020-03-01", "to_date": "2020-03-31"});

    final response = await http.post(
      'https://bndah6rpt4.execute-api.ap-south-1.amazonaws.com/dev/get-student-attendance-for-month',
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    var extractdata = json.decode(response.body);
    print(response.statusCode);
    print(response.body);

    exportData = extractdata;

    setState(() {
      presentDays = exportData["present_days"].toString();
      absentDays = exportData["absent_days"].toString();
      percentage = exportData["attendance_percentage"].toStringAsFixed(2);
      holidays = exportData["holidays"].toString();
      lateDays = exportData["late_days"].toString();
      totalDays = exportData["total_days"].toString();
         
    });

    // print(extractdata["total_days"]);
    // print(extractdata["result"][0]);

    // print(extractdata["status"]);

    if (extractdata["status"] == "True") {
      print("success");
      print(response.body);

      return response.body;
    } else {
      return "Error";
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();

    getTeacherStudent();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        
      ),
      body: Stack(children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          child: Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
          ),
        ),
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Text(
                'Attendance',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                margin:
                    EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  border: Border.all(color: Colors.amber),
                ),
                child: TableCalendar(
                  calendarController: _controller,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  availableCalendarFormats: {CalendarFormat.month: 'Month'},
                  headerStyle: HeaderStyle(
                    centerHeaderTitle: true,
                    formatButtonVisible: false,
                    titleTextBuilder: (date, locale) =>
                        DateFormat.MMMM(locale).format(date),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(left: 24, right: 24, bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 2, left: 5),
                      height: 20,
                      width: 20,
                      color: Color(0xff1DFF00).withOpacity(0.5),
                    ),
                    Text(
                      'Present',
                      style: TextStyle(fontSize: 17),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 2, left: 5),
                      height: 20,
                      width: 20,
                      color: Color(0xffFF0000).withOpacity(0.5),
                    ),
                    Text(
                      'Absent',
                      style: TextStyle(fontSize: 17),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 2, left: 5),
                      height: 20,
                      width: 20,
                      color: Color(0xffFFA700).withOpacity(0.5),
                    ),
                    Text(
                      'Holiday',
                      style: TextStyle(fontSize: 17),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 2, left: 5),
                      height: 20,
                      width: 20,
                      color: Color(0xff009DFF).withOpacity(0.5),
                    ),
                    Text(
                      'Late',
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),
              ),
              Text(
                'Monthly Report',
                style: TextStyle(fontSize: 15),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(25),
                padding: EdgeInsets.only(left: 15, right: 15, top: 25),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.amber,
                    )),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          'Total Days',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          ':',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: SizedBox(
                            width: 20,
                          ),
                        ),
                        Text(
                          totalDays,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          'Present Days',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          ':',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: SizedBox(
                            width: 20,
                          ),
                        ),
                        Text(
                          presentDays,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          'Absent Days',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          ':',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: SizedBox(
                            width: 20,
                          ),
                        ),
                        Text(
                          absentDays,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          'Holidays',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          ':',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: SizedBox(
                            width: 20,
                          ),
                        ),
                        Text(
                          holidays,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          'Late',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          ':',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: SizedBox(
                            width: 20,
                          ),
                        ),
                        Text(
                          lateDays,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          'Attendance %',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          ':',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: SizedBox(
                            width: 20,
                          ),
                        ),
                        Text(
                          percentage,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 18,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
