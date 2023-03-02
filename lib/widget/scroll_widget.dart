import 'dart:convert' as convert;

import 'package:customscrollview/widget/custom_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '/models/apiModel.dart';
import 'HeaderWidget.dart';
import 'ImageWidget.dart';
import 'TextWidget.dart';

class Scrollview extends StatefulWidget {
  const Scrollview({super.key});

  @override
  _ScrollviewState createState() => _ScrollviewState();
}

class _ScrollviewState extends State<Scrollview> {
  final List<Apimodel> _items = [];
  final scrollController = ScrollController();
  @override
  void initState() {
    _apiCall();
    super.initState();
  }

  bool _apisuccess = true;
  bool _callFinsih = false;

  Future<void> _apiCall() async {
    // function to get api call and store data in List
    const String url =
        "http://website-bucket-12234.s3-website-us-east-1.amazonaws.com/api.json";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      if (jsonResponse['success']) {
        setState(() {
          _apisuccess = false;
        });
        Apimodel headerComp = Apimodel(
          type: 'header',
          title: jsonResponse['data']['title'],
          url: jsonResponse['data']['coverUrl'],
        );
        _items.add(headerComp);

        for (var i in jsonResponse['data']['components']) {
          if (i['type'] == 'text') {
            Apimodel temp =
                 Apimodel(type: 'text', desc: i['desc'], title: i['title']);

            _items.add(temp);
          }
          if (i['type'] == 'image') {
            Apimodel temp =  Apimodel(type: 'image', url: i['url']);
            _items.add(temp);
          }
        }

        setState(() {
          _callFinsih = true;
        });
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return _apisuccess
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.grey,
            ),
          )
        : _callFinsih
            ? CustomScrollbar(
                controller: scrollController,
                crossaxis: 30,
                length: 600,
                mainaxis: 30,
                strokeWidth: 5,
                thumbColor: Colors.white,
                trackColor: Colors.white24,
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: _items.length,
                  itemBuilder: (ctx, index) {
                    return Column(
                      children: <Widget>[
                        _items[index].type == 'header'
                            ? HeaderCard(
                                // card for header data
                                _items[index],
                              )
                            : const SizedBox(
                                height: 0,
                              ),
                        _items[index].type == 'text'
                            ? TextCard(
                                // card for text data
                                textcard: _items[index],
                              )
                            : const SizedBox(
                                height: 0,
                              ),
                        _items[index].type == 'image'
                            ? ImageCard(
                                // card for image data
                                imagecard: _items[index],
                              )
                            : const SizedBox(
                                height: 0,
                              ),
                      ],
                    );
                  },
                ),
              )
            : const CircularProgressIndicator();
  }
}
