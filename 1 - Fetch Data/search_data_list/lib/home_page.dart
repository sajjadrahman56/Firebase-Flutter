import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String name = "";
  List<Map<String, dynamic>> data = [
    {'name': 'rahim', 'age': 29},
    {'name': 'galiv', 'age': 22},
    {'name': 'sami', 'age': 25},
    {'name': 'sajjad', 'age': 28},
  ];

  addData() async {
    for (var element in data) {
      FirebaseFirestore.instance.collection('users').add(element);
    }
  }

  @override
  void initState() {
    super.initState();
    //addData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Card(
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (val) {
                setState(() {
                  name = val;
                });
              },
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshots) {
            return (snapshots.connectionState == ConnectionState.waiting)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: snapshots.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshots.data!.docs[index].data()
                          as Map<String, dynamic>;

                      if (name.isEmpty) {
                        return ListTile(
                          title: Text(
                            data['name'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          leading: CircleAvatar(
                            backgroundColor: Colors.red,
                          ),
                        );
                      }

                      if (data['name']
                          .toString()
                          .startsWith(name.toLowerCase())) {
                        return ListTile(
                          title: Text(
                            data['name'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                TextStyle(color: Colors.black45, fontSize: 16),
                          ),
                          // subtitle: Text(
                          //   data['age'],
                          //   maxLines: 1,
                          //   overflow: TextOverflow.ellipsis,
                          //   style:
                          //       TextStyle(color: Colors.black45, fontSize: 16),
                          // ),
                          leading: CircleAvatar(
                            backgroundColor: Colors.red,
                          ),
                        );
                      }

                      return Container(
                        color: Colors.orange,
                      );
                    });
          },
        ));
  }
}
