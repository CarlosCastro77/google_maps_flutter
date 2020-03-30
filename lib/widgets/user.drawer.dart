import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps/animations/fade.animation.dart';
import 'package:google_maps/animations/slide.left.animation.dart';
import 'package:google_maps/animations/slide.right.animation.dart';
import 'package:google_maps/screens/cadastro.produto.screen.dart';
import 'package:google_maps/screens/cadastro.user.screen.dart';
import 'package:google_maps/screens/login.screen.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

class UserDrawer extends StatefulWidget {
  @override
  _UserDrawerState createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer>
    with SingleTickerProviderStateMixin {
  List<Tab> tabs = <Tab>[
    new Tab(text: 'Produtos'),
    new Tab(text: 'Notificações'),
  ];
  TabController tabController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DocumentSnapshot usuario;
  String email;

  Future<String> carregaDados() async{
  await _auth.currentUser().then((value) => email = value.email);
  await Firestore.instance
      .collection('usuarios')
      .where('Email', isEqualTo: email)
      .getDocuments()
      .then((value) => usuario = value.documents[0]);
  return "Carregado";
  }

  @override
  void initState() {
    tabController =
    new TabController(vsync: this, length: tabs.length, initialIndex: 0);
    print(email);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<String>(
        future: carregaDados(),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(
              ),
            );
          }
          return Column(
            children: <Widget>[
              Container(
                height: 202.0,
                child: GradientCard(
                  gradient: Gradients.backToFuture,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: Container(
                              height: 30.0,
                              child: FloatingActionButton(
                                heroTag: 'BotaoSettings',
                                elevation: 3.0,
                                backgroundColor: Gradients.backToFuture.colors.last
                                    .withOpacity(0.7),
                                child: Icon(
                                  Icons.settings,
                                  size: 20.0,
                                ),
                                onPressed: () {
                                  exit(0);
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: Container(
                              height: 30.0,
                              child: FloatingActionButton(
                                heroTag: 'BotaoDesligar',
                                elevation: 3.0,
                                backgroundColor: Gradients.backToFuture.colors.last
                                    .withOpacity(0.7),
                                child: Icon(
                                  Icons.power_settings_new,
                                  size: 20.0,
                                ),
                                onPressed: () {
                                  exit(0);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      usuarioLogado(context),
                      TabBar(
                          controller: tabController,
                          indicatorWeight: 2.0,
                          indicatorColor: Colors.white,
                          labelPadding: EdgeInsets.all(0.0),
                          labelStyle: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.bold),
                          tabs: tabs),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Container(
                width: 250.0,
                height: 45.0,
                child: RaisedButton(
                  child: Text(
                    "Cadastrar Produto", style: TextStyle(
                    color: Colors.orange,
                    fontSize: 16.0,
                  ),),
                  onPressed: () {
                    Navigator.push(context, SlideLeftRoute(page: CadastroProduto(usuario: this.usuario,)));
                  },
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      side: BorderSide(color: Colors.orange)),
                ),
              )
            ],
          );
        }
      ),
    );
  }

  Widget botoesLogin(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.push(context, SlideLeftRoute(page: LoginScreen()));
          },
          child: Text(
            "Fazer Login",
            style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          "|",
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        FlatButton(
          onPressed: () {
            Navigator.push(context, SlideLeftRoute(page: CadastroScreen()));
          },
          child: Text(
            "Cadastre-se",
            style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.w600),
          ),
        )
      ],
    );
  }

  Widget usuarioLogado(BuildContext context) {
    return Container(
      height: 85.0,
      child: Column(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.orange,
            child: Icon(Icons.person, color: Colors.white),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(usuario['Nome'],
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600
          ),),
          Text(usuario["Email"], style: TextStyle(
            color: Colors.white
          ),),
        ],
      ),
    );
  }
}
