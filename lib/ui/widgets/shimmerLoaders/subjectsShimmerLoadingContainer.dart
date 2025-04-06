import 'package:yocut/ui/widgets/customShimmerContainer.dart';
import 'package:yocut/ui/widgets/shimmerLoadingContainer.dart';
import 'package:flutter/material.dart';

class SubjectsShimmerLoadingContainer extends StatelessWidget {
  const SubjectsShimmerLoadingContainer({super.key});

  Widget _buildSubjectShimmerLoadingContainer({
    required BoxConstraints boxConstraints,
    required int index,
    required BuildContext context,
  }) {
    return Container(
      width: boxConstraints.maxWidth * (0.26),
      margin: const EdgeInsets.only(
        bottom: 15.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomShimmerContainer(
            borderRadius: 20,
            width: boxConstraints.maxWidth * (0.26),
            height: boxConstraints.maxWidth * (0.26),
          ),
          const SizedBox(
            height: 10,
          ),
          CustomShimmerContainer(
            borderRadius: 7.5,
            width: boxConstraints.maxWidth * (0.2),
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildsubjectsShimmerLoading(BuildContext context) {
    return ShimmerLoadingContainer(
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * (0.075),
        ),
        child: LayoutBuilder(
          builder: (context, boxConstraints) {
            return Wrap(
              spacing: boxConstraints.maxWidth * (0.1),
              children: List.generate(6, (index) => index)
                  .map(
                    (index) => _buildSubjectShimmerLoadingContainer(
                      boxConstraints: boxConstraints,
                      context: context,
                      index: index,
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildsubjectsShimmerLoading(context);
  }
}
