import 'package:cached_network_image/cached_network_image.dart';
import 'package:dresscabinet/app/utils/navigate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

class ViewPhoto extends StatelessWidget {
  final String photo;
  const ViewPhoto({Key key, @required this.photo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: size.height,
                maxWidth: size.width,
              ),
              child: PinchZoom(
                maxScale: 2.5,
                child: Hero(
                    tag: photo, child: CachedNetworkImage(imageUrl: photo)),
              ),
            ),
          ),
          _closeButton(context, isDark),
        ],
      ),
    );
  }

  Align _closeButton(BuildContext context, bool isDark) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 32.0,
          child: CupertinoButton(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            color: isDark ? Colors.white24 : Colors.black26,
            child: Text(
              'Önizlemeyi Kapat',
              style: TextStyle(
                  fontSize: 12.0, color: isDark ? Colors.black : Colors.white),
            ),
            onPressed: () => Navigate.back(context),
          ),
        ),
      ),
    );
  }
}
