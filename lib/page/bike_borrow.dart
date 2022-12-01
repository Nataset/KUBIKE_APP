import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kubike_app/page/qr_scan.dart';

import '../share/color.dart';

class BikeBorrowPage extends StatefulWidget {
  const BikeBorrowPage({super.key});

  @override
  State<BikeBorrowPage> createState() => _BikeBorrowPageState();
}

class _BikeBorrowPageState extends State<BikeBorrowPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(30),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 300,
                      child: Center(
                        child: Text(
                          'NOT FOUND',
                          style: TextStyle(
                              fontSize: 40,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Text(
                      'คุณยังไม่ได้ยืมจักรยาน',
                      style: GoogleFonts.kanit(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                            "โปรดไปที่จุดให้ยืมจักรยานในมหาลัยเกษตรบางเขตและกดปุ่ม \"สแกน QRCode เพื่อยืมจักรยาน\" ด้านล่างเพื่อทำการเริ่มยืมจักรยาน",
                            style: GoogleFonts.kanit(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500)),
                        SizedBox(
                          height: 20,
                        ),
                        Icon(
                          Icons.map_outlined,
                          size: 40,
                          color: Colors.grey[800],
                        ),
                        Text("คุณสามารถดูจุดให้ยืมจักรยานได้ในหน้าแผนที่",
                            style: GoogleFonts.kanit(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500)),
                      ],
                    )
                  ]),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 30, bottom: 30),
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
              child: Text('สแกน QRCode เพื่อยืมจักรยาน',
                  style: GoogleFonts.kanit(
                      color: Colors.white, fontWeight: FontWeight.w500))),
        ),
      ],
    ));
  }

  void QRcodeScanHandle({required BuildContext context}) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const QRScanPage()));
  }
}
