import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kubike_app/exception/location_permission_exception.dart';
import 'package:kubike_app/model/hub_model.dart';
import 'package:kubike_app/provider/map_provider.dart';
import 'package:kubike_app/service/hub_service.dart';
import 'package:kubike_app/service/location_service.dart';
import 'package:kubike_app/share/color.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../exception/location_disabled_exception.dart';
import '../provider/bike_provider.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List<Hub> _hubs = [];
  late bool _isError = false;
  final LatLng _mapDefaultPosition = LatLng(13.8478, 100.5725);
  late final MapController _mapController;

  MapPosition? _lastPosition;
  // bool _isLocationStart = false;

  late CenterOnLocationUpdate _centerOnLocationUpdate;
  late StreamController<double?> _centerCurrentLocationStreamController;

  // void startCurrentLocation() {
  //   streamSubscription?.cancel();
  //   _subscriptPositionStream();
  //   setState(() {
  //     _isLocationStart = true;
  //   });
  // }

  // void stopCurrentLocation() {
  //   streamSubscription?.cancel();
  //   setState(() {
  //     _isLocationStart = false;
  //   });
  // }

  Future<bool> checkLocation() async {
    try {
      await LocationService.checkPermission();
      // } on LocationDisabledException catch (e) {
      //   await showDialog(
      //     context: context,
      //     builder: (context) => CupertinoAlertDialog(
      //       title: Text("ERROR"),
      //       content: Text(
      //           'Location Service ปิดอยู่โปรดเปิดก่อนใช้งาน "KU-BIKE", กด "ตกลง" เพื่อเข้าสู่หน้าตั้งค่า'),
      //       actions: [
      //         CupertinoDialogAction(
      //           child: Text(
      //             'ไม่ตกลง',
      //           ),
      //           onPressed: () {
      //             Navigator.of(context).pop();
      //           },
      //         ),
      //         CupertinoDialogAction(
      //           child: Text(
      //             'ตกลง',
      //           ),
      //           onPressed: () async {
      //             Navigator.of(context).pop();
      //             await Geolocator.openLocationSettings();
      //           },
      //         ),
      //       ],
      //     ),
      //   );
      //   return false;
    } on LocationPermissionException catch (e) {
      await showDialog<bool>(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text("ERROR"),
          content: Text(
              '"KU-BIKE" ไม่มี Permission ในการเข้าถึง Location Service ได้กรุณาให้ Permission กับ "KU-BIKE", กด "ตกลง" เพื่อเข้าสู่หน้าตั้งค่า'),
          actions: [
            CupertinoDialogAction(
              child: Text(
                'ไม่ตกลง',
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text(
                'ตกลง',
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await Geolocator.openAppSettings();
              },
            ),
          ],
        ),
      );
      return false;
    }

    return true;
  }

  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    checkLocation();

    _centerOnLocationUpdate = CenterOnLocationUpdate.always;
    _centerCurrentLocationStreamController = StreamController<double?>();

    _lastPosition = context.read<MapLastLocationProvider>().lastPosition;

    HubService.fetchHubs().then((hubs) {
      if (mounted) {
        if (hubs == null) {
          setState(() {
            _isError = true;
          });
        } else {
          setState(() {
            _hubs = hubs;
          });
        }
      }
    });

    // positionStream = StreamController();

    // (() async {
    //   if (await checkLocation()) {
    //     startCurrentLocation();
    //   }
    // })();

    // serviceStatusStream =
    //     Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
    //   if (status == ServiceStatus.enabled) {
    //     startCurrentLocation();
    //   } else {
    //     stopCurrentLocation();
    //   }
    // });
  }

  @override
  void dispose() {
    // TODO: implement dispose

    // streamSubscription?.cancel();
    // serviceStatusStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    var needLoadingError = true;
    void showHubsDetail(Hub hub) {
      _mapController.moveAndRotate(
          LatLng(hub.latitude - 0.005, hub.longitude - 0.003), 16, -30);

      showModalBottomSheet<dynamic>(
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          context: context,
          builder: (BuildContext bc) => Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                height: screenHeight - 160,
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(bc).size.width,
                      height: 225,
                      child: const ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)),
                        child: Image(
                          image: AssetImage('assets/images/hubs_demo.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 30, right: 30, top: 20, bottom: 20),
                          width: MediaQuery.of(bc).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                hub.name,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 32,
                                    color: AppColor.darkGreen),
                              ),
                              Text(
                                '${hub.latitude}, ${hub.longitude}',
                                style: TextStyle(
                                  color: AppColor.green,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Divider(
                                color: Colors.grey[600],
                              ),
                              const SizedBox(height: 20),
                              Container(
                                  padding: const EdgeInsets.only(
                                      left: 20, top: 10, bottom: 5),
                                  decoration: BoxDecoration(
                                      color: hub.available_parking_slot <= 0
                                          ? Colors.red[100]
                                          : Colors.grey[300],
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.local_parking_sharp,
                                          size: 50),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Available Parking Slot',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            '${hub.available_parking_slot}',
                                            style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.w900,
                                                color:
                                                    hub.available_parking_slot <=
                                                            0
                                                        ? Colors.red
                                                        : Colors.green[500]),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 15)
                                    ],
                                  )),
                              const SizedBox(
                                height: 30,
                              ),
                              Container(
                                  padding: const EdgeInsets.only(
                                      left: 20, top: 10, bottom: 5),
                                  decoration: BoxDecoration(
                                      color: hub.available_bike <= 0
                                          ? Colors.red[100]
                                          : AppColor.lightGreen,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.pedal_bike,
                                        size: 50,
                                        color: hub.available_bike <= 0
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Available Bicycle',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            '${hub.available_bike}',
                                            style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.w900,
                                                color: hub.available_bike <= 0
                                                    ? Colors.red
                                                    : Colors.green[500]),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 10)
                                    ],
                                  )),
                              SizedBox(height: 50),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      minimumSize: Size.fromHeight(50),
                                      backgroundColor: AppColor.red,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      padding: const EdgeInsets.only(
                                          top: 10, bottom: 10),
                                      textStyle: const TextStyle(fontSize: 18),
                                      foregroundColor: AppColor.darkGreen),
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Back',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold))),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ));
    }

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
              center: _lastPosition == null
                  ? _mapDefaultPosition
                  : _lastPosition!.center,
              zoom: _lastPosition?.zoom == null ? 15 : _lastPosition!.zoom!,
              maxZoom: 18,
              rotation: -30,
              keepAlive: true,
              screenSize: MediaQuery.of(context).size,
              onPositionChanged: (MapPosition position, bool hasGesture) {
                context.read<MapLastLocationProvider>().lastPosition = position;
                if (hasGesture) {
                  setState(
                    () =>
                        _centerOnLocationUpdate = CenterOnLocationUpdate.never,
                  );
                }
              }),
          nonRotatedChildren: [
            // AttributionWidget.defaultWidget(
            //   source: 'OpenStreetMap contributors',
            //   onSourceTapped: null,
            // ),
            Positioned(
                child: Container(
              child: Text('OpenStreetMap'),
            )),
            Positioned(
                right: 20,
                bottom: 40,
                child: FloatingActionButton(
                  backgroundColor: Colors.blue[700],
                  onPressed: () {
                    // Automatically center the location marker on the map when location updated until user interact with the map.
                    setState(
                      () => _centerOnLocationUpdate =
                          CenterOnLocationUpdate.always,
                    );
                    // Center the location marker on the map and zoom the map to level 18.
                    _centerCurrentLocationStreamController.add(18);
                  },
                  child: const Icon(
                    Icons.my_location,
                    color: Colors.white,
                  ),
                ))
          ],
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              // urlTemplate: 'http://10.0.2.2:8080/tile/{z}/{x}/{y}.png',
              tileProvider: NetworkTileProvider(),
              userAgentPackageName: 'com.example.kubike_app',
            ),
            // if (_isLocationStart)
            CurrentLocationLayer(
              // positionStream: positionStream.stream,
              centerOnLocationUpdate: CenterOnLocationUpdate.never,
              centerCurrentLocationStream:
                  _centerCurrentLocationStreamController.stream,
              turnOnHeadingUpdate: TurnOnHeadingUpdate.never,
              style: LocationMarkerStyle(
                marker: const DefaultLocationMarker(
                  child: Icon(
                    Icons.navigation,
                    color: Colors.white,
                  ),
                ),
                markerSize: const Size(40, 40),
                markerDirection: MarkerDirection.heading,
              ),
            ),
            MarkerLayer(
                markers: _hubs.length > 0
                    ? List<Marker>.generate(
                        _hubs!.length,
                        (index) => Marker(
                              width: 50,
                              height: 50,
                              rotate: true,
                              point: LatLng(_hubs![index].latitude,
                                  _hubs![index].longitude),
                              builder: (context) => GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: ((context) => Center(
                                              child: CircularProgressIndicator(
                                                  strokeWidth: 4),
                                            )));

                                    HubService.fetchHub(
                                            hubId: _hubs[index].id.toString())
                                        .then((hub) {
                                      Navigator.of(context).pop();
                                      if (hub != null) {
                                        _hubs[index] = hub;
                                        showHubsDetail(hub);
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (context) =>
                                                CupertinoAlertDialog(
                                                  title: Text(
                                                      'Show Hub Detail Fail'),
                                                  actions: [
                                                    CupertinoDialogAction(
                                                      isDefaultAction: true,
                                                      child: TextButton(
                                                        child: Text(
                                                          'OK',
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    )
                                                  ],
                                                ));
                                      }
                                    });
                                  },
                                  child: context.read<BikeProvider>().isBorrow()
                                      ? (_hubs[index].available_parking_slot <=
                                              0
                                          ? Icon(Icons.location_off,
                                              size: 50, color: Colors.red)
                                          : Icon(
                                              Icons.location_pin,
                                              size: 50,
                                              color: Colors.green,
                                            ))
                                      : (_hubs[index].available_bike <= 0
                                          ? Icon(Icons.location_off,
                                              size: 50, color: Colors.red)
                                          : Icon(
                                              Icons.location_pin,
                                              size: 50,
                                              color: Colors.green,
                                            ))),
                            ))
                    : []),
          ],
        ),
        if (_hubs.isEmpty && _isError == false)
          Container(
            color: Colors.black54,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 4,
              ),
            ),
          ),
        if (_isError)
          Container(
            color: Colors.black54,
            child: Center(
                child: Text(
              "Can't Connect to the server",
              style: TextStyle(color: Colors.red, fontSize: 18),
            )),
          )
      ],
    );
    ;
  }

  // void _subscriptPositionStream() {
  //   streamSubscription = const LocationMarkerDataStreamFactory()
  //       .geolocatorPositionStream(
  //     stream: Geolocator.getPositionStream(
  //       locationSettings: LocationService.getLocationSettings(),
  //     ),
  //   )
  //       .handleError((error) {
  //     print(error);
  //   }).listen(
  //     (position) {
  //       log('the location is updated');
  //       positionStream.add(position);
  //     },
  //   );
  // }
}
