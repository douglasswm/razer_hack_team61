import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/services.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService auth = AuthService();
  final MambuService mambu = MambuService();
  var listProducts;
  var checkingBalance;

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    // mambu.getMambuCurrentAccount().then((value) {
    //   print(value);
    //   checkingBalance = value.balance;
    // });

    // Widget buildProductItem(int index, DocumentSnapshot document) {
    //   return Container(
    //     width: MediaQuery.of(context).size.width * 0.6,
    //     child: Card(
    //       color: Colors.purple[200],
    //       child: Container(
    //           child: Center(child: Image.network(document['images'][0]))),
    //     ),
    //   );
    // }

    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: true,
        body: Stack(children: <Widget>[
          Image.network(
              'https://i.pinimg.com/originals/8a/4d/bc/8a4dbc7c87a56ea8a897394cedd4bb5d.gif'),
          Column(
            children: <Widget>[
              SizedBox(
                height: 190.0,
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: Text(
                          "Hey,",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: Text(
                          "${user.displayName}!",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24.0),
                        topRight: Radius.circular(24.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          offset: const Offset(0.0, -6.0),
                          blurRadius: 6.0),
                    ],
                  ),
                  child: Column(children: <Widget>[
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0.0),
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              child: Text(
                                "Checking Account",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24.0,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: FutureBuilder(
                                future: mambu.getMambuCurrentAccount(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    print('no data');
                                    // setState(() {_isFriendRequestButtonVisible = true;});
                                    // _isFriendRequestButtonVisible = true;
                                    return Center(
                                        child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.purple)));
                                  } else {
                                    print("PRINTING");
                                    print(snapshot.data['availableBalance']);
                                    return Container(
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            "\$",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20.0,
                                            ),
                                          ),
                                          Text(
                                            '${snapshot.data['availableBalance']}',
                                            style: TextStyle(
                                              color: Colors.grey[900],
                                              fontSize: 48.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                }),
                          ),
                        ],
                      ),
                    ),
                    // StreamBuilder(
                    //     stream: Firestore.instance
                    //         .collection('products')
                    //         .snapshots(),
                    //     builder: (context, snapshot) {
                    //       if (!snapshot.hasData) {
                    //         return Center(
                    //             child: CircularProgressIndicator(
                    //                 valueColor: AlwaysStoppedAnimation<Color>(
                    //                     Colors.purple)));
                    //       } else {
                    //         listProducts = snapshot.data.documents;
                    //         print(listProducts.length);
                    //         return Container(
                    //           padding: EdgeInsets.symmetric(
                    //               horizontal: 14.0, vertical: 24.0),
                    //           height: MediaQuery.of(context).size.height * 0.35,
                    //           child: ListView.builder(
                    //             scrollDirection: Axis.horizontal,
                    //             itemCount: snapshot.data.documents.length,
                    //             itemBuilder: (context, index) =>
                    //                 buildProductItem(
                    //                     index, snapshot.data.documents[index]),
                    //           ),
                    //         );
                    //       }
                    //     }),
                  ]),
                ),
              ),
            ],
          ),
        ]));
  }
}
