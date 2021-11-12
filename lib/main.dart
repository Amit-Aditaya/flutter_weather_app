import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'network.dart';

void main() {
  runApp(MaterialApp(home: Home()));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var data;
  var city = 'London';

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Weather App',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.amberAccent,
        padding: EdgeInsets.all(10),
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Container(
                height: 50,
                width: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                  border: Border.all(
                    width: 2,
                    color: Colors.black,
                  ),
                ),
                child: TextField(
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                    hintText: 'Enter City',
                  ),
                  onSubmitted: (String value) {
                    setState(() {
                      print(value);
                      city = value;
                      Network network = Network(
                          'https://api.openweathermap.org/data/2.5/weather?q=$value&appid=ebee7fa22892e972a61b7ed30e563756');
                      network.fetchData();
                    });
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.black,
                      width: 3,
                    ),
                    color: Colors.white,
                  ),
                  height: 100,
                  width: 300,
                  child: FutureBuilder(
                    future: getData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Center(
                          child: Text(
                            '${(snapshot.data as dynamic)['name']}, ${(snapshot.data as dynamic)['sys']['country']}',
                            style: TextStyle(
                              color: Colors.amber.shade300,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Center(
                child: FutureBuilder(
                  future: getData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        (snapshot.data as dynamic)['weather'][0]['main'] ==
                            'Clear') {
                      return Icon(
                        Icons.wb_sunny_outlined,
                        size: 70,
                      );
                    } else if (snapshot.hasData &&
                        (snapshot.data as dynamic)['weather'][0]['main'] ==
                            'Clouds') {
                      return Icon(
                        Icons.cloud,
                        size: 70,
                      );
                    } else if (snapshot.hasData &&
                        (snapshot.data as dynamic)['weather'][0]['main'] ==
                            'Smoke') {
                      return Icon(
                        FontAwesomeIcons.smoking,
                        size: 70,
                      );
                    } else if (snapshot.hasData &&
                        (snapshot.data as dynamic)['weather'][0]['main'] ==
                            'Rain') {
                      return Icon(
                        FontAwesomeIcons.cloudRain,
                        size: 70,
                      );
                    } else if (snapshot.hasData &&
                        (snapshot.data as dynamic)['weather'][0]['main'] ==
                            'Haze') {
                      return Icon(
                        FontAwesomeIcons.smog,
                        size: 70,
                      );
                    } else if (snapshot.hasData &&
                        (snapshot.data as dynamic)['weather'][0]['main'] ==
                            'Fog') {
                      return Icon(
                        FontAwesomeIcons.cloudflare,
                        size: 70,
                      );
                    } else
                      return CircularProgressIndicator();
                  },
                ),
              ),
              SizedBox(height: 5),
              Center(
                child: FutureBuilder(
                  future: getData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        '${(snapshot.data as dynamic)['weather'][0]['description']}',
                        style: TextStyle(fontSize: 20),
                      );
                    } else
                      return CircularProgressIndicator();
                  },
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Temperature: ',
                    style: TextStyle(fontSize: 20),
                  ),
                  FutureBuilder(
                      future: getData(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var z = (snapshot.data as dynamic)['main']['temp'];
                          var y = double.parse('$z');
                          y = z - 273.15;
                          var x = y.toStringAsFixed(1);
                          return Text(
                            '$x C',
                            style: TextStyle(fontSize: 20),
                          );
                        } else
                          return CircularProgressIndicator();
                      }),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Feels Like: ',
                    style: TextStyle(fontSize: 20),
                  ),
                  FutureBuilder(
                      future: getData(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var z =
                              (snapshot.data as dynamic)['main']['feels_like'];
                          var y = double.parse('$z');
                          y = z - 273.15;
                          var x = y.toStringAsFixed(1);
                          return Text(
                            '$x C',
                            style: TextStyle(fontSize: 20),
                          );
                        } else
                          return CircularProgressIndicator();
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> getData() async {
    var data;
    Network network = Network(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=ebee7fa22892e972a61b7ed30e563756');
    data = network.fetchData();
    //xbackgroundColor = Colors.pink;
    return data;
  }
}
