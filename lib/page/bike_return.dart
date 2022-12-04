import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kubike_app/page/qr_scan.dart';
import 'package:kubike_app/provider/bike_provider.dart';
import 'package:kubike_app/util/formatDateTime.dart';
import 'package:provider/provider.dart';

import '../model/bike_model.dart';
import '../share/color.dart';

class BikeReturnPage extends StatefulWidget {
  const BikeReturnPage({super.key});

  @override
  State<BikeReturnPage> createState() => _BikeReturnPageState();
}

class _BikeReturnPageState extends State<BikeReturnPage> {
  @override
  Widget build(BuildContext context) {
    context.read<BikeProvider>().currentBike;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
                child: Container(
              padding: EdgeInsets.only(left: 30, right: 30, top: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Image.asset(
                      'assets/images/bicycle_demo.png',
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'รายละเอียด',
                      style: GoogleFonts.kanit(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.grey[700]),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'จักรยานพื้นฐานของมหาวิทยาลัยเกษตรศาสตร์ สามารถยืมได้แค่บุคลากรในมหาลัยเท่านั้น',
                      style: GoogleFonts.kanit(color: Colors.grey[700]),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'รหัสล็อกจักรยาน',
                    style: GoogleFonts.kanit(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800]),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    width: 250,
                    decoration: BoxDecoration(
                        color: AppColor.darkGreen,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Text(
                      '${context.read<BikeProvider>().currentBike?.lockCode ?? 'unknown'}',
                      style: GoogleFonts.kanit(
                          fontSize: 36,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'รหัสจักรยาน',
                      style: GoogleFonts.kanit(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Colors.grey[700]),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    decoration: BoxDecoration(
                        color: AppColor.green,
                        border: Border.all(color: AppColor.green),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Center(
                      child: Text(
                        '${context.read<BikeProvider>().currentBike?.bikeCode ?? 'unknown'}',
                        style: GoogleFonts.kanit(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'เวลาที่เริ่มยืม',
                      style: GoogleFonts.kanit(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700]),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColor.red),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            FormatDateTime.formatDay(context
                                .read<BikeProvider>()
                                .currentBike!
                                .borrowAt),
                            style: GoogleFonts.kanit(
                                fontWeight: FontWeight.w500, fontSize: 18),
                          ),
                          Text(
                              FormatDateTime.formatTime(context
                                  .read<BikeProvider>()
                                  .currentBike!
                                  .borrowAt),
                              style: GoogleFonts.kanit(
                                  fontWeight: FontWeight.w500, fontSize: 18))
                        ]),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'ต้องคืนก่อนเวลา',
                      style: GoogleFonts.kanit(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700]),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    decoration: BoxDecoration(
                        color: AppColor.red,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            FormatDateTime.formatDay(context
                                .read<BikeProvider>()
                                .currentBike!
                                .borrowAt
                                .add(Duration(days: 7))),
                            style: GoogleFonts.kanit(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: Colors.white),
                          ),
                          Text(
                              FormatDateTime.formatTime(context
                                  .read<BikeProvider>()
                                  .currentBike!
                                  .borrowAt
                                  .add(Duration(days: 7))),
                              style: GoogleFonts.kanit(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  color: Colors.white))
                        ]),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'วิธีการคืนจักรยาน',
                      style: GoogleFonts.kanit(fontSize: 20),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '1. นำจักรยานไปจุดจอดจักรยานที่มีที่จองเหลืออยู่',
                        ),
                        Text(
                          '2. จอดจักรยานในช่องจอดที่ว่างอยู่และล็อกจักรยานให้เรียนร้อย',
                        ),
                        Text(
                          '3. กดปุ่ม "สแกน QRCode เพื่อคืนจักรยาน" และทำการสแกน QRCode ที่ตัวจักรยาน',
                        ),
                        Text('4. กดปุ่ม "ยืนยัน"')
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 50,
                  )
                ],
              ),
            )),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.only(left: 30, right: 30),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                    backgroundColor: Colors.blue[800],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    textStyle: const TextStyle(fontSize: 18),
                    foregroundColor: AppColor.darkGreen),
                onPressed: () {
                  QRcodeScanHandle(context: context);
                },
                child: Text('สแกน QRCode เพื่อคืนจักรยาน',
                    style: GoogleFonts.kanit(
                        color: Colors.white, fontWeight: FontWeight.w500))),
          ),
        ],
      ),
    );
  }

  void QRcodeScanHandle({required BuildContext context}) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const QRScanPage()));
  }
}
