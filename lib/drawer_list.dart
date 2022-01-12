import 'package:filmproject/devProfile.dart';
import 'package:flutter/material.dart';

class DrawerList extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(

              accountName: Text("Mateus Ascacibas"),
              accountEmail: Text("mateus.asilva2001@hotmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("assets/images/mateus.jpg"),
              ),
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text("Ajuda"),
              subtitle: Text("Mais informações..."),
              trailing: Icon(Icons.arrow_forward),
              onTap: (){

                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => devProfile()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
