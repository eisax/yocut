import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SelectAttachmentBottomSheet extends StatefulWidget {
  const SelectAttachmentBottomSheet({
    super.key,
    required this.updateAttachments,
  });

  final void Function(List<XFile>) updateAttachments;

  @override
  State<SelectAttachmentBottomSheet> createState() =>
      _SelectAttachmentBottomSheetState();
}

class _SelectAttachmentBottomSheetState
    extends State<SelectAttachmentBottomSheet> {
  final attachments = <XFile>[];

  Future<void> _getFromGallery() async {
    final images = await ImagePicker().pickMultiImage(
      maxWidth: 1000,
      maxHeight: 1000,
    );

    if (images.isNotEmpty) {
      widget.updateAttachments(images);
      Get.back();
    }
  }

  Future<void> _getFromCamera() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1000,
      maxHeight: 1000,
    );

    if (image != null) {
      widget.updateAttachments([image]);
      Get.back();
    }
  }

  Future<void> _getFromDocument() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    if (result != null && result.files.isNotEmpty) {
      final files = result.files.map((e) => e.xFile).toList();

      widget.updateAttachments(files);
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * (0.075),
        vertical: size.height * (0.05),
      ),
      width: size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Utils.bottomSheetTopRadius),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildAttachmentItem(
                  title: documentKey,
                  width: constraints.maxWidth * (0.31),
                  onTap: _getFromDocument,
                  iconPath: Utils.getImagePath("document.svg"),
                  context: context,
                ),
                _buildAttachmentItem(
                  title: cameraKey,
                  width: constraints.maxWidth * (0.31),
                  onTap: _getFromCamera,
                  iconPath: Utils.getImagePath("camera_icon.svg"),
                  context: context,
                ),
                _buildAttachmentItem(
                  title: galleryKey,
                  width: constraints.maxWidth * (0.31),
                  onTap: _getFromGallery,
                  iconPath: Utils.getImagePath("chat_gallery.svg"),
                  context: context,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAttachmentItem({
    required double width,
    required VoidCallback onTap,
    required String iconPath,
    required BuildContext context,
    required String title,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        width: width,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: colorScheme.primary.withValues(alpha: 0.15),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              iconPath,
              colorFilter: ColorFilter.mode(
                colorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              Utils.getTranslatedLabel(title),
              style: Theme.of(context).textTheme.labelLarge,
            )
          ],
        ),
      ),
    );
  }
}
