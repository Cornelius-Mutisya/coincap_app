import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final Map rates;
  const DetailsPage({Key? key, required this.rates}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List _currencies = rates.keys.toList();
    List _exchangeRates = rates.values.toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exchange Rates'),
        backgroundColor: const Color.fromRGBO(83, 88, 206, 0.5),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: _currencies.length,
          itemBuilder: (ctx, i) {
            String _currency = _currencies[i].toString().toUpperCase();
            String _exchangeRate = _exchangeRates[i].toString();
            return ListTile(
              // title: Text(
              //   "$_currency: $_exchangeRate",
              // ),
              title: RichText(
                text: TextSpan(
                  text: _currency,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  children: [
                    TextSpan(
                      text: ' : $_exchangeRate',
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
