import 'package:demojsonplaceholder/common/sizeConfig.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'images.dart';


dynamic loader;

//create Common Function For Showing Loader
showLoader(BuildContext context) {
  loader ??= showDialog(
      useSafeArea: true,
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      barrierDismissible: false,
      builder: (_) {
        return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Material(
              color: Colors.transparent,
              child: Center(
                child: Container(
                  color: Colors.transparent,
                  height: getProportionateScreenHeight(125),
                  width: getProportionateScreenHeight(125),
                  child: Center(
                    child: Container(
                        color: Colors.transparent,
                        height: getProportionateScreenHeight(125),
                        width: getProportionateScreenWidth(125),
                        clipBehavior: Clip.none,
                        child: Image.asset(
                          Images.loader,
                        )
                    ),
                  ),
                ),
              ),
            ));
      });
}

//create Common Function For Cancel Loader
cancelLoader(BuildContext context) {
  if (loader != null) {
    Navigator.pop(context);
    loader = null;
  }
}

printText(text)
{
  if (kDebugMode) {
    print(text.toString());
  }
}
//Create Common Function For Showing toast(message)
showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    fontSize: 16.0,
  );
}
