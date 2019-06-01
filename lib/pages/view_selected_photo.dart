import 'package:flutter/material.dart';
import 'package:rest_test/my_custom_widgets/my_text.dart';

class ViewPhoto extends StatelessWidget {
  final String url, title;

  ViewPhoto({
    this.url,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Selected photo')),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            MyText(
              size: 18,
              content: 'Title:\n$title',
              isBold: true,
              color: Colors.blueGrey,
            ),
            SizedBox(height: 38.0),
            FadeInImage.assetNetwork(
              image: url,
              placeholder: 'lib/assets/loading.png',
            ),
          ],
        ),
      ),
    );
  }
}
