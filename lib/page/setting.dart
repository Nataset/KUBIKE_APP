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
  bool _languageValue = true;

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
              'Settings'.toUpperCase(),
              style: GoogleFonts.kanit(
                  color: Colors.black,
                  fontSize: 26,
                  fontWeight: FontWeight.w500),
            ),
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
                        'ภาษา',
                        style: GoogleFonts.kanit(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'เปลี่ยนภาษาเป็นภาษาอังกฤษ',
                        style: GoogleFonts.kanit(
                            fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  CupertinoSwitch(
                      value: _languageValue,
                      onChanged: (value) => setState(() {
                            _languageValue = value;
                          }))
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
