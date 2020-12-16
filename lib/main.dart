import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import  'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class DataStreams {
  // ignore: close_sinks
  final BehaviorSubject<double> latt=BehaviorSubject.seeded(0.0);
  // ignore: close_sinks
  final BehaviorSubject<double> long=BehaviorSubject.seeded(0.0);
  // ignore: close_sinks
  final BehaviorSubject<dynamic> data =BehaviorSubject.seeded(['']);

  void feed() async{
    // https://www.metaweather.com/api/location/search/?lattlong=36.96,-122.02
    String _url="https://www.metaweather.com/api/location/search/?lattlong=${latt.value},${long.value}";
    print("$_url");
    var _response = (await Dio().get(_url));
    data.value=_response.data;
  }


}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'metaweather: ближайшие города'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  DataStreams ds=DataStreams();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            TextField(

            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))
            ],
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Долгота',
              ),
              onChanged: (String value) => ds.long.value=double.tryParse(value),
            ),

            TextField(
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Широта',
              ),
              onChanged: (String value) => ds.latt.value=double.tryParse(value),
            ),

            Divider(),
            StreamBuilder(stream: ds.data,
            builder: (context, snapshot) => !snapshot.hasData ? Container() :
            Expanded(child: ListView.builder(itemCount: snapshot.data.length,
              itemBuilder: (context, index) =>
                  Text(snapshot.data[index].toString())
              , )),)


          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        onPressed: () => ds.feed(),
        child: Text("Запрос"),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
