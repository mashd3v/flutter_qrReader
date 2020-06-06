import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:qr_reader/src/bloc/scans_bloc.dart';
import 'package:qr_reader/src/models/scan_model.dart';
import 'package:qr_reader/src/pages/directions-page.dart';
import 'package:qr_reader/src/utils/utils.dart' as utils;
import 'maps_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scansBloc = new ScansBloc();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner', style: TextStyle(color: Colors.blue),),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever, color: Colors.blue,), 
            onPressed: scansBloc.deleteAllScans
          )
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _newBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed: () => _scanQR(context),
        // backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  _scanQR(BuildContext context) async{
    // https://google.com.mx
    // geo:19.454775516315152,-99.03279676875003
    dynamic futureString;
    try{
      futureString = await BarcodeScanner.scan();
    } catch(e){
      futureString = e.toString();
    }
    
    if(futureString != null){
      final scan = ScanModel(value: futureString.rawContent);
      scansBloc.addScan(scan);

      if(Platform.isIOS){
        Future.delayed(Duration(milliseconds: 750),(){
          utils.openScan(context, scan);
        });
      } else{
        utils.openScan(context, scan);
      }
    }
  }

  Widget _newBottomNavigationBar(){
    return BottomNavigationBar(
      elevation: 0.0,
      currentIndex: currentIndex,
      onTap: (index){
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Maps')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.brightness_5),
          title: Text('Directions')
        )
      ]
    );
  }

  Widget _callPage(int currentPage){
    switch(currentPage){
      case 0: return MapsPage();
      case 1: return DirectionsPage();
      default: return MapsPage();
    }
  }
}