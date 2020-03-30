import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:google_maps/blocs/localizacao.bloc.dart';
import 'package:google_maps/my_flutter_app_icons.dart';
import 'package:google_maps/widgets/cadastro.mapa.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../home.screen.dart';

class CadastroProduto extends StatefulWidget {
  final DocumentSnapshot usuario;

  const CadastroProduto({Key key, this.usuario}) : super(key: key);

  @override
  _CadastroProdutoState createState() => _CadastroProdutoState();
}

class _CadastroProdutoState extends State<CadastroProduto> {
  bool produtoUsado = false;
  bool produtoNovo = false;
  Map<String, dynamic> endereco;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  LocalizacaoBloc _localizacaoBloc;
  final mascaraPreco =
      MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');

  @override
  void initState(){
    _localizacaoBloc = LocalizacaoBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              header(context),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: <Widget>[
                      botoesProduto(context),
                      formularioProdutoNovo(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
          botoesTipoProduto(context),
          SizedBox(
            height: 15.0,
          ),
          localizacao(context),
        ],
      ),
    );
  }

  Widget formularioProdutoNovo(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          decoration: InputDecoration(
            labelText: "Descrição",
          ),
          onSaved: (String valor) {},
          validator: (value) {
            if (value.length < 10) {
              return 'Por favor, descreva o produto';
            }
            return null;
          },
        ),
        SizedBox(
          height: 10.0,
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: "Marca",
          ),
          onSaved: (String valor) {},
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / 2 - 30,
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: mascaraPreco,
                decoration: InputDecoration(
                  prefix: Text("R\$ "),
                  labelText: "Preço",
                ),
                onSaved: (String valor) {},
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 2 - 30,
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: mascaraPreco,
                decoration: InputDecoration(
                  labelText: "Quantidade",
                ),
                onSaved: (String valor) {},
              ),
            ),
          ],
        ),
        SizedBox(
          height: 30.0,
        ),
        Text(
          "Categoria",
          style: TextStyle(
              color: Colors.orange,
              fontSize: 18.0,
              fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 10.0,
        ),
      ],
    );

  }

  Widget botoesProduto(BuildContext context) {
    return Container(
      height: 70.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
              onPressed: () {
                setState(() {
                  produtoUsado = false;
                  produtoNovo = true;
                });
              },
              color: produtoNovo == false ? Colors.white : Colors.orange,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  side: BorderSide(color: Colors.orange)),
              child: Text(
                "Novo",
                style: TextStyle(
                    color: produtoNovo == false ? Colors.orange : Colors.white,
                    fontSize: 16.0),
              )),
          SizedBox(
            width: 10.0,
          ),
          RaisedButton(
              onPressed: () {
                setState(() {
                  produtoNovo = false;
                  produtoUsado = true;
                });
              },
              color: produtoUsado == false ? Colors.white : Colors.orange,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  side: BorderSide(color: Colors.orange)),
              child: Text(
                "Usado",
                style: TextStyle(
                    color: produtoUsado == false ? Colors.orange : Colors.white,
                    fontSize: 16.0),
              ))
        ],
      ),
    );
  }

  Widget botoesTipoProduto(BuildContext context) {
    return Container(
      height: 60.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              height: 45.0,
              width: 170.0,
              child: RaisedButton(
                  onPressed: () {
                    setState(() {
                      produtoUsado = false;
                      produtoNovo = true;
                    });
                  },
                  color: produtoNovo == false ? Colors.white : Colors.orange,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      side: BorderSide(color: Colors.orange)),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        MyFlutterApp.cosmeticos,
                        size: 30.0,
                        color: Colors.orange,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        "Cosméticos",
                        style: TextStyle(
                            color: produtoNovo == false
                                ? Colors.orange
                                : Colors.white,
                            fontSize: 16.0),
                      ),
                    ],
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              height: 45.0,
              width: 170.0,
              child: RaisedButton(
                  onPressed: () {
                    setState(() {
                      produtoUsado = false;
                      produtoNovo = true;
                    });
                  },
                  color: produtoNovo == false ? Colors.white : Colors.orange,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      side: BorderSide(color: Colors.orange)),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        MyFlutterApp.farmacia,
                        size: 20.0,
                        color: Colors.orange,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        "Medicamentos",
                        style: TextStyle(
                            color: produtoNovo == false
                                ? Colors.orange
                                : Colors.white,
                            fontSize: 16.0),
                      ),
                    ],
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              height: 45.0,
              width: 170.0,
              child: RaisedButton(
                  onPressed: () {
                    setState(() {
                      produtoUsado = false;
                      produtoNovo = true;
                    });
                  },
                  color: produtoNovo == false ? Colors.white : Colors.orange,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      side: BorderSide(color: Colors.orange)),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        MyFlutterApp.lanchonete,
                        size: 30.0,
                        color: Colors.orange,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        "Lanches",
                        style: TextStyle(
                            color: produtoNovo == false
                                ? Colors.orange
                                : Colors.white,
                            fontSize: 16.0),
                      ),
                    ],
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              height: 45.0,
              width: 170.0,
              child: RaisedButton(
                  onPressed: () {
                    setState(() {
                      produtoUsado = false;
                      produtoNovo = true;
                    });
                  },
                  color: produtoNovo == false ? Colors.white : Colors.orange,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      side: BorderSide(color: Colors.orange)),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        MyFlutterApp.restaurante,
                        size: 22.0,
                        color: Colors.orange,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        "Refeições",
                        style: TextStyle(
                            color: produtoNovo == false
                                ? Colors.orange
                                : Colors.white,
                            fontSize: 16.0),
                      ),
                    ],
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              height: 45.0,
              width: 170.0,
              child: RaisedButton(
                  onPressed: () {
                    setState(() {
                      produtoUsado = false;
                      produtoNovo = true;
                    });
                  },
                  color: produtoNovo == false ? Colors.white : Colors.orange,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      side: BorderSide(color: Colors.orange)),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        MyFlutterApp.frutas,
                        size: 22.0,
                        color: Colors.orange,
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                      Text(
                        "Hortifruti",
                        style: TextStyle(
                            color: produtoNovo == false
                                ? Colors.orange
                                : Colors.white,
                            fontSize: 16.0),
                      ),
                    ],
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              height: 45.0,
              width: 170.0,
              child: RaisedButton(
                  onPressed: () {
                    setState(() {
                      produtoUsado = false;
                      produtoNovo = true;
                    });
                  },
                  color: produtoNovo == false ? Colors.white : Colors.orange,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      side: BorderSide(color: Colors.orange)),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        MyFlutterApp.moveis,
                        size: 22.0,
                        color: Colors.orange,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        "Móveis",
                        style: TextStyle(
                            color: produtoNovo == false
                                ? Colors.orange
                                : Colors.white,
                            fontSize: 16.0),
                      ),
                    ],
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              height: 45.0,
              width: 170.0,
              child: RaisedButton(
                  onPressed: () {
                    setState(() {
                      produtoUsado = false;
                      produtoNovo = true;
                    });
                  },
                  color: produtoNovo == false ? Colors.white : Colors.orange,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      side: BorderSide(color: Colors.orange)),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        MyFlutterApp.roupas,
                        size: 22.0,
                        color: Colors.orange,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        "Roupas",
                        style: TextStyle(
                            color: produtoNovo == false
                                ? Colors.orange
                                : Colors.white,
                            fontSize: 16.0),
                      ),
                    ],
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              height: 45.0,
              width: 170.0,
              child: RaisedButton(
                  onPressed: () {
                    setState(() {
                      produtoUsado = false;
                      produtoNovo = true;
                    });
                  },
                  color: produtoNovo == false ? Colors.white : Colors.orange,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      side: BorderSide(color: Colors.orange)),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        MyFlutterApp.servi_os,
                        size: 22.0,
                        color: Colors.orange,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        "Serviços",
                        style: TextStyle(
                            color: produtoNovo == false
                                ? Colors.orange
                                : Colors.white,
                            fontSize: 16.0),
                      ),
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget header(BuildContext context) {
    return Container(
      height: 70.0,
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Container(
              width: 40.0,
              height: 70.0,
              child: FlatButton(
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.orange,
                  size: 30.0,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width /4, top: 40.0),
            child: Text(
              "Novo Produto",
              style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget localizacao(BuildContext context){
    return Container(
      child: Column(
        children: <Widget>[
          Text("Localização", style: TextStyle(
              fontSize: 18.0,
              color: Colors.orange,
              fontWeight: FontWeight.w600
          ),),
          SizedBox(
            height: 10.0,
          ),
          Container(
            height: 60.0,
            child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          height: 50.0,
                          width: 250.0,
                          child: RaisedButton(
                            onPressed: () {},
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                side: BorderSide(color: Colors.orange)),
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  this.widget.usuario.data["Rua"] + ", " + this.widget.usuario.data["Bairro"],
                                  style: TextStyle(
                                      color: Colors.orange
                                  ),
                                ),
                                Text(
                                  this.widget.usuario.data["Cidade"] + " - " + this.widget.usuario.data["Estado"],
                                  style: TextStyle(
                                      color: Colors.orange
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          height: 50.0,
                          width: 250.0,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                side: BorderSide(color: Colors.orange)),
                            color: Colors.white,
                            onPressed: () async {
                              endereco = await _localizacaoBloc.enderecoCoordenadas(
                                  HomeScreen.localizacaoAtual.latitude,
                                  HomeScreen.localizacaoAtual.longitude);
                              setState(() {

                              });
                            },
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.location_on,
                                  size: 20.0,
                                  color: Colors.orange,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  "Buscar localização atual",
                                  style: TextStyle(color: Colors.orange, fontSize: 16.0),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          height: 50.0,
                          width: 250.0,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                side: BorderSide(color: Colors.orange)),
                            color: Colors.white,
                            onPressed: () async {
                              endereco = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CadastroMapa(),
                                ),
                              );
                              setState(() {

                              });
                            },
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.map,
                                  size: 20.0,
                                  color: Colors.orange,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  "Localização no mapa",
                                  style: TextStyle(color: Colors.orange, fontSize: 16.0),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ]
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          Container(
            height: 45.0,
            width: 300.0,
            child: RaisedButton(
              color: Colors.orange,
              shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.all(Radius.circular(10.0)),
                  side: BorderSide(color: Colors.orange)),
              onPressed: () async {

              },
              child: Text(
                "Cadastrar",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600),
              ),
            ),
          )
        ],
      ),
    );
  }
}
