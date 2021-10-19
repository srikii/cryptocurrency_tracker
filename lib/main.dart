//flutter emulators --launch Pixel_2_API_30

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptocurrency_tracker/widgets/crypto_card.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:intl/intl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const FireStoreApp());
}

class FireStoreApp extends StatefulWidget {
  const FireStoreApp({Key? key}) : super(key: key);

  @override
  _FireStoreAppState createState() => _FireStoreAppState();
}

class _FireStoreAppState extends State<FireStoreApp> {
  CollectionReference cryptos =
      FirebaseFirestore.instance.collection('cryptos');
  CollectionReference news = FirebaseFirestore.instance.collection('news');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: (const Text('Crypto Tracker')),
          backgroundColor: Colors.teal,
        ),
        body: StreamBuilder(
          stream: cryptos.orderBy('name').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Text("Loading"));
            }
            return new Column(
              children: [
                new ListView(
                  shrinkWrap: true,
                  children: snapshot.data!.docs
                      .map((model) => new CryptoCard(cryptoModel: model))
                      .toList(),
                ),
                Spacer(),
              ],
            );
          },
        ),
      ),
    );
  }
}
