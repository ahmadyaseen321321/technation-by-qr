import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import '../Colors/colors.dart';

class InternetExceptionWidget extends StatefulWidget {
  final VoidCallback onPress;
  const InternetExceptionWidget({super.key, required this.onPress});


  @override
  State<InternetExceptionWidget> createState() =>
      _InternetExceptionWidgetState();
}

class _InternetExceptionWidgetState extends State<InternetExceptionWidget> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(height: height * .15),
          Icon(Icons.cloud_off, color: AppColor.googleRed,size: 50,),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Center(child: Text('kaisa ha'.tr)),
          ),
          SizedBox(height: height * .15),
          InkWell(
            onTap: widget.onPress,
            child: Container(
              height: 40,
              width: 150,
              decoration: BoxDecoration(
                color: AppColor.successColor,
                borderRadius: BorderRadius.circular(50)
              ),
              child:
              Center(child: Text("retry"
              ,style: Theme.of(context).textTheme.titleLarge!.copyWith(color: AppColor.whiteColor), )),
            ),
          )
        ],
      ),
    );
  }
}
