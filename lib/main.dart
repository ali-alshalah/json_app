import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter json',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'dev by Ali Alshalah'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<User>> _getUsers() async {
    var data = await http
        .get("http://www.json-generator.com/api/json/get/bYKKPeXRcO?indent=2");
    var jesonData = json.decode(data.body);
    List<User> users = [];
    for (var u in jesonData) {
      User user = User(u["index"], u["about"], u["name"], u["picture"],
          u["company"], u["email"]);
      users.add(user);
    }
    print("the Number is " + users.length.toString());
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: FutureBuilder(
          future: _getUsers(),
          builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
            if (asyncSnapshot.data == null) {
              return Container(
                child: Center(
                  child: Text(
                    "Loading ........",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: asyncSnapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(asyncSnapshot.data[index].name),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          asyncSnapshot.data[index].picture +
                              asyncSnapshot.data[index].index.toString() +
                              ".jpg"),
                    ),
                    subtitle: Text(asyncSnapshot.data[index].email),
                    onTap: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) =>
                                  DetailPage(asyncSnapshot.data[index])));
                    },
                  );
                },
              );
            }
          },
        ));
  }
}

class User {
  final int index;
  final String about;
  final String name;
  final String picture;
  final String company;
  final String email;

  User(this.index, this.about, this.name, this.picture, this.company,
      this.email);
}

class DetailPage extends StatelessWidget {
  final User user;

  DetailPage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image:
                  NetworkImage(user.picture + user.index.toString() + ".jpg"),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Name :- ", style: TextStyle(fontSize: 18)),
                Text(this.user.name),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Company :- ", style: TextStyle(fontSize: 18)),
                Text(this.user.company),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("email :- ", style: TextStyle(fontSize: 18)),
                Text(this.user.email),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text("About :- ", style: TextStyle(fontSize: 18)),
            Text(this.user.about),
            SizedBox(
              height: 70,
            ),
            Text("Ali Alshalah (*_^)")
          ],
        ),
      ),
    );
  }
}
