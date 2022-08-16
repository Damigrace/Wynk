import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/features/landing_pages/home_main14.dart';
import 'package:untitled/main.dart';
class ImageLoader extends StatelessWidget {
  const ImageLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('yea');
    return Scaffold(
      body: context.read<FirstData>().providerImage==null?Center(child:
      Text('No Image Yet'),): Center(child: Image.file(context.read<FirstData>().providerImage!,fit: BoxFit.fitHeight,)));
  }
}
