import 'package:flutter/material.dart';
import 'package:udhar/constants/colors.dart';
import 'package:udhar/constants/image_strings.dart';
import 'package:udhar/helper/helper.dart';
import 'package:udhar/services/splash_services.dart';

// show a welcoming screen when the app is launched.displays the app logo.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}


// An instance of SplashServices is used to encapsulate and manage tasks that need to be executed during the splash screen display. 
class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashServices = SplashServices();
  @override
  void initState() {
    super.initState();
    splashServices.splash(context);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: TColors.primary,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(child: Image(image: AssetImage(ImageStrings.logo) ,height: THelper.screenHeight()/2.3, width: THelper.screenWidth()/1.3,)),
        // const SizedBox(height:.0),
        Text("Udhar" , textAlign: TextAlign.center,style: TextStyle(fontSize: 35 , color: Colors.white , fontWeight: FontWeight.bold),)
      ]
    ));
  }
}