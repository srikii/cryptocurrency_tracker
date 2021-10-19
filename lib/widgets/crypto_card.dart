import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class CryptoCard extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> cryptoModel;

  const CryptoCard({
    Key? key,
    required this.cryptoModel,
  }) : super(key: key);

  @override
  State<CryptoCard> createState() => _CryptoCardState();
}

class _CryptoCardState extends State<CryptoCard> {
  final TextStyle headingStyle =
      const TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  final TextStyle subHeadingStyle =
      const TextStyle(fontSize: 18, fontWeight: FontWeight.w500);
  final TextStyle bodyStyle =
      const TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
  Map? data;
  String name = '';
  String price = '';
  String price_1h = '';
  String last1HrPrices = '';
  String lastUpdated = '';
  String percChange = '';

  int roundingOff = 4;

  @override
  void initState() {
    super.initState();
    data = widget.cryptoModel.data() as Map?;
    name = widget.cryptoModel["name"];
    price = double.tryParse(widget.cryptoModel["price"].toString())
            ?.toStringAsFixed(roundingOff) ??
        '';
    price_1h =
        double.tryParse(widget.cryptoModel["1h"]["price_change"].toString())
                ?.toStringAsFixed(roundingOff) ??
            '';
    last1HrPrices = "Price change in the last hour : \$" + price_1h.toString();
    double perc =
        double.tryParse(widget.cryptoModel['1h']['price_change_pct']) ?? 0;
    perc = perc * 100;
    percChange = perc.toStringAsFixed(roundingOff);
    var savedDateString = widget.cryptoModel["price_timestamp"].toString();
    DateTime tempDate = DateFormat("yyyy-MM-ddThh:mm:ssZ")
        .parse(savedDateString, true)
        .toLocal();
    lastUpdated = DateFormat("h:mm:ss a, d MMM yyyy").format(tempDate);
  }

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: ListTile(
        title: Row(
          children: [
            SvgPicture.network(
              "${data?['logo_url']}",
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 2),
            Text(name + '(${data?['symbol']})', style: subHeadingStyle),
          ],
        ),
        trailing: Text('\$' + price, style: headingStyle),
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (_) => bottomSheet,
          );
        },
      ),
    );
  }

  Widget get bottomSheet {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.network(
                "${data?['logo_url']}",
                width: 64,
                height: 64,
              ),
              const SizedBox(
                width: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name + '(${data?['symbol']})', style: headingStyle),
                  Text('\$' + price, style: subHeadingStyle),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(last1HrPrices + '($percChange%)', style: bodyStyle),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text('Prices last updated at $lastUpdated'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.grey.shade800),
              child: const Center(child: Text('Close')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
