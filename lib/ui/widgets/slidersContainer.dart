import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:yocut/data/models/sliderDetails.dart';
import 'package:yocut/utils/constants.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SlidersContainer extends StatefulWidget {
  final List<SliderDetails> sliders;
  const SlidersContainer({super.key, required this.sliders});

  @override
  State<SlidersContainer> createState() => _SlidersContainerState();
}

class _SlidersContainerState extends State<SlidersContainer> {
  int _currentSliderIndex = 0;

  Widget _buildDotIndicator(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.0),
      child: CircleAvatar(
        backgroundColor: index == _currentSliderIndex
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.75),
        radius: 3.0,
      ),
    );
  }

  Widget _buildSliderIndicator() {
    return SizedBox(
      height: 6,
      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.sliders.length, (index) => index)
              .map((index) => _buildDotIndicator(index))
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.sliders.isEmpty
        ? const SizedBox.shrink()
        // : Column(
        //     children: [
              // SizedBox(
                // width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height *
                    // Utils.appBarBiggerHeightPercentage,
                // child: CarouselSlider(
                  // items: widget.sliders
                      // .map(
                      //   (slider) => InkWell(
                      //     onTap: () async {
                      //       try {
                      //         final canLaunchLink = await canLaunchUrl(
                      //             Uri.parse(slider.link ?? ""));
                      //         if (canLaunchLink) {
                      //           launchUrl(Uri.parse(slider.link ?? ""));
                      //         }
                      //       } catch (e) {}
                      //     },
                      //     child: Container(
                      //       width: MediaQuery.of(context).size.width * (0.85),
                      //       decoration: BoxDecoration(
                      //         image: DecorationImage(
                      //           fit: BoxFit.cover,
                      //           image: CachedNetworkImageProvider(
                      //               slider.image ?? ""),
                      //         ),
                      //         borderRadius: BorderRadius.circular(25.0),
                      //       ),
                      //     ),
                      //   ),
                      // )
                      // .toList(),
                  // options: CarouselOptions(
                  //   viewportFraction: 1.0,
                  //   autoPlay: true,
                  //   autoPlayInterval: changeSliderDuration,
                  //   onPageChanged: (index, _) {
                  //     setState(() {
                  //       _currentSliderIndex = index;
                  //     });
                  //   },
                  // ),
          //       ),
          //     ),
          //     // const SizedBox(
          //     //   height: 20,
          //     // ),
          //     // _buildSliderIndicator(),
          //   ],
          // );
  }
}
