import 'package:easy_localization/easy_localization.dart';
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
              padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Image.asset(
                      'assets/images/bicycle_demo.png',
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'bikeReturn.detail',
                      style: GoogleFonts.kanit(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.grey[700]),
                    ).tr(),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'bikeReturn.bikeDescribe',
                      style: GoogleFonts.kanit(color: Colors.grey[700]),
                    ).tr(),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'bikeReturn.lockPin',
                    style: GoogleFonts.kanit(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800]),
                  ).tr(),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    width: 250,
                    decoration: BoxDecoration(
                        color: AppColor.darkGreen,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Text(
                      context.read<BikeProvider>().currentBike?.lockCode ??
                          'unknown',
                      style: GoogleFonts.kanit(
                          fontSize: 36,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'bikeReturn.bikeId',
                      style: GoogleFonts.kanit(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Colors.grey[700]),
                    ).tr(),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    decoration: BoxDecoration(
                        color: AppColor.green,
                        border: Border.all(color: AppColor.green),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Center(
                      child: Text(
                        context.read<BikeProvider>().currentBike?.bikeCode ??
                            'unknown',
                        style: GoogleFonts.kanit(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'bikeReturn.borrowStartTime',
                      style: GoogleFonts.kanit(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700]),
                    ).tr(),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColor.red),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
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
                      'bikeReturn.returnBeforeTime',
                      style: GoogleFonts.kanit(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700]),
                    ).tr(),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    decoration: BoxDecoration(
                        color: AppColor.red,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            FormatDateTime.formatDay(context
                                .read<BikeProvider>()
                                .currentBike!
                                .borrowAt
                                .add(const Duration(days: 7))),
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
                                  .add(const Duration(days: 7))),
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
                      'bikeReturn.howToReturn',
                      style: GoogleFonts.kanit(fontSize: 20),
                    ).tr(),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'bikeReturn.howToReturnDescribeOne',
                        ).tr(),
                        const Text(
                          'bikeReturn.howToReturnDescribeTwo',
                        ).tr(),
                        const Text(
                          'bikeReturn.howToReturnDescribeThree',
                        ).tr(),
                        const Text('bikeReturn.howToReturnDescribeFour').tr()
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const SizedBox(
                    height: 50,
                  )
                ],
              ),
            )),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: Colors.blue[800],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    textStyle: const TextStyle(fontSize: 18),
                    foregroundColor: AppColor.darkGreen),
                onPressed: () {
                  QRcodeScanHandle(context: context);
                },
                child: Text('bikeReturn.scanQRcode',
                        style: GoogleFonts.kanit(
                            color: Colors.white, fontWeight: FontWeight.w500))
                    .tr()),
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
