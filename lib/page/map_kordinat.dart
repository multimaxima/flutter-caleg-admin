import 'dart:async';

import 'package:caleg_admin/service/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as lokasi;
import 'package:get/get.dart';

class MapKordinat extends StatefulWidget {
  final LatLng kordinat;

  const MapKordinat(this.kordinat, {super.key});

  @override
  State<MapKordinat> createState() => _MapKordinatState();
}

class _MapKordinatState extends State<MapKordinat> {
  late LatLng kordinat;

  GoogleMapController? _controller;
  lokasi.Location currentLocation = lokasi.Location();
  CameraPosition? cameraPosition;
  lokasi.LocationData? curLocation;
  StreamSubscription<lokasi.LocationData>? locationSubscription;
  String location = "Cari lokasi";
  String googleApikey = "AIzaSyBcUx-k4fZ2XEDQrQJRIMsHdQp1q8Zvwe4";

  bool isListen = false;

  final Set<Marker> _markers = {};
  MapType tipeMap = MapType.satellite;

  void getLocation() async {
    loadingData();
    isListen = true;

    locationSubscription =
        currentLocation.onLocationChanged.listen((curLocation) {
      _controller?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
                curLocation.latitude ?? 0.0, curLocation.longitude ?? 0.0),
            zoom: 20.0,
          ),
        ),
      );

      setState(() {
        hapusLoader();
        _markers.clear();
        _markers.add(
          Marker(
            markerId: MarkerId(curLocation.toString()),
            position: LatLng(
                curLocation.latitude ?? 0.0, curLocation.longitude ?? 0.0),
          ),
        );

        kordinat =
            LatLng(curLocation.latitude ?? 0.0, curLocation.longitude ?? 0.0);
      });
    });
  }

  void _handleTap(LatLng tappedPoint) {
    locationSubscription?.cancel();
    isListen = false;

    _controller?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(tappedPoint.latitude, tappedPoint.longitude),
          zoom: 20.0,
        ),
      ),
    );

    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId(tappedPoint.toString()),
          position: tappedPoint,
        ),
      );

      kordinat = tappedPoint;
    });
  }

  void gantiTipe() {
    if (tipeMap == MapType.normal) {
      setState(() {
        tipeMap = MapType.hybrid;
      });
    } else if (tipeMap == MapType.hybrid) {
      setState(() {
        tipeMap = MapType.satellite;
      });
    } else if (tipeMap == MapType.satellite) {
      setState(() {
        tipeMap = MapType.terrain;
      });
    } else if (tipeMap == MapType.terrain) {
      setState(() {
        tipeMap = MapType.normal;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    kordinat = widget.kordinat;

    _markers.add(
      Marker(
        markerId: MarkerId(kordinat.toString()),
        position: kordinat,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            zoomGesturesEnabled: true,
            mapType: tipeMap,
            initialCameraPosition: CameraPosition(
              target: kordinat,
              zoom: 20.0,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },
            markers: _markers,
            onTap: _handleTap,
            indoorViewEnabled: false,
          ),
          Positioned(
            top: 35,
            child: InkWell(
              onTap: () async {
                var place = await PlacesAutocomplete.show(
                  context: context,
                  apiKey: googleApikey,
                  mode: Mode.overlay,
                  types: [],
                  strictbounds: false,
                  hint: "Cari lokasi",
                  components: [Component(Component.country, 'id')],
                  onError: (err) {},
                );

                if (place != null) {
                  setState(() {
                    location = place.description.toString();
                  });

                  final plist = GoogleMapsPlaces(
                    apiKey: googleApikey,
                    apiHeaders: await const GoogleApiHeaders().getHeaders(),
                  );

                  String placeid = place.placeId ?? "0";
                  final detail = await plist.getDetailsByPlaceId(placeid);
                  final geometry = detail.result.geometry!;
                  final lat = geometry.location.lat;
                  final lang = geometry.location.lng;
                  var newlatlang = LatLng(lat, lang);

                  _controller?.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(target: newlatlang, zoom: 17),
                    ),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Card(
                  child: Container(
                    padding: const EdgeInsets.all(0),
                    width: MediaQuery.of(context).size.width - 40,
                    child: ListTile(
                      title: Text(
                        location,
                        style: const TextStyle(fontSize: 16),
                      ),
                      trailing: const Icon(Icons.search),
                      dense: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Material(
            type: MaterialType.transparency,
            child: Ink(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 3.0),
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: InkWell(
                onTap: isListen
                    ? () {
                        isListen = false;
                        locationSubscription?.cancel();
                      }
                    : () => getLocation(),
                borderRadius: BorderRadius.circular(1000.0),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.location_pin,
                    size: 30.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Material(
            type: MaterialType.transparency,
            child: Ink(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 3.0),
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: InkWell(
                onTap: () => gantiTipe(),
                borderRadius: BorderRadius.circular(1000.0),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.map,
                    size: 30.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Material(
            type: MaterialType.transparency,
            child: Ink(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 3.0),
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: InkWell(
                onTap: isListen
                    ? () {
                        isListen = false;
                        locationSubscription?.cancel();
                        Get.back(result: kordinat);
                      }
                    : () {
                        Get.back(result: kordinat);
                      },
                borderRadius: BorderRadius.circular(1000.0),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.keyboard_arrow_left,
                    size: 30.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
