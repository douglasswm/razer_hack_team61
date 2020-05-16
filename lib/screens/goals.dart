import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/services.dart';
import 'package:provider/provider.dart';

class GoalScreen extends StatefulWidget {
  @override
  _GoalScreenState createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  final AuthService auth = AuthService();
  var listGoals;
  var listSavings;
  int valueSavings;
  List<int> values = new List();

  Widget buildGoalItem(int index, DocumentSnapshot document) {
    return Card(
      child: ListTile(
          leading: Text(document['category'],
              style: TextStyle(
                fontSize: 24.0,
              )),
          title: Text(document['goal_name']),
          trailing: Text(document['goal_amount'])),
    );
  }

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white10,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.purple,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Text(
                      "Savings",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Text(
                          "\$",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                          ),
                        ),
                        FutureBuilder(
                          future: null,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                        return Center(
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.purple)));
                      } else {
                        print("length");
                        listSavings = snapshot.data.documents;
                        print(listSavings);
                        for(var doc in listSavings){
                          
                          print(doc.data['current_amount']);
                          values.add(doc.data['current_amount']);
                          print(values);
                          
                        }

                        return Text(
                              "854.13",
                              style: TextStyle(
                                color: Colors.grey[900],
                                fontSize: 48.0,
                              ),
                            );
                      }
                            
                          }
                        )
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 5.0,
                          backgroundColor: Colors.teal[300],
                        ),
                        Text(
                          "   SPARE CHANGE SAVING IS ON",
                          style: TextStyle(
                              color: Colors.black38,
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Text(
                      "Goals",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: 5.0),
                StreamBuilder(
                    stream: Firestore.instance
                        .collection('users')
                        .document(user.uid)
                        .collection('goals')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.purple)));
                      } else {
                        listGoals = snapshot.data.documents;
                        // print(listGoals.length);
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.35,
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (context, index) => buildGoalItem(
                                index, snapshot.data.documents[index]),
                          ),
                        );
                      }
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
