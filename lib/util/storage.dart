import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:latlong2/latlong.dart';

class Storage {
  static final _storage = FlutterSecureStorage();

  static const _keyAccessToken = 'access_token';
  static const _keyLatLocation = 'lastLatLocation';
  static const _keyLongLocation = 'lastLongLocation';
  static const _keyZoomLocation = 'lastZoomValue';

  static Future<void> setAccessToken(String accessToken) async {
    await _storage.write(key: _keyAccessToken, value: accessToken);
  }

  static Future<String?> getAccessToken() async =>
      await _storage.read(key: _keyAccessToken);

  static Future<void> deleteAccessToken() async {
    _storage.delete(key: _keyAccessToken);
  }

  static Future<void> setLastLocation(MapPosition position) async {
    _storage.write(
        key: _keyLatLocation, value: position.center!.latitude.toString());
    _storage.write(
        key: _keyLongLocation, value: position.center!.longitude.toString());
    _storage.write(key: _keyZoomLocation, value: position.zoom.toString());
  }

  static Future<MapPosition?> getLastLocation() async {
    final lat = await _storage.read(key: _keyLatLocation);
    final long = await _storage.read(key: _keyLongLocation);
    final zoom = await _storage.read(key: _keyZoomLocation);

    if (lat == null || long == null || zoom == null) {
      return null;
    }

    return MapPosition(
        center: LatLng(double.parse(lat), double.parse(long)),
        zoom: double.parse(zoom));
  }

  static Future<void> deleteLastLocation() async {
    _storage.delete(key: _keyLatLocation);
    _storage.delete(key: _keyLongLocation);
    _storage.delete(key: _keyZoomLocation);
  }
}
