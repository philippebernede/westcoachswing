import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:westcoachswing/utilities/constants.dart';
import 'package:westcoachswing/utilities/singletons_data.dart';
import 'package:westcoachswing/utilities/size_config.dart';
import 'package:westcoachswing/tabView.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class Paywall extends StatefulWidget {
  final Offering? offering;

  const Paywall({Key? key, required this.offering}) : super(key: key);

  @override
  _PaywallState createState() => _PaywallState();
}

class _PaywallState extends State<Paywall> {
  @override
  Widget build(BuildContext context) {
    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return PlatformAlertDialog(
            title: const Text('Subscription problem'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text(
                      'It looks like something went wrong with your subscription process.'),
                  Text('Please try again.'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    String? errorMessage;
    return SingleChildScrollView(
      child: SafeArea(
        child: Container(
          alignment: Alignment.center,
          height: SizeConfig.blockSizeVertical! * 100,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/whiteBrick.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Wrap(
            children: <Widget>[
              Container(
                height: 70.0,
                width: double.infinity,
                decoration: const BoxDecoration(
                    // color: kColorBar,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(25.0))),
                child: const Center(
                    child: Text('✨ UNLOCK YOUR POTENTIAL',
                        style: kTitleTextStyle)),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 32, bottom: 16, left: 16.0, right: 16.0),
                child: SizedBox(
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text(
                      '7 days FREE trial',
                      style: kDescriptionTextStyle,
                    ),
                  ),
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 16, left: 16.0, right: 16.0),
                child: SizedBox(
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'and then choose your subscription',
                      style: kDescriptionTextStyle,
                    ),
                  ),
                  width: double.infinity,
                ),
              ),
              ListView.builder(
                itemCount: widget.offering!.availablePackages.length,
                itemBuilder: (BuildContext context, int index) {
                  var myProductList = widget.offering!.availablePackages;
                  return Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                    color: Colors.teal,
                    child: ListTile(
                      onTap: () async {
                        try {
                          CustomerInfo customerInfo =
                              await Purchases.purchasePackage(
                                  myProductList[index]);
                          appData.entitlementIsActive = customerInfo
                              .entitlements.all[entitlementID]!.isActive;
                        } catch (e) {
                          errorMessage = e.toString();
                        }

                        setState(() {});
                        errorMessage != null
                            ? await _showMyDialog()
                            : Navigator.pop(context);
                      },
                      title: Text(
                        myProductList[index].storeProduct.title,
                        style: kTitleTextStyle,
                      ),
                      subtitle: Text(
                        myProductList[index].storeProduct.description,
                        style: kDescriptionTextStyle.copyWith(
                            fontSize: kFontSizeSuperSmall),
                      ),
                      trailing: RichText(
                        text: TextSpan(
                          text: "27,99\$",
                          style: kBeforePriceTextStyle,
                          children: [
                            const WidgetSpan(
                              style: kTitleTextStyle,
                              child: Icon(Icons.arrow_forward, size: 22),
                            ),
                            TextSpan(
                                text: myProductList[index]
                                    .storeProduct
                                    .priceString,
                                style: kTitleTextStyle),
                            TextSpan(
                                text: '/month',
                                style: kTitleTextStyle.copyWith(fontFeatures: [
                                  const FontFeature.subscripts()
                                ])),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 32, bottom: 16, left: 16.0, right: 16.0),
                child: Container(
                  alignment: Alignment.center,
                  child: const Text(
                    footerText,
                    style: kDescriptionTextStyle,
                  ),
                  width: double.infinity,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
