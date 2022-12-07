import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late bool _languageValue = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // this will do but it bad
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        context.locale.toString() == 'en'
            ? _languageValue = true
            : _languageValue = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 75,
            ),
            Text(
              "setting.setting",
              style: GoogleFonts.kanit(
                  color: Colors.black,
                  fontSize: 26,
                  fontWeight: FontWeight.w500),
            ).tr(),
            SizedBox(
              height: 50,
            ),
            Divider(
              thickness: 1,
            ),
            Container(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'setting.language',
                        style: GoogleFonts.kanit(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ).tr(),
                      Text(
                        'setting.languageDescribe',
                        style: GoogleFonts.kanit(
                            fontSize: 14, color: Colors.grey[600]),
                      ).tr(),
                    ],
                  ),
                  CupertinoSwitch(
                      value: _languageValue,
                      onChanged: (value) {
                        value
                            ? context.setLocale(Locale('en'))
                            : context.setLocale(Locale('th'));

                        setState(() {
                          _languageValue = value;
                        });
                      })
                ],
              ),
            ),
            Divider(
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }
}
