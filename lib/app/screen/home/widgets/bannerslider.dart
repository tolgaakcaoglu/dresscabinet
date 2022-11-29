import 'package:carousel_slider/carousel_slider.dart';
import 'package:dresscabinet/app/constants/constwidgets.dart';
import 'package:dresscabinet/app/functions/jsonfunc.dart';
import 'package:dresscabinet/app/modals/categorymodal.dart';
import 'package:dresscabinet/app/modals/clientmodal.dart';
import 'package:dresscabinet/app/modals/productmodal.dart';
import 'package:dresscabinet/app/modals/settingsmodal.dart';
import 'package:dresscabinet/app/modals/slidermodal.dart';
import 'package:dresscabinet/app/screen/search/searchscreen.dart';
import 'package:dresscabinet/app/utils/navigate.dart';
import 'package:dresscabinet/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BannerSlider extends StatefulWidget {
  final List allCategories;
  final Client client;
  final List<Product> products;
  final ConstSettings settings;
  const BannerSlider(
      {Key key,
      @required this.allCategories,
      @required this.products,
      @required this.client,
      @required this.settings})
      : super(key: key);

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  final CarouselController controller = CarouselController();
  int slideIndex = 0;

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isDark = brightness == Brightness.dark ? true : false;
    Size size = MediaQuery.of(context).size;
    return FutureBuilder<List>(
      future: JsonFunctions.getSlides(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          const AspectRatio(
            aspectRatio: 8 / 7,
            child: Center(child: Text('İnternet bağlantınızı kontrol edin')),
          );
        }
        if (snapshot.hasData && snapshot.data != null) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CarouselSlider.builder(
                carouselController: controller,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index, realIndex) {
                  Slide slide = Slide.fromJson(snapshot.data[index]);
                  return _buildItem(
                    size,
                    slide,
                    widget.allCategories,
                    widget.products,
                  );
                },
                options: CarouselOptions(
                  aspectRatio: 8 / 7,
                  viewportFraction: 1,
                  autoPlay: true,
                  autoPlayAnimationDuration: const Duration(milliseconds: 1000),
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index, reason) {
                    setState(() => slideIndex = index);
                  },
                ),
              ),
              _buildIndicator(snapshot, isDark)
            ],
          );
        }

        return Column(
          children: [
            AspectRatio(
              aspectRatio: 8 / 7,
              child: Image.asset(
                'assets/images/no_image.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 4.0,
                vertical: 12.0,
              ),
              width: 24.0,
              height: 4.0,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ],
        );
      },
    );
  }

  Row _buildIndicator(AsyncSnapshot<List<dynamic>> snapshot, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: snapshot.data.asMap().entries.map(
        (e) {
          return InkWell(
            onTap: () => controller.animateToPage(e.key),
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 4.0,
                vertical: 12.0,
              ),
              width: 24.0,
              height: 4.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.0),
                color: e.key == slideIndex
                    ? isDark
                        ? Colors.grey.shade300
                        : Colors.grey.shade800
                    : isDark
                        ? Colors.grey.shade800
                        : Colors.grey.shade300,
              ),
            ),
          );
        },
      ).toList(),
    );
  }

  _buildItem(Size size, Slide slide, List all, List<Product> products) {
    Category getCategory() {
      String key;

      key = slide.key.split('q=').last;
      if (!slide.key.contains('q=')) {
        List<String> splittedUrl = slide.key.split('/');
        key = splittedUrl[splittedUrl.length - 2];
      }

      Category c;

      for (Category cat in all) {
        if (ConstUtils.cleanText(cat.name) == ConstUtils.cleanText(key)) {
          c = cat;
        }
      }

      return c;
    }

    return InkWell(
      onTap: () {
        slide.key == null || slide.key == ''
            ? Fluttertoast.showToast(msg: '💝')
            : Navigate.next(
                context,
                SearchScreen(
                    settings: widget.settings,
                    category: getCategory(),
                    client: widget.client,
                    products: products));
      },
      child: SizedBox(
        width: size.width,
        child: ConstWidgets.viewImage(slide.image),
      ),
    );
  }
}
