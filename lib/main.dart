import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EC2 Instance',
      home: Scaffold(
        appBar: AppBar(
          title: Text('EC2 Instance'),
        ),
        body: EC2Instance(),
      ),
    );
  }
}

class EC2Instance extends StatefulWidget {
  @override
  _EC2InstanceState createState() => _EC2InstanceState();
}

class _EC2InstanceState extends State<EC2Instance> {
  final String apiUrl = 'http://10.0.2.2:8080';
  String instanceId = '';

  void createInstance() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/api/ec2/create'));
      final data = response.body;
      setState(() {
        instanceId = data;
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('EC2 instance created'),
          content: Text('Instance ID: $instanceId'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (error, stackTrace) {
      print('Failed with error: $error');
    }

  }


  void terminateInstance() async {
    final inputController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enter instance ID:'),
        content: TextField(
          controller: inputController,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              instanceId = inputController.text;
              try {
                final response = await http.get(Uri.parse(
                    '$apiUrl/api/ec2/terminate?instance_id=$instanceId'));
                setState(() {
                  instanceId = 'null';
                });
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('EC2 instance terminated'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              } catch (error) {
                print('Failed');
              }
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ElevatedButton(
          onPressed: createInstance,
          child: Text('Create EC2 Instance'),
        ),
        ElevatedButton(
          onPressed: terminateInstance,
          child: Text('Terminate EC2 Instance'),
        ),
      ],
    );
  }
}
