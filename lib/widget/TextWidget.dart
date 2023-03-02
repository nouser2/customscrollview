import 'package:flutter/material.dart';

import '/models/apiModel.dart';

class TextCard extends StatelessWidget {
  final Apimodel textcard;
  const TextCard({required this.textcard});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      decoration: BoxDecoration(color: Colors.yellow[200]),
      width: double.infinity,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              child: Text(
                textcard.title,
                // textAlign: TextAlign.start,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          SizedBox(
            height: 5,
            width: double.infinity,
          ),
          Text(
            textcard.desc,
            style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 16,
          )
        ],
      ),
    );
  }
}
