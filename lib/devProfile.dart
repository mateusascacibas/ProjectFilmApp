import 'package:flutter/material.dart';

class devProfile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Film List"),
          bottom: TabBar(
            tabs: [
              Tab(
                text: "Ajuda",
              ),
              Tab(
                text: "Mateus",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            _body(context),
            _img()
            ,
            //_tab2(),
          ],
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              child: Icon(Icons.add),
              heroTag: "btn2",
              onPressed: () {
                
              }
            ),
          ],
        ),
      ),
    );
  }

  _body(BuildContext context) {
    return Padding(

      padding: const EdgeInsets.only(top:20.0),

      child: Container(

        child: Text(
          "Desenvolvido por: Mateus Ascacibas da Silva. \n\n"
              "Data de desenvolvimento: 01/2022. \n\n"
              "Formado em Analise e Desenvolvimento de Sistemas e cursando pós graduação em Desenvolvimento de tecnologias digitais.\n\n"
          "Entre em contato no email: mateus.asilva2001@hotmail.com \n\n"
          "Linkedin: Mateus Ascacibas da Silva \n\n"
          "GitHub: MateusAscacibas \n\n",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500
          ),

        ),

      ),

    );
  }

  _img(){
    return Container(
      decoration: BoxDecoration(
          image:DecorationImage(image: AssetImage("assets/images/mateus.jpg"),fit: BoxFit.contain)
      ),
    );
  }

}
