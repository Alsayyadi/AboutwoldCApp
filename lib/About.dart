import 'package:flutter/material.dart';
import 'package:about/about.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'MyWidgets.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  _launchWhatsApp() async {
    String phoneNumber = '+967775288883';
    var whatsAppUrl = "whatsapp://send?phone=$phoneNumber";
    if (await UrlLauncher.canLaunch(whatsAppUrl)) {
      await UrlLauncher.launch(whatsAppUrl);
    } else {
      throw 'Could not launch $whatsAppUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: AboutPage(
          title: Text("تواصل معنا"),
          applicationIcon: const SizedBox(
            width: 100,
            height: 100,
            child: Image(
              image: AssetImage('assets/images/icon.png'),
            ),
          ),
          applicationName: "تطبيق عماد حول العالم",
          applicationLegalese:
              'جميع الحقوق محفوظة © لدى شركة فورسوفت \n هاتف 967775288883+',
          applicationDescription: const Text(
              'للتواصل مع عماد الفهد يرجىء الضغط على \nطريقة التواصل المناسبة في الاسفل :'),
          children: <Widget>[
            ListTile(
              onTap: () async {
                try {
                  _launchWhatsApp();
                } catch (ex) {
                  MyWidgets().getAlertError(context,
                      "عذراً لايمكنكك استخدام هذه الطريقة ربما للأنك لاتملك تطبيق واتساب الرسمي");
                }
              },
              leading: Icon(
                FontAwesomeIcons.whatsapp,
                color: Colors.green[500],
              ),
              title: Text("واتساب  WhatsApp"),
              subtitle: Text("967775288883+"),
            ),
            ListTile(
              onTap: () async {
                try {
                  UrlLauncher.launch("tel:+967775288883");
                } catch (ex) {
                  MyWidgets().getAlertError(context,
                      "عذراً لايمكنكك استخدام هذه الطريقة لأحد الاسباب المتعلقة بنظام التشغيل الخاص بهاتفك");
                }
              },
              leading: Icon(
                FontAwesomeIcons.phone,
                color: Colors.blue,
              ),
              title: Text("اتصال هاتفي  Phone Call"),
              subtitle: Text("967775288883+"),
            ),
            ListTile(
              onTap: () {
                try {
                  UrlLauncher.launch("sms:+967775288883");
                } catch (ex) {
                  MyWidgets().getAlertError(context,
                      "عذراً لايمكنكك استخدام هذه الطريقة لأحد الاسباب المتعلقة بنظام التشغيل الخاص بهاتفك");
                }
              },
              leading: Icon(
                Icons.message,
                color: Colors.amber[700],
              ),
              title: Text("رسالة نصية  Send Message"),
              subtitle: Text("967775288883+"),
            ),
          ],
        ),
      ),
    );
  }
}
