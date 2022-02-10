
import 'package:filmproject/devProfile.dart';
import 'package:filmproject/foodPage.dart';
import 'package:filmproject/home_page.dart';
import 'package:filmproject/loadingSerie.dart';
import 'package:filmproject/serie_page.dart';
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
              leading: Icon(Icons.movie),
              title: Text("Filmes"),
              subtitle: Text("Mais informações..."),
              trailing: Icon(Icons.arrow_forward),
              onTap: (){

                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.emoji_food_beverage),
              title: Text("Comidas"),
              subtitle: Text("Mais informações..."),
              trailing: Icon(Icons.arrow_forward),
              onTap: (){

                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FoodPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_front),
              title: Text("Series"),
              subtitle: Text("Mais informações..."),
              trailing: Icon(Icons.arrow_forward),
              onTap: (){

                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoadingSerie()),
                );
              },
            ),

            ListTile(
              leading: Icon(Icons.help),
              title: Text("Ajuda"),
              subtitle: Text("Mais informações..."),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
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
