import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mqtt_client/mqtt_client.dart';

import 'mqtt_client.dart';

void main() {
  runApp(MyApp());
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
      home: MyHomePage(title: 'MQTT IoT Simulator'),
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  void getData() async{
    try {
      var url = Uri.parse('https://jsonplaceholder.typicode.com/todos/1');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        print(response.body);
      } else {
        print('Error ${response.statusCode}');
        print('This is error');
      }
    }catch(HandshakeException){
      print(HandshakeException.toString());
      print("hand Error");
    }
  }

  late MqttClient client;
  void _publish(String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString('Hello from flutter_client');
    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload);
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();

  }

  final GlobalKey<FormState> _formKey = GlobalKey();
  late String clientId;
  late String brokerAddress;
  late String port;
  late String topic;
  late String username;
  late String password;
  late String data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              margin: EdgeInsets.all(30.0),
              child: Column(
               
                children: <Widget>[

                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Client ID',
                    ),
                    validator: (text){
                      if(text!.isEmpty){
                        return 'Cannot be empty';
                      }
                    },
                    onSaved: (text){
                        clientId=text!;
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Broker Address',
                    ),
                    validator: (text){
                      if(text!.isEmpty){
                        return 'Cannot be empty';
                      }
                    },
                    onSaved: (text){
                      brokerAddress=text!;
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Port',
                    ),
                    validator: (text){
                      if(text!.isEmpty){
                        return 'Cannot be empty';
                      }
                    },
                    onSaved: (text){
                      port=text!;
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Topic',
                    ),
                    validator: (text){
                      if(text!.isEmpty){
                        return 'Cannot be empty';
                      }
                    },
                    onSaved: (text){
                      topic=text!;
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Username',
                    ),
                    validator: (text){
                      if(text!.isEmpty){
                        return 'Cannot be empty';
                      }
                    },
                    onSaved: (text){
                      username=text!;
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Password',
                    ),
                    obscureText: true,
                    validator: (text){
                      if(text!.isEmpty){
                        return 'Cannot be empty';
                      }
                    },
                    onSaved: (text){
                      password=text!;
                    },
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Data',
                      filled: true,
                      border: InputBorder.none,
                    ),
                    validator: (text){
                      if(text!.isEmpty){
                      }
                    },
                    onSaved: (text){
                      data=text!;
                    },
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  ElevatedButton(onPressed: (){
                    if(_formKey.currentState!.validate()){
                      _formKey.currentState!.save();
                    }
                  },
                      child: Text('Publish')),
                  Row(
                    children: [
                      ElevatedButton(onPressed: (){
                        connect().then((value) {
                          client = value;
                        });
                      },
                          child: Text('Connect')),
                      // ElevatedButton(
                      //   child: Text('Subscribe'),
                      //   onPressed: () {
                      //     return {client?.subscribe(topic)};
                      //   },
                      // ),
                      ElevatedButton(
                        child: Text('Publish'),
                        onPressed: () => {this._publish('Hello')},
                      ),
                      ElevatedButton(
                        child: Text('Unsubscribe'),
                        onPressed: () => {client.unsubscribe(topic)},
                      ),
                      ElevatedButton(
                        child: Text('Disconnect'),
                        onPressed: () => {client.disconnect()},
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
      ),

    );
  }
}



