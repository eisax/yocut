import 'package:cached_network_image/cached_network_image.dart';
import 'package:yocut/app/routes.dart';
import 'package:yocut/cubits/schoolConfigurationCubit.dart';
import 'package:yocut/cubits/schoolGalleryCubit.dart';
import 'package:yocut/data/models/student.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SchoolGalleryContainer extends StatelessWidget {
  final Student student;
  const SchoolGalleryContainer({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SchoolGalleryCubit, SchoolGalleryState>(
      builder: (context, state) {
        if (state is SchoolGalleryFetchSuccess) {
          final schoolGallery = state.gallery;
          if (schoolGallery.isEmpty) {
            return const SizedBox();
          }
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Utils.screenContentHorizontalPadding),
                child: Row(
                  children: [
                    Text(
                      Utils.getTranslatedLabel(galleryKey),
                      style: TextStyle(
                        color: Utils.getColorScheme(context).secondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        Get.toNamed(Routes.schoolGallery, arguments: student);
                      },
                      child: Text(
                        Utils.getTranslatedLabel(viewAllKey),
                        style: TextStyle(
                          color: Utils.getColorScheme(context).onSurface,
                          fontSize: 13.0,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 220,
                child: ListView.builder(
                    padding: EdgeInsets.symmetric(
                        horizontal: Utils.screenContentHorizontalPadding),
                    scrollDirection: Axis.horizontal,
                    itemCount: schoolGallery.length,
                    itemBuilder: (context, index) {
                      final gallery = schoolGallery[index];
                      final photosAndVideosCountTextStyle = TextStyle(
                          fontSize: 12.0,
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withValues(alpha: 0.65));
                      return Padding(
                        padding: EdgeInsetsDirectional.only(end: 20),
                        child: SizedBox(
                          width: 145,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(Routes.galleryDetails,
                                      arguments: {
                                        "gallery": gallery,
                                        "sessionYear": context
                                            .read<SchoolConfigurationCubit>()
                                            .getSchoolConfiguration()
                                            .sessionYear
                                      });
                                },
                                child: SizedBox(
                                  width: 145,
                                  height: 145,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        Utils.bottomSheetTopRadius),
                                    child: gallery.isThumbnailSvg()
                                        ? SvgPicture.network(
                                            gallery.thumbnail ?? "")
                                        : CachedNetworkImage(
                                            imageUrl: gallery.thumbnail ?? "",
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                (gallery.title ?? ""),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  height: 1.0,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  gallery.getImages().isNotEmpty
                                      ? Text(
                                          "${gallery.getImages().length} ${Utils.getTranslatedLabel(photosKey)}",
                                          style: photosAndVideosCountTextStyle,
                                        )
                                      : const SizedBox(),
                                  gallery.getVideos().isNotEmpty &&
                                          gallery.getImages().isNotEmpty
                                      ? Text(
                                          " | ",
                                          style: photosAndVideosCountTextStyle,
                                        )
                                      : const SizedBox(),
                                  gallery.getVideos().isNotEmpty
                                      ? Text(
                                          "${gallery.getVideos().length} ${Utils.getTranslatedLabel(videosKey)}",
                                          style: photosAndVideosCountTextStyle,
                                        )
                                      : const SizedBox(),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }
}
