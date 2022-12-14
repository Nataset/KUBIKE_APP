import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kubike_app/exception/bike_api_exception.dart';
import 'package:kubike_app/provider/bike_provider.dart';
import 'package:kubike_app/service/bike_service.dart';
import 'package:kubike_app/service/location_service.dart';
import 'package:kubike_app/service/showAppDialog.dart';
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
  bool qrBeingProcessed = false;

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
          Positioned(bottom: 50, child: buildResult()),
          Positioned(top: 50, child: buildControlButtons()),
        ],
      ),
    );
  }

  Widget buildControlButtons() => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.white24, borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () async {
                  try {
                    await qrController!.toggleFlash();
                  } catch (e) {
                    showDialog(
                      context: context,
                      builder: (context) => CupertinoAlertDialog(
                        title: const Text("ERROR"),
                        content: const Text('qrScan.dialog.flashError').tr(),
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

                  setState(() {});
                },
                icon: FutureBuilder<bool?>(
                    future: qrController?.getFlashStatus(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Icon(
                          snapshot.data! ? Icons.flash_on : Icons.flash_off,
                          color: Colors.white,
                        );
                      } else {
                        return const Icon(
                          Icons.flash_off,
                          color: Colors.white,
                        );
                      }
                    })),
            IconButton(
                onPressed: () async {
                  await qrController!.flipCamera();
                  setState(() {});
                },
                icon: const Icon(
                  Icons.switch_camera,
                  color: Colors.white,
                )),
          ],
        ),
      );

  Widget buildResult() => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.white24, borderRadius: BorderRadius.circular(8)),
        child: Text(
          _barcode != null ? 'Result: ${_barcode!.code}' : 'Scan a code!',
          maxLines: 3,
          style: const TextStyle(color: Colors.white),
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

  Future<void> borrowHandle(barcode, currentPosition, bikeProvider,
      NavigatorState navigatorState) async {
    bool willBorrow = false;
    await showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("qrScan.dialog.confirm").tr(),
        content: const Text('qrScan.dialog.confirmBorrowDescribe')
            .tr(args: ['${barcode.code}']),
        actions: [
          CupertinoDialogAction(
            child: const Text(
              'qrScan.dialog.no',
            ).tr(),
            onPressed: () {
              willBorrow = false;
              Navigator.of(context, rootNavigator: true).pop('dialog');
            },
          ),
          CupertinoDialogAction(
            child: const Text(
              'qrScan.dialog.yes',
            ).tr(),
            onPressed: () {
              willBorrow = true;
              Navigator.of(context, rootNavigator: true).pop('dialog');
            },
          )
        ],
      ),
    );

    if (willBorrow) {
      try {
        await BikeService.borrowBike(
            bikeCode: barcode.code!,
            currentPosition: currentPosition!,
            bikeProvider: bikeProvider);
        navigatorState.pop();
      } on BikeApiException catch (e) {
        await showDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text("ERROR"),
            content: Text('${e.message}'),
            actions: [
              CupertinoDialogAction(
                child: const Text(
                  'OK',
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                },
              ),
            ],
          ),
        );
      } catch (e) {
        print(e);
        await showDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text("ERROR"),
            content: const Text('qrScan.dialog.borrowError').tr(),
            actions: [
              CupertinoDialogAction(
                child: const Text(
                  'OK',
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                },
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> returnHandle(barcode, currentPosition, bikeProvider,
      NavigatorState navigatorState) async {
    bool willReturn = false;
    await showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("qrScan.dialog.confirm").tr(),
        content: const Text('qrScan.dialog.confirmReturnDescribe')
            .tr(args: ['${barcode.code}']),
        actions: [
          CupertinoDialogAction(
            child: Text(
              '?????????',
            ),
            onPressed: () {
              willReturn = false;
              Navigator.of(context, rootNavigator: true).pop('dialog');
            },
          ),
          CupertinoDialogAction(
            child: Text(
              '?????????',
            ),
            onPressed: () {
              willReturn = true;
              Navigator.of(context, rootNavigator: true).pop('dialog');
            },
          )
        ],
      ),
    );

    if (willReturn) {
      try {
        // showLoading(context: context);
        await BikeService.returnBike(
            bikeCode: barcode.code!,
            currentPosition: currentPosition!,
            bikeProvider: bikeProvider);
        // unshowLoading(context: context);
        navigatorState.pop();
      } on BikeApiException catch (e) {
        await showDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text("ERROR"),
            content: Text('${e.message}'),
            actions: [
              CupertinoDialogAction(
                child: const Text(
                  'OK',
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                },
              ),
            ],
          ),
        );
      } catch (e) {
        print(e);
        // unshowLoading(context: context);
        await showDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text("ERROR"),
            content: const Text('qrScan.dialog.borrowError'),
            actions: [
              CupertinoDialogAction(
                child: const Text(
                  'OK',
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                },
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> barcodeHandle(Barcode barcode, StreamSubscription streamSub,
      QRViewController controller, BikeProvider bikeProvider) async {
    setState(() {
      _barcode = barcode;
    });
    if (validateQrCode(barcode) && mounted) {
      final navigatorState = Navigator.of(context);
      Position? currentPosition =
          await LocationService.determinePosition(context);

      if (currentPosition == null) {
        await showAppDialog(
            context: context,
            title: 'qrScan.dialog.warning'.tr(),
            content: 'qrScan.dialog.scanError');
        return;
      }
      if (!_isBorrow) {
        await borrowHandle(
            barcode, currentPosition, bikeProvider, navigatorState);
      } else {
        await returnHandle(
            barcode, currentPosition, bikeProvider, navigatorState);
      }
    } else {
      // pop loading
      // show alert
      await showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text("ERROR"),
          content: const Text('.qrScan.dialog.qrError').tr(),
          actions: [
            CupertinoDialogAction(
              child: const Text(
                'OK',
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop('dialog');
              },
            ),
          ],
        ),
      );
    }
  }

  void onQRViewCreated(QRViewController controller) {
    final bikeProvider = context.read<BikeProvider>();
    qrController = controller;
    controller.resumeCamera();

    late StreamSubscription streamSub;
    streamSub = controller.scannedDataStream.listen((barcode) async {
      if (!qrBeingProcessed) {
        qrBeingProcessed = true;
        await barcodeHandle(barcode, streamSub, controller, bikeProvider);
        await Future.delayed(const Duration(seconds: 1));
        qrBeingProcessed = false;
      }
    });
  }

  bool validateQrCode(Barcode barcode) {
    return barcode.code?.length == 17;
  }
}
