import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:kubike_app/model/hub_model.dart';
import 'package:kubike_app/service/hub_service.dart';
import 'package:kubike_app/share/color.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List<Hub> _hubs = [];
  final LatLng _mapDefaultPosition = LatLng(13.844680, 100.571384);
  final _mapController = MapController();

  @override
  void initState() {
    super.initState();

    HubService.fetchHubs().then((hubs) => setState(() {
          _hubs = hubs ?? [];
        }));
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    void showHubsDetail(Hub hub) {
      _mapController.moveAndRotate(
          LatLng(hub.lon - 0.005, hub.lat - 0.003), 16, -30);

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
                                '${hub.lon}, ${hub.lat}',
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
                                      color: Colors.grey[300],
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
                                            '20',
                                            style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.w900,
                                                color: Colors.green[500]),
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
                                      color: AppColor.lightGreen,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.pedal_bike,
                                        size: 50,
                                        color: Colors.white,
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
                                            '5',
                                            style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.w900,
                                                color: Colors.green[500]),
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

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        center: _mapDefaultPosition,
        zoom: 15,
        maxZoom: 18,
        rotation: -30,
        keepAlive: true,
        maxBounds: LatLngBounds(
          LatLng(13.9, 100.5),
          LatLng(13.8, 100.6),
        ),
      ),
      nonRotatedChildren: [
        AttributionWidget.defaultWidget(
          source: 'OpenStreetMap contributors',
          onSourceTapped: null,
        ),
      ],
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayer(
            markers: _hubs.length > 0
                ? List<Marker>.generate(
                    _hubs!.length,
                    (index) => Marker(
                          width: 50,
                          height: 50,
                          rotate: true,
                          point: LatLng(_hubs![index].lon, _hubs![index].lat),
                          builder: (context) => GestureDetector(
                              onTap: () => showHubsDetail(_hubs[index]),
                              child: const Icon(
                                Icons.location_pin,
                                size: 50,
                                color: Colors.red,
                              )),
                        ))
                : []),
        CurrentLocationLayer(
          centerOnLocationUpdate: CenterOnLocationUpdate.always,
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
        )
      ],
    );
    ;
  }
}
