import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:qr_reader/src/models/scan_model.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController map = new MapController();

  String mapType = 'streets-v11';

  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back), 
          color: Colors.blue,
          onPressed: (){Navigator.pop(context);},
        ),
        backgroundColor: Colors.transparent,
        title: Text('QR Coordinates', style: TextStyle(color: Colors.blue),),
        centerTitle: true,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location, color: Colors.blue,), 
            onPressed: (){
              map.move(scan.getLatLng(), 15);
            }
          )
        ],
      ),
      body: _createFlutterMap(scan),
      floatingActionButton: _createFloatingActionButton(context),
    );
  }

  Widget _createFlutterMap(ScanModel scan){
    return FlutterMap(
      mapController: map,
      options: MapOptions(
        center: scan.getLatLng(),
        zoom: 15
      ),
      layers: [
        _createMap(),
        _createMarkers(scan)
      ],
    );
  }

  _createMap(){
    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/styles/v1/'
      '{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
      additionalOptions: {
          'accessToken': 'pk.eyJ1IjoibWFzaGQzdiIsImEiOiJja2FyaXJubmYwMmRnMzBwYjZvczlqODByIn0.uwZS7WIJdKZeMY_FIQmLDg',
          'id': 'mapbox/$mapType',
      },
    );
  }

  _createMarkers(ScanModel scan){
    return MarkerLayerOptions(
      markers: <Marker>[
        Marker(
          width: 100.0,
          height: 100.0,
          point: scan.getLatLng(),
          builder: (context) => Container(
            child: Icon(
              Icons.location_on,
              size: 70.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
        )
      ]
    );
  }

  Widget _createFloatingActionButton(BuildContext context){
    return FloatingActionButton(
      child: Icon(Icons.loop),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed:(){
        setState(() {
          if(mapType == 'streets-v11'){
            mapType = 'dark-v10';
          } else if(mapType == 'dark-v10'){
            mapType = 'satellite-v9';
          } else if(mapType == 'satellite-v9'){
            mapType = 'satellite-streets-v11';
          } else if(mapType == 'satellite-streets-v11'){
            mapType = 'outdoors-v11';
          }   else{
            mapType = 'streets-v11';
          }
        });
      }
    );
  }
}