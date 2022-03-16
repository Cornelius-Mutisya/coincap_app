import 'dart:convert';

import 'package:coincap/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double? _deviceHeight, _deviceWidth;

  String? _selectedCoin = 'bitcoin';

  HTTPService? _httpService;
  @override
  void initState() {
    super.initState();
    _httpService = GetIt.instance.get<HTTPService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _selectedCoinDropdown(),
              _dataWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectedCoinDropdown() {
    List<String> _coins = [
      'bitcoin',
      'ethereum',
      'tether',
      'cardano',
      'ripple'
    ];
    List<DropdownMenuItem<String>> _dropdownItems = _coins
        .map(
          (e) => DropdownMenuItem(
            value: e,
            child: Text(
              e,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        )
        .toList();
    return DropdownButton(
      value: _selectedCoin,
      items: _dropdownItems,
      onChanged: (value) {
        setState(() {
          _selectedCoin = value.toString();
        });
      },
      dropdownColor: const Color.fromRGBO(83, 88, 206, 1.0),
      iconSize: 30,
      icon: const Icon(
        Icons.arrow_drop_down_sharp,
        color: Colors.white,
      ),
      underline: Container(),
    );
  }

  Widget _dataWidget() {
    return FutureBuilder(
      future: _httpService!.get('/coins/$_selectedCoin'),
      builder: (BuildContext ctx, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          Map _data = jsonDecode(snapshot.data.toString());

          num _usdPrice = _data['market_data']['current_price']['usd'];
          num _change24h = _data['market_data']['price_change_percentage_24h'];
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _coinImageWidget(_data['image']['large']),
              _currentPriceWidget(_usdPrice),
              _percentageChangeWidget(_change24h),
              _descriptionCardWidget(_data['description']['en']),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }
      },
    );
  }

  Widget _currentPriceWidget(num _rate) {
    return Text(
      "${_rate.toStringAsFixed(2)} USD",
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _percentageChangeWidget(num _change) {
    return Text(
      _change >= 0 ? '+${_change.toString()}%' : '-${_change.toString()}%',
      // "${_change.toString()} %",
      style: TextStyle(
        color: _change >= 0 ? Colors.green : Colors.red,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _coinImageWidget(String _imgUrl) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: _deviceHeight! * 0.01),
      height: _deviceHeight! * 0.15,
      width: _deviceWidth! * 0.15,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(
          _imgUrl,
        )),
      ),
    );
  }

  Widget _descriptionCardWidget(String _description) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: _deviceHeight! * 0.05),
      height: _deviceHeight! * 0.45,
      width: _deviceWidth! * 0.90,
      padding: EdgeInsets.symmetric(
        vertical: _deviceHeight! * 0.01,
        horizontal: _deviceWidth! * 0.01,
      ),
      color: const Color.fromRGBO(83, 88, 206, 0.5),
      child: Text(
        _description,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
