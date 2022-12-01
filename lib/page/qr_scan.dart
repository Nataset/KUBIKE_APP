import 'dart:developer';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kubike_app/exception/bike_api_exception.dart';
import 'package:kubike_app/provider/bike_provider.dart';
import 'package:kubike_app/service/bike_service.dart';
import 'package:kubike_app/service/location_service.dart';
import 'package:kubike_app/share/color.dart';
import 'package:kubike_app/util/show_loading.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanPage extends StatefulWidget {
  const QRScanPage({super.key});

  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  final qrKey = GlobalKey(debugLabel: 'QR');

  QRViewController? qrController;
  Barcode? _barcode;
  late bool _isBorrow;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isBorrow = context.read<BikeProvider>().isBorrow();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    qrController?.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      qrController!.pauseCamera();
    } else if (Platform.isIOS) {
      qrController!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          buildQrView(context),
          Positioned(bottom: 10, child: buildResult()),
          Positioned(top: 10, child: buildControlButtons()),
        ],
      ),
    );
  }

  Widget buildControlButtons() => Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.white24, borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () async {
                  await qrController!.toggleFlash();
                  setState(() {});
                },
                icon: FutureBuilder<bool?>(
                    future: qrController?.getFlashStatus(),
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        return Icon(
                          snapshot.data! ? Icons.flash_on : Icons.flash_off,
                          color: Colors.white,
                        );
                      } else {
                        return Container();
                      }
                    })),
            IconButton(
                onPressed: () async {
                  await qrController!.flipCamera();
                  setState(() {});
                },
                icon: Icon(
                  Icons.switch_camera,
                  color: Colors.white,
                )),
          ],
        ),
      );

  Widget buildResult() => Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.white24, borderRadius: BorderRadius.circular(8)),
        child: Text(
          _barcode != null ? 'Result: ${_barcode!.code}' : 'Scan a code!',
          maxLines: 3,
          style: TextStyle(color: Colors.white),
        ),
      );

  Widget buildQrView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
            borderColor: AppColor.red,
            borderRadius: 10,
            borderLength: 20,
            borderWidth: 10,
            cutOutSize: MediaQuery.of(context).size.width * 0.8),
      );

  void onQRViewCreated(QRViewController controller) {
    final bikeProvider = context.read<BikeProvider>();
    qrController = controller;
    controller.resumeCamera();
    controller.scannedDataStream.listen((barcode) async {
      setState(() {
        _barcode = barcode;
      });

      if (validateQrCode(barcode)) {
        Position currentPosition = await LocationService.determinePosition();

        if (_isBorrow) {
          bool _willBorrow = false;

          showDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: Text("CONFIRM"),
              content:
                  Text('คุณจะยืมจักรยานหมายเลข ${barcode.code} จริงหรือไม่'),
              actions: [
                CupertinoDialogAction(
                  child: Text(
                    'ไม่',
                  ),
                  onPressed: () {
                    _willBorrow = false;
                    Navigator.of(context).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: Text(
                    'ใช่',
                  ),
                  onPressed: () {
                    _willBorrow = true;
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          );

          if (!_willBorrow) return;

          try {
            showLoading(context: context);
            await BikeService.borrowBike(
                bikeCode: barcode.code!,
                currentPosition: currentPosition,
                bikeProvider: bikeProvider);
            unshowLoading(context: context);
            Navigator.of(context).pop();
          } on BikeApiException catch (e) {
            unshowLoading(context: context);
            showDialog(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                title: Text("ERROR"),
                content: Text('${e.message}'),
                actions: [
                  CupertinoDialogAction(
                    child: Text(
                      'OK',
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          } catch (e) {
            unshowLoading(context: context);
            showDialog(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                title: Text("ERROR"),
                content: Text('ไม่สามารถยืมจักรยานได้ กรุณาลองใหม่อีกครั้ง'),
                actions: [
                  CupertinoDialogAction(
                    child: Text(
                      'OK',
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          }
        } else {}
      } else {
        // pop loading
        // show alert

      }
    });
  }

  bool validateQrCode(Barcode barcode) {
    return barcode.code?.length == 17;
  }
}
