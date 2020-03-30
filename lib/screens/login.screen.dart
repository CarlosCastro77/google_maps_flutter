import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps/blocs/login.bloc.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  String senha;
  bool ocultaSenha = true;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String passToMd5(String password) {
    return md5.convert(utf8.encode(password)).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Stack(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "E-mail",
                    ),
                    onSaved: (String valor) {
                      email = valor;
                    },
                    validator: (value) {
                      if (!value.contains('@') & !value.contains('.')) {
                        return 'E-mail inválido';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: "Senha",
                        suffixIcon: IconButton(
                          icon: Icon(Icons.remove_red_eye,
                              color: ocultaSenha == true
                                  ? Colors.black38
                                  : Colors.black),
                          onPressed: () {
                            setState(() {
                              ocultaSenha = !ocultaSenha;
                            });
                          },
                        )),
                    obscureText: ocultaSenha,
                    onSaved: (String valor) {
                      senha = valor;
                    },
                    validator: (value) {
                      if (value.length < 4) {
                        return 'Senha incorreta';
                      }
                      return null;
                    },
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
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          side: BorderSide(color: Colors.orange)),
                      onPressed: () async {
                        if (_formKey.currentState.validate() == true) {
                          _formKey.currentState.save();
                          try {
                            AuthResult result =
                                await _auth.signInWithEmailAndPassword(
                                    email: email, password: passToMd5(senha));
                            FirebaseUser usuario = result.user;
                          } catch (e) {
                            String erro = LoginBloc.errosLogin(e.code);
                            Alert(
                              context: context,
                              title: "Não foi possível realizar o login",
                              desc: erro,
                              buttons: [
                                DialogButton(
                                  child: Text(
                                    "OK",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                  color: Colors.orange,
                                ),
                              ],
                            ).show();
                          }
                        }
                      },
                      child: Text(
                        "Entrar",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  FlatButton(
                    child: Text(
                      "Não possui uma conta? Cadastre-se",
                      style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.orange,
                          fontWeight: FontWeight.w800),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: FlatButton(
                    child: Text(
                      "Esqueci a Senha",
                      style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.orange,
                          fontWeight: FontWeight.w800),
                    ),
                    onPressed: () {},
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
