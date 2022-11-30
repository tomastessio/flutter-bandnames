import 'dart:io';

import 'package:bandnames_app/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [
    Band(
      id: '1', 
      name: 'Los Caligaris', 
      votes: 5),
    Band(
      id: '2', 
      name: 'Guasones', 
      votes: 4),
    Band(
      id: '3', 
      name: 'El cuarteto de Nos', 
      votes: 3),
    Band(
      id: '4', 
      name: 'LPDA', 
      votes: 2) 
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text('BandNames', style: TextStyle(color: Colors.black87),),
        backgroundColor: Colors.white,

      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, i) => _bandTile(bands[i])
        ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand),
   );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction){
        //TODO: llamar el borrado en el servidor
        print('direction: $direction');
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
              print(band.name);
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
    bands.add(Band(id: DateTime.now().toString(), name: name, votes: 0));
    setState(() {});
    }
    Navigator.pop(context);
  }

}