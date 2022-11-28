import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:westcoachswing/utilities/constants.dart';
import 'package:westcoachswing/utilities/singletons_data.dart';
import 'package:westcoachswing/utilities/size_config.dart';

class Paywall extends StatefulWidget {
  final Offering? offering;

  const Paywall({Key? key, required this.offering}) : super(key: key);

  @override
  _PaywallState createState() => _PaywallState();
}

class _PaywallState extends State<Paywall> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Container(
          alignment: Alignment.center,
          height: SizeConfig.blockSizeVertical! * 100,
          decoration: const BoxDecoration(
            color: kColorBar,
          ),
          child: Wrap(
            children: <Widget>[
              Container(
                height: 70.0,
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: kColorBar,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(25.0))),
                child: const Center(
                    child:
                        Text('✨ West Coach Swing App', style: kTitleTextStyle)),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 32, bottom: 16, left: 16.0, right: 16.0),
                child: SizedBox(
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'Choose your offer',
                      style: kDescriptionTextStyle,
                    ),
                  ),
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 32, bottom: 16, left: 16.0, right: 16.0),
                child: SizedBox(
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text(
                      '7 days FREE trial and then',
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
                            print(e);
                          }

                          setState(() {});
                          Navigator.pop(context);
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
                        trailing: Text(
                            myProductList[index].storeProduct.priceString,
                            style: kTitleTextStyle)),
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
