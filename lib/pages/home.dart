// ignore_for_file: avoid_print, unnecessary_this, sized_box_for_whitespace

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';

import 'package:bandnames_app/models/band.dart';
import 'package:bandnames_app/services/socket_service.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [];

  @override
  void initState() {

    final socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket.on('active-bands',  _handleActiveBands );
    super.initState();
  }

  _handleActiveBands( dynamic payload ) {
    
    this.bands = ( payload as List ).map((band) => Band.fromMap(band)).toList();

    setState(() {});
  }


  @override
  void dispose() {

    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);


    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text('BandNames', style: TextStyle(color: Colors.black87),),
        backgroundColor: Colors.white,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: (socketService.serverStatus == ServerStatus.Online) 
            ?
            Icon( Icons.check_circle_rounded, color: Colors.blue[300])
            : 
            const Icon( Icons.offline_bolt_rounded, color: Colors.red),
          )
        ]

      ),
      body: Column(
        children: [

          _showGraph(),

        Expanded(
          child: ListView.builder(
          itemCount: bands.length,
          itemBuilder: (context, i) => _bandTile(bands[i])
          ),
        ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand),
   );
  }

  Widget _bandTile(Band band) {

    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_){
        socketService.socket.emit('delete-band', {'id' : band.id});
      },
      background: Container(
        padding: const EdgeInsets.only(left: 8.5),
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Text('Delete band', style: TextStyle(color: Colors.white)),
        )

      ),
      child: ListTile(
            leading: CircleAvatar(
              child: Text(band.name.substring(0,1)),
              backgroundColor: Colors.blue[100],
            ),
            title: Text(band.name),
            trailing: Text('${band.votes}', style: const TextStyle(fontSize: 20),),
            onTap: () {
              socketService.socket.emit('vote-band', { 'id' : band.id });
            },
          ),
    );
  }

  addNewBand (){

    final textController = TextEditingController();

    if (Platform.isAndroid) {
      // Para plataforma Android.
      return showDialog(
      builder: (context){
        return AlertDialog(
          title: const Text('New Band Name:'),
          content: TextField(
            controller: textController,
          ),
          actions: [
            MaterialButton(
              child: const Text('Add'),
              elevation:  5,
              textColor: Colors.blue,
              onPressed: () => addBandToList(textController.text))
          ],
        );
      },
      context: context);
  }
  showCupertinoDialog(
    context: context, 
    builder: (_) {
      return CupertinoAlertDialog(
        title: const Text('New Band Name:'),
        content:  CupertinoTextField(
          controller: textController,
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Add'),
            textStyle: const TextStyle(color: Colors.blue),
            onPressed: () => addBandToList(textController.text),
            ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Cancel'),
            textStyle: const TextStyle(color: Colors.blue),
            onPressed: () => Navigator.pop(context),
            )
        ],
      );
    }  );
}



  void addBandToList (String name){


    if (name.length > 1){

      final socketService = Provider.of<SocketService>(context, listen: false);


      socketService.socket.emit('add-band', { 'name': name });
    }
    Navigator.pop(context);
  }

  //Mostrar gráfica

  Widget _showGraph() {
    Map<String, double> dataMap = new Map();
 
    bands.forEach(
      (band) {
        dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
      },
    );

  final List<Color> colorList = [
    Colors.blue[50]!,
    Colors.blue[200]!,
    Colors.pink[50]!,
    Colors.pink[200]!,
    Colors.yellow[50]!,
    Colors.yellow[200]!
  ];

  return Container(
    width: double.infinity,
    height: 300,
    child: PieChart(
      dataMap: dataMap.isEmpty ? {'No hay datos' : 0} : dataMap,
      animationDuration: const Duration(milliseconds: 800),
      chartLegendSpacing: 32,
      colorList: colorList,
      initialAngleInDegree: 0,
      ringStrokeWidth: 32,
      centerText: "BANDS",
      ));

  }

}