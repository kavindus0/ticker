import 'package:flutter/material.dart';
import 'package:ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:ticker/network.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  PriceScreenState createState() => PriceScreenState();
}

class PriceScreenState extends State<PriceScreen> {
  String currencyHighlight = 'LKR';

  DropdownButton<String> getDDBAndroid() {
    List<DropdownMenuItem<String>> itemList = [];
    for (String curr in currenciesList) {
      var eachItem = DropdownMenuItem(value: curr, child: Text(curr));
      itemList.add(eachItem);
    }
    return DropdownButton<String>(
      autofocus: true,
      iconSize: 55,
      icon: const Icon(Icons.currency_exchange),
      items: itemList,
      value: currencyHighlight,
      style: const TextStyle(fontSize: 33, color: Colors.black),
      onChanged: (value) {
        setState(() {
          currencyHighlight = value!;
        });
        print(value);
      },
    );
  }

  CupertinoPicker cupertinoDropdown() {
    List<Widget> widList = [];
    for (String curr in currenciesList) {
      var item = Text(curr);
      widList.add(item);
    }
    return CupertinoPicker(
      itemExtent: 28.0,
      onSelectedItemChanged: (value) {
        print(currenciesList[value]);
      },
      children: widList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CryptosCard(
            currencyHighlight: currencyHighlight,
            cryptoCurrency: 'BTC',
            cardColor: Colors.white,
          ),
          CryptosCard(
            currencyHighlight: currencyHighlight,
            cryptoCurrency: 'USD',
            cardColor: Colors.white,
          ),
          CryptosCard(
            currencyHighlight: currencyHighlight,
            cryptoCurrency: 'LKR',
            cardColor: Colors.white,
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.white30,
            child: (Platform.isIOS || Platform.isLinux)
                ? cupertinoDropdown()
                : getDDBAndroid(),
          ),
        ],
      ),
    );
  }
}

class CryptosCard extends StatelessWidget {
  const CryptosCard({
    super.key,
    required this.currencyHighlight,
    required this.cryptoCurrency,
    required this.cardColor,
  });

  final String currencyHighlight;
  final String cryptoCurrency;
  final Color cardColor;

  @override
  Widget build(BuildContext context) {
    Future<double> networkFunct() async {
      NetworkHelp netObj = NetworkHelp(cryptoCurrency, currencyHighlight);
      return await (netObj.fetchData());
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        borderOnForeground: true,
        color: cardColor,
        elevation: 5.0,
        semanticContainer: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: FutureBuilder<double>(
            future: networkFunct(),
            builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CupertinoActivityIndicator(
                    radius: 20.0,
                    color: CupertinoColors
                        .black); // or some other widget while waiting
              } else {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text(
                    '1 $cryptoCurrency = ${snapshot.data} $currencyHighlight',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 30.0,
                      color: Colors.black,
                    ),
                  ); // widget to return when data is available
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
