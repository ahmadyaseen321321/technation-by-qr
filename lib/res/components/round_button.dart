import 'package:flutter/material.dart';

import '../Colors/colors.dart';

class RoundButton extends StatelessWidget {
  const RoundButton({super.key,
    this.loading=false,
    required this.title,
    this.height=50,
    this.width= 60,
    required this.onpress,
    this.textColor= AppColor.greyColor,this.buttonColor=AppColor.surfaceDark});

  final bool loading;
  final String title;
  final double height,width;
  final VoidCallback onpress ;
  final Color textColor ,buttonColor;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onpress,
      child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(50)
            ),
            child: loading ? CircularProgressIndicator() :
        Center(
          child: Text(title,style: Theme.of(context).textTheme.titleLarge!.copyWith(color: textColor),),
        ),
      ),
    );
  }
}
