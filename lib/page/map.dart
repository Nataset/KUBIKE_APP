import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:kubike_app/model/hub_model.dart';
import 'package:kubike_app/service/hub_service.dart';
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
          LatLng(hub.lon - 0.004, hub.lat - 0.0025), 16, -30);

      showModalBottomSheet<dynamic>(
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          context: context,
          builder: (BuildContext bc) => Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                height: screenHeight - 160,
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(bc).size.width,
                      height: 225,
                      child: ClipRRect(
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
                          width: MediaQuery.of(bc).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(hub.name),
                              Text('${hub.lon}, ${hub.lat}'),
                              SizedBox(height: 800),
                              Text(hub.name),
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
          rotation: -30,
          keepAlive: true),
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
                              child: Icon(
                                Icons.location_pin,
                                size: 50,
                                color: Colors.red,
                              )),
                        ))
                : [])
      ],
    );
    ;
  }
}
