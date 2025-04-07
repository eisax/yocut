import 'package:flutter/material.dart';

class CustomCloseButton extends StatelessWidget {
  final Function onTapCloseButton;
  const CustomCloseButton({super.key, required this.onTapCloseButton});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(5.0),
      onTap: () {
        onTapCloseButton();
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(color: Theme.of(context).colorScheme.secondary),),
        width: 25,
        height: 25,
        child: Icon(
          Icons.close,
          size: 20,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}
