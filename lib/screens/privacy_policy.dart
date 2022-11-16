import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicy extends StatelessWidget {
  final TextStyle paragraphTextStyle =
      TextStyle(color: Colors.black, height: 1.2);
  final TextStyle titleTextStyle =
      TextStyle(color: Colors.black, height: 1.2, fontWeight: FontWeight.bold);
  final TextStyle linkTextStyle = TextStyle(
      color: Colors.blue, height: 1.2, decoration: TextDecoration.underline);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Privacy Policy',
                      style: titleTextStyle,
                    ),
                    TextSpan(
                      text:
                          '\n\nYou can find our Privacy Policies by clicking on that link : ',
                      style: paragraphTextStyle,
                    ),
                    TextSpan(
                      text: 'https://westcoachswing.com/privacy-policies',
                      style: linkTextStyle,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launch(
                              'https://westcoachswing.com/privacy-policies-app');
                        },
                    ),
//---------------------------OLD PRIVACY POLICY----------------------------
                    //   TextSpan(
                    //     text:
                    //         '\nPhilippe Berne built the West Coach Swing app as a Commercial app. This SERVICE is provided by Philippe Berne and is intended for use as is.'
                    //         'This page is used to inform visitors regarding my policies with the collection, use, and disclosure of Personal Information if anyone decided to use my Service.'
                    //         'If you choose to use my Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that I collect is used for providing and improving the Service. I will not use or share your information with anyone except as described in this Privacy Policy.'
                    //         'The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which is accessible at West Coach Swing unless otherwise defined in this Privacy Policy.',
                    //     style: paragraphTextStyle,
                    //   ),
                    //   TextSpan(
                    //     text: '\nInformation Collection and Use',
                    //     style: titleTextStyle,
                    //   ),
                    //   TextSpan(
                    //     text:
                    //         '\nFor a better experience, while using our Service, I may require you to provide us with certain personally identifiable information, including but not limited to Email, First Name. The information that I request will be retained on your device and is not collected by me in any way.'
                    //         'The app does use third party services that may collect information used to identify you.'
                    //         'Link to privacy policy of third party service providers used by the app'
                    //         '\n\t          - ',
                    //     style: paragraphTextStyle,
                    //   ),
                    //   TextSpan(
                    //     text: 'Google Play Services and Google Drive',
                    //     style: linkTextStyle,
                    //     recognizer: TapGestureRecognizer()
                    //       ..onTap = () {
                    //         launch('https://www.google.com/policies/privacy/');
                    //       },
                    //   ),
                    //   TextSpan(
                    //     text: '\n\t          - ',
                    //     style: paragraphTextStyle,
                    //   ),
                    //   TextSpan(
                    //     text: 'Google Analytics for Firebase',
                    //     style: linkTextStyle,
                    //     recognizer: TapGestureRecognizer()
                    //       ..onTap = () {
                    //         launch(
                    //             'https://firebase.google.com/policies/analytics');
                    //       },
                    //   ),
                    //   TextSpan(
                    //     text: '\n           - ',
                    //     style: paragraphTextStyle,
                    //   ),
                    //   TextSpan(
                    //     text: 'Apple Services',
                    //     style: linkTextStyle,
                    //     recognizer: TapGestureRecognizer()
                    //       ..onTap = () {
                    //         launch(
                    //             'https://www.apple.com/legal/privacy/en-ww/');
                    //       },
                    //   ),
                    //   TextSpan(
                    //     text: '\n\nLog Data',
                    //     style: titleTextStyle,
                    //   ),
                    //   TextSpan(
                    //     text:
                    //         '\nI want to inform you that whenever you use my Service, in a case of an error in the app I collect data and information (through third party products) '
                    //         'on your phone called Log Data. This Log Data may include information such as your device Internet Protocol (“IP”) address, device name, operating system version, '
                    //         'the configuration of the app when utilizing my Service, the time and date of your use of the Service, and other statistics.',
                    //     style: paragraphTextStyle,
                    //   ),
                    //   TextSpan(
                    //     text: '\nCookies',
                    //     style: titleTextStyle,
                    //   ),
                    //   TextSpan(
                    //     text:
                    //         '\nCookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites '
                    //         'that you visit and are stored on your device\'s internal memory.'
                    //         'This Service does not use these “cookies” explicitly. However, the app may use third party code and libraries that use “cookies” to collect information and'
                    //         ' improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse '
                    //         'our cookies, you may not be able to use some portions of this Service.',
                    //     style: paragraphTextStyle,
                    //   ),
                    //   TextSpan(
                    //     text: '\nService Providers',
                    //     style: titleTextStyle,
                    //   ),
                    //   TextSpan(
                    //     text:
                    //         '\nI may employ third-party companies and individuals due to the following reasons:'
                    //         '\n           - To facilitate our Service;'
                    //         '\n           - To provide the Service on our behalf;'
                    //         '\n           - To perform Service-related services; or'
                    //         '\n           - To assist us in analyzing how our Service is used.'
                    //         '\n\nI want to inform users of this Service that these third parties have access to your Personal Information. The reason is to perform the tasks assigned to '
                    //         'them on our behalf. However, they are obligated not to disclose or use the information for any other purpose.',
                    //     style: paragraphTextStyle,
                    //   ),
                    //   TextSpan(
                    //     text: '\nSecurity',
                    //     style: titleTextStyle,
                    //   ),
                    //   TextSpan(
                    //     text:
                    //         '\nI value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. '
                    //         'But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and I cannot guarantee its '
                    //         'absolute security.',
                    //     style: paragraphTextStyle,
                    //   ),
                    //   TextSpan(
                    //     text: '\nLink to other sites',
                    //     style: titleTextStyle,
                    //   ),
                    //   TextSpan(
                    //     text:
                    //         '\nThis Service may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that these external '
                    //         'sites are not operated by me. Therefore, I strongly advise you to review the Privacy Policy of these websites. I have no control over and assume no '
                    //         'responsibility for the content, privacy policies, or practices of any third-party sites or services.',
                    //     style: paragraphTextStyle,
                    //   ),
                    //   TextSpan(
                    //     text: '\nChildren\'s Privacy',
                    //     style: titleTextStyle,
                    //   ),
                    //   TextSpan(
                    //     text:
                    //         '\nThese Services do not address anyone under the age of 13. I do not knowingly collect personally identifiable information from children under 13. '
                    //         'In the case I discover that a child under 13 has provided me with personal information, I immediately delete this from our servers. If you are a parent or '
                    //         'guardian and you are aware that your child has provided us with personal information, please contact me so that I will be able to do necessary actions.',
                    //     style: paragraphTextStyle,
                    //   ),
                    //   TextSpan(
                    //     text: '\nChanges to the Privacy Policy',
                    //     style: titleTextStyle,
                    //   ),
                    //   TextSpan(
                    //     text:
                    //         '\nI may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. I will notify you of any changes by posting the new Privacy Policy on this page.'
                    //         'This policy is effective as of 2020-10-01',
                    //     style: paragraphTextStyle,
                    //   ),
                    //   TextSpan(
                    //     text: '\nContact Us',
                    //     style: titleTextStyle,
                    //   ),
                    //   TextSpan(
                    //     text:
                    //         '\nIf you have any questions or suggestions about my Privacy Policy, do not hesitate to contact me at ',
                    //     style: paragraphTextStyle,
                    //   ),
                    //   TextSpan(
                    //     text: 'westcoachswing@gmail.com.',
                    //     style: linkTextStyle,
                    //     recognizer: TapGestureRecognizer()
                    //       ..onTap = () {
                    //         launch('mailto:westcoachswing@gmail.com');
                    //       },
                    //   ),
                    //   TextSpan(
                    //     text: '\nThis privacy policy page was created at ',
                    //     style: paragraphTextStyle,
                    //   ),
                    //   TextSpan(
                    //     text: 'privacypolicytemplate.net',
                    //     style: linkTextStyle,
                    //     recognizer: TapGestureRecognizer()
                    //       ..onTap = () {
                    //         launch('https://privacypolicytemplate.net/');
                    //       },
                    //   ),
                    //   TextSpan(
                    //     text: ' and modified/generated by ',
                    //     style: paragraphTextStyle,
                    //   ),
                    //   TextSpan(
                    //     text: 'App Privacy Policy Generator',
                    //     style: linkTextStyle,
                    //     recognizer: TapGestureRecognizer()
                    //       ..onTap = () {
                    //         launch(
                    //             'https://app-privacy-policy-generator.firebaseapp.com/');
                    //       },
                    //   ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
