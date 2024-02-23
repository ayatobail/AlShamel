import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CarouselSliderImages extends StatefulWidget {
  const CarouselSliderImages({
    Key? key,
    required this.containerHeight,
    required this.images,
  }) : super(key: key);

  final double containerHeight;
  final List<String> images;

  @override
  _CarouselSliderImagesState createState() => _CarouselSliderImagesState();
}

class _CarouselSliderImagesState extends State<CarouselSliderImages> {
  int _current = 0;
  bool isloading = false;
  late File img;

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = widget.images.map((item) {
      return InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullScreenPage(
              imgurl: item,
            ),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            child: CachedNetworkImage(
              imageUrl: item,
              cacheKey: item+DateTime.now().second.toString(),
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(
                      child: CircularProgressIndicator(
                          value: downloadProgress.progress)),
              //placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            // child: Image.network(
            //   item,
            //   fit: BoxFit.cover,
            // ),
          ),
        ),
      );
    }).toList();
    return Container(
      height: widget.containerHeight,
      color: Theme.of(context).primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: widget.containerHeight * .92,
            child: CarouselSlider(
              items: imageSliders,
              options: CarouselOptions(
                  autoPlay: true,
                  initialPage: 0,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
            ),
          ),
          Container(
            height: widget.containerHeight * .08,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.images.map((url) {
                int index = widget.images.indexOf(url);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(
                    vertical: 2.0,
                    horizontal: 2.0,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index ? Colors.white : Colors.white30,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class FullScreenPage extends StatelessWidget {
  final String imgurl;
  FullScreenPage({required this.imgurl});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: InteractiveViewer(
        //panEnabled: false, // Set it to false to prevent panning.
        boundaryMargin: EdgeInsets.all(80),
        child: Container(
          child: CachedNetworkImage(
            imageUrl: imgurl??"",
              cacheKey: imgurl!+DateTime.now().second.toString(),
          ),
        ),
      ),
    );
  }
}
