
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bandnames_app/services/socket_service.dart';


class StatusPage extends StatelessWidget {
  const StatusPage({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);


    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('ServerStatus: ${ socketService.serverStatus }')
          ],
        )
     ),
     floatingActionButton: FloatingActionButton(
      elevation: 1,
      child: const Icon(Icons.message),
      onPressed: (){
        socketService.emit('emitir-mensaje', ({
          'nombre' : 'Flutter', 
          'mensaje': 'Hola desde Flutter'})); 
     }),
   );
  }
}