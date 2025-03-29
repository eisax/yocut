import 'package:cached_network_image/cached_network_image.dart';
import 'package:yocut/data/models/galleryFile.dart';
import 'package:yocut/data/models/studyMaterial.dart';
import 'package:yocut/ui/widgets/customAppbar.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

import '../widgets/studyMaterialWithDownloadButtonContainer.dart';

class GalleryImagesScreen extends StatefulWidget {
  final List<GalleryFile> images;
  final int currentImageIndex;
  GalleryImagesScreen(
      {Key? key, required this.currentImageIndex, required this.images})
      : super(key: key);

  static Widget routeInstance() {
    final arguments = Get.arguments as Map<String, dynamic>;
    return GalleryImagesScreen(
        currentImageIndex: arguments['currentImageIndex'],
        images: arguments['images']);
  }

  @override
  State<GalleryImagesScreen> createState() => _GalleryImagesScreenState();
}

class _GalleryImagesScreenState extends State<GalleryImagesScreen> {
  late final PageController _pageController =
      PageController(initialPage: widget.currentImageIndex);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height *
                    (Utils.appBarSmallerHeightPercentage)),
            child: PageView.builder(
                controller: _pageController,
                itemCount: widget.images.length,
                itemBuilder: (context, index) {
                  final galleryImage = widget.images[index];
                  return LayoutBuilder(builder: (context, boxConstraints) {
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: StudyMaterialWithDownloadButtonContainer(
                            boxConstraints: boxConstraints,
                            studyMaterial: StudyMaterial(
                                fileExtension: galleryImage.fileExtension!,
                                fileUrl: galleryImage.fileUrl!,
                                fileThumbnail: galleryImage.fileThumbnail!,
                                fileName: galleryImage.fileName!,
                                id: galleryImage.id!,
                                studyMaterialType: StudyMaterialType.file),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height *
                                  (Utils.appBarSmallerHeightPercentage)),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: PinchZoom(
                              maxScale: 5,
                              child: galleryImage.isSvgImage()
                                  ? SvgPicture.network(
                                      galleryImage.fileUrl ?? "")
                                  : CachedNetworkImage(
                                      imageUrl: galleryImage.fileUrl ?? ""),
                            ),
                          ),
                        ),
                      ],
                    );
                  });
                }),
          ),
          CustomAppBar(
            title: "",
          ),
        ],
      ),
    );
  }
}
