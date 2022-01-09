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
                backgroundImage: NetworkImage("https://media-exp1.licdn.com/dms/image/C4D03AQFS42Si2ajG8w/profile-displayphoto-shrink_800_800/0/1572128799526?e=1646870400&v=beta&t=T4J5Sn0OTUHp9Y7_wjuksY-7ArVYiZwWfGq2cVGf4ZQ"),
              ),
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text("Ajuda"),
              subtitle: Text("Mais informações..."),
              trailing: Icon(Icons.arrow_forward),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              trailing: Icon(Icons.arrow_forward),
              onTap: (){
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
