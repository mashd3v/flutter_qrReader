import 'package:flutter/material.dart';
import 'package:qr_reader/src/bloc/scans_bloc.dart';
import 'package:qr_reader/src/models/scan_model.dart';
import 'package:qr_reader/src/utils/utils.dart' as utils;

class MapsPage extends StatelessWidget {
  final scansBloc = new ScansBloc();

  @override
  Widget build(BuildContext context) {
    scansBloc.getScans();
    return StreamBuilder<List<ScanModel>>(
      stream: scansBloc.scansStream,
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator(),);
        }
        final scans = snapshot.data;
        if(scans.length == 0){
          return Center(
            child: Text('No Scans Yet'),
          );
        }
        return ListView.builder(
          itemCount: scans.length,
          itemBuilder: (context, i) => Dismissible(
            key: UniqueKey(),
            background: Container(           
              color: Colors.red,
              child: Icon(Icons.delete, color: Colors.white,),
            ),
            onDismissed: (direction) => scansBloc.deleteScan(scans[i].id),
            child: ListTile(
              onTap: () => utils.openScan(context, scans[i]),
              leading: Icon(Icons.map, color: Theme.of(context).primaryColor),
              title: Text(scans[i].value),
              subtitle: Text('ID: ${scans[i].id}', textAlign: TextAlign.right,),
              trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey,),
            ),
          ),
        );
      },
    );
  }
}