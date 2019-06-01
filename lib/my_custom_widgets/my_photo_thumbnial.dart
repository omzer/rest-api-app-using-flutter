import 'package:flutter/material.dart';
import 'package:rest_test/my_custom_widgets/my_text.dart';

class MyPhotoThumbnail extends StatelessWidget {
  final String thumbnailUrl, url, title;
  final Function function;
  MyPhotoThumbnail({
    this.url,
    this.thumbnailUrl,
    this.title,
    this.function,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => function(url, title),
      child: Stack(
        children: <Widget>[
          FadeInImage.assetNetwork(
            image: thumbnailUrl,
            placeholder: 'lib/assets/loading.png',
          ),
          Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                width: 150,
                color: Colors.black.withOpacity(.3),
                child: MyText(
                  content: title,
                  size: 12.0,
                  overflow: TextOverflow.ellipsis,
                  color: Colors.white,
                  align: TextAlign.center,
                ),
              ))
        ],
      ),
    );
  }
}
