import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../shared/shared.dart';
import '../services/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CreateGoalScreen extends StatefulWidget {
  @override
  _CreateGoalScreenState createState() => _CreateGoalScreenState();
}

class _CreateGoalScreenState extends State<CreateGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService auth = AuthService();
  final MambuService mambu = MambuService();
  var goalSavingsAccId;
  var mambuClientId = DotEnv().env['mambu_client_id'];

  String category = '';
  String name = '';
  String amount = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.purple),
          elevation: 0.0,
          backgroundColor: Colors.white10,
          title: Text(
            'Add a saving goal',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
            ),
          ),
        ),
        body: Container(
            margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
            child: Builder(
                builder: (context) => Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          DropDownFormField(
                            value: category,
                            onChanged: (val) {
                              setState(() {
                                category = val;
                              });
                            },
                            titleText: 'Category',
                            dataSource: [
                              {
                                "display": "Concert",
                                "value": "🎉",
                              },
                              {
                                "display": "Travel",
                                "value": "🛫",
                              },
                              {
                                "display": "Luxury",
                                "value": "💸",
                              },
                              {
                                "display": "Gadgets",
                                "value": "📱",
                              }
                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 18.0),
                          ),
                          TextFormField(
                            onChanged: (val) {
                              setState(() {
                                name = val;
                              });
                            },
                            cursorColor: Colors.purple,
                            decoration: InputDecoration(
                                focusColor: Colors.purple,
                                fillColor: Colors.purple,
                                hoverColor: Colors.purple,
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.purple[200])),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.purple[100])),
                                errorBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.red[700])),
                                labelText: 'Goal name',
                                labelStyle: TextStyle(color: Colors.grey[700])),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please input name';
                              }
                              return null;
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 18.0),
                          ),
                          TextFormField(
                            onChanged: (val) {
                              setState(() {
                                amount = val;
                              });
                            },
                            keyboardType: TextInputType.number,
                            cursorColor: Colors.purple,
                            decoration: InputDecoration(
                                prefixText: 'S\$',
                                // hintText: 'S\$',
                                hintStyle: TextStyle(color: Colors.grey),
                                focusColor: Colors.purple,
                                fillColor: Colors.purple,
                                hoverColor: Colors.purple,
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.purple[200])),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.purple[100])),
                                errorBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.red[700])),
                                labelText: 'Goal amount',
                                labelStyle: TextStyle(color: Colors.grey[700])),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please input amount';
                              }
                              return null;
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 18.0),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: RaisedButton.icon(
                              icon: Icon(
                                Icons.call_made,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                // Validate returns true if the form is valid, or false
                                // otherwise.
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();

                                  mambu
                                      .createSavingGoalsAccount(mambuClientId)
                                      .then((value) {
                                        print(value);
                                    goalSavingsAccId = value['savingsAccount']['id'];
                                    var documentReference = Firestore.instance
                                        .collection('users')
                                        .document(user.uid)
                                        .collection('goals')
                                        .document();
                                    Firestore.instance
                                        .runTransaction((transaction) async {
                                      await transaction
                                          .set(documentReference, {
                                            'goal_name': name,
                                            'category': category,
                                            'goal_amount': 'S\$$amount',
                                            'current_amount': 0,
                                            'mambuGoalSavingsAccId':
                                                goalSavingsAccId
                                          })
                                          .catchError((e) {})
                                          .whenComplete(() {});
                                    }).catchError((e) {
                                      return false;
                                    });
                                  });

                                  Navigator.pushReplacementNamed(
                                      context, '/loggedin');
                                }
                              },
                              color: Colors.purple,
                              label: Text(
                                'Submit',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))));
  }
}
