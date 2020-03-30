import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpfcnpj/cpfcnpj.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps/animations/fade.animation.dart';
import 'package:google_maps/animations/positivo.animation.dart';
import 'package:google_maps/blocs/localizacao.bloc.dart';
import 'package:google_maps/home.screen.dart';
import 'package:google_maps/models/cadastro.cliente.model.dart';
import 'package:google_maps/models/cadastro.emailsenha.model.dart';
import 'package:google_maps/models/cadastro.empresa.model.dart';
import 'package:google_maps/models/endereco.model.dart';
import 'package:google_maps/widgets/cadastro.mapa.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CadastroScreen extends StatefulWidget {
  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  bool pessoaFisica = false;
  bool pessoaJuridica = false;
  bool tipoPessoaDefinida = false;
  bool formaPreenchimentoDefinida = false;
  String formaPreenchimentoEndereco = "Nenhuma";
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  LocalizacaoBloc _localizacaoBloc;
  Map<String, dynamic> endereco;
  var cpfEditingController = TextEditingController();
  var cpfmaskFormatter = new MaskTextInputFormatter(
      mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});
  var dataEditingController = TextEditingController();
  var datamaskFormatter = new MaskTextInputFormatter(
      mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});
  var cnpjEditingController = TextEditingController();
  var cnpjmaskFormatter = new MaskTextInputFormatter(
      mask: '##.###.###/####-##', filter: {"#": RegExp(r'[0-9]')});
  CadastroClienteModel cadastroClienteModel = CadastroClienteModel();
  CadastroEmpresaModel cadastroEmpresaModel = CadastroEmpresaModel();
  CadastroEmailSenhaModel cadastroEmailSenhaModel = CadastroEmailSenhaModel();
  EnderecoModel enderecoModel = EnderecoModel();
  Map<String, dynamic> formularioCompleto = Map<String, dynamic>();
  bool documentoValido = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var senha;

  @override
  void initState() {
    _localizacaoBloc = LocalizacaoBloc();
    super.initState();
  }

  Future<void> validarCnpj(String cnpj) async {
    var documento = await Firestore.instance
        .collection('usuarios')
        .where('Cnpj', isEqualTo: cnpj)
        .getDocuments();
    print(cnpj);
    if (documento.documents.length != 0) {
      Alert(
        context: context,
        title: "CNPJ já cadastrado",
        desc: "Por favor, realize o login com sua conta já cadastrada",
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            color: Colors.orange,
          ),
        ],
      ).show();
    } else {
      setState(() {
        documentoValido = true;
      });
    }
  }

  Future<void> validarCpf(String cpf) async {
    var documento = await Firestore.instance
        .collection('usuarios')
        .where('Cpf', isEqualTo: cpf)
        .getDocuments();
    print(cpf);
    if (documento.documents.length != 0) {
      Alert(
        context: context,
        title: "CPF já cadastrado",
        desc: "Por favor, realize o login com sua conta já cadastrada",
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            color: Colors.orange,
          ),
        ],
      ).show();
    } else {
      setState(() {
        documentoValido = true;
      });
    }
  }

  Widget formularioEntrega(String tipo, BuildContext context) {
    switch (tipo) {
      case "buscarLocalizacaoAtual":
        return buscarLocalizaoMapa(context);
        break;
      case "preencher":
        return preencher(context);
        break;
      case "localizacaoMapa":
        return buscarLocalizaoMapa(context);
        break;
      case "Nenhuma":
        return botoesEndereco(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    DocumentReference documentoUsuarios =
        Firestore.instance.collection('usuarios').document();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  header(context),
                  SizedBox(
                    height: 10.0,
                  ),
                  botoesPessoa(context),
                  tipoPessoaDefinida == true
                      ? emailSenha(context)
                      : Container(),
                  pessoaFisica == true
                      ? formularioPessoaFisica(context)
                      : Container(),
                  pessoaJuridica == true
                      ? formularioPessoaJuridica(context)
                      : Container(),
                  tipoPessoaDefinida == true
                      ? formularioEntrega(formaPreenchimentoEndereco, context)
                      : Container(),
                  SizedBox(
                    height: 20.0,
                  ),
                  formaPreenchimentoDefinida == true
                      ? pessoaFisica == true
                          ? Container(
                              height: 45.0,
                              width: 300.0,
                              child: RaisedButton(
                                color: Colors.orange,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    side: BorderSide(color: Colors.orange)),
                                onPressed: () async {
                                  if (_formKey.currentState.validate() ==
                                      true) {
                                    _formKey.currentState.save();
                                    await validarCpf(cadastroClienteModel.cpf);
                                    if (documentoValido == true) {
                                      _auth.createUserWithEmailAndPassword(
                                          email: cadastroEmailSenhaModel.email,
                                          password:
                                              cadastroEmailSenhaModel.senha);
                                      formularioCompleto.addAll(
                                          cadastroEmailSenhaModel.toJson());
                                      formularioCompleto.addAll(
                                          cadastroClienteModel.toJson());
                                      formularioCompleto
                                          .addAll(enderecoModel.toJson());
                                      await documentoUsuarios
                                          .setData(formularioCompleto);
                                      setState(() {
                                        documentoValido = false;
                                      });
                                      Navigator.pushReplacement(context,
                                          FadeRoute(page: PositivoAnimation()));
                                    }
                                  }
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
                          : Container()
                      : Container(),
                  formaPreenchimentoDefinida == true
                      ? pessoaJuridica == true
                          ? Container(
                              height: 45.0,
                              width: 300.0,
                              child: RaisedButton(
                                color: Colors.orange,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    side: BorderSide(color: Colors.orange)),
                                onPressed: () async {
                                  print("CNPJ");
                                  if (_formKey.currentState.validate() ==
                                      true) {
                                    print("CERTO");
                                    _formKey.currentState.save();
                                    await validarCnpj(
                                        cadastroEmpresaModel.cnpj);
                                    if (documentoValido == true) {
                                      _auth.createUserWithEmailAndPassword(
                                          email: cadastroEmailSenhaModel.email,
                                          password:
                                              cadastroEmailSenhaModel.senha);
                                      formularioCompleto.addAll(
                                          cadastroEmailSenhaModel.toJson());
                                      formularioCompleto.addAll(
                                          cadastroEmpresaModel.toJson());
                                      formularioCompleto
                                          .addAll(enderecoModel.toJson());
                                      await documentoUsuarios
                                          .setData(formularioCompleto);
                                      setState(() {
                                        documentoValido = false;
                                      });
                                    }
                                  } else {
                                    print("Erro");
                                  }
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
                          : Container()
                      : Container(),
                  SizedBox(
                    height: 20.0,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String passToMd5(String password) {
    return md5.convert(utf8.encode(password)).toString();
  }

  Widget emailSenha(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              labelText: "E-mail",
            ),
            onSaved: (String valor) {
              cadastroEmailSenhaModel.email = valor;
            },
            validator: (value) {
              if (!value.contains('@') & !value.contains('.')) {
                return 'Por favor, digite um email válido';
              }
              return null;
            },
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: <Widget>[
              Container(
                width: (MediaQuery.of(context).size.width / 2) - 30,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Senha",
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value.length < 4) {
                      return 'Senhas devem ter 4 ou mais dígitos';
                    }
                    setState(() {
                      senha = value;
                    });
                    return null;
                  },
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              Container(
                width: (MediaQuery.of(context).size.width / 2) - 30,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Repita a sua Senha",
                  ),
                  onSaved: (String valor) {
                    cadastroEmailSenhaModel.senha = passToMd5(valor);
                  },
                  obscureText: true,
                  validator: (value) {
                    if (value != senha) {
                      return 'Senhas não correspondentes';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          )
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
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width / 3, top: 40.0),
            child: Container(
              child: Text(
                "Novo Usuário",
                style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget botoesPessoa(BuildContext context) {
    return Container(
      height: 70.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
              onPressed: () {
                setState(() {
                  formaPreenchimentoEndereco = "Nenhuma";
                  formaPreenchimentoDefinida = false;
                  tipoPessoaDefinida = true;
                  pessoaJuridica = false;
                  pessoaFisica = true;
                });
              },
              color: pessoaFisica == false ? Colors.white : Colors.orange,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  side: BorderSide(color: Colors.orange)),
              child: Text(
                "Pessoa Física",
                style: TextStyle(
                    color: pessoaFisica == false ? Colors.orange : Colors.white,
                    fontSize: 16.0),
              )),
          SizedBox(
            width: 10.0,
          ),
          RaisedButton(
              onPressed: () {
                setState(() {
                  formaPreenchimentoEndereco = "Nenhuma";
                  formaPreenchimentoDefinida = false;
                  tipoPessoaDefinida = true;
                  pessoaFisica = false;
                  pessoaJuridica = true;
                });
              },
              color: pessoaJuridica == false ? Colors.white : Colors.orange,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  side: BorderSide(color: Colors.orange)),
              child: Text(
                "Pessoa Jurídica",
                style: TextStyle(
                    color:
                        pessoaJuridica == false ? Colors.orange : Colors.white,
                    fontSize: 16.0),
              ))
        ],
      ),
    );
  }

  Widget formularioPessoaFisica(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              labelText: "Nome",
            ),
            onSaved: (String valor) {
              cadastroClienteModel.nome = valor;
            },
            validator: (value) {
              if (value.length < 10) {
                return 'Por favor, digite seu nome completo';
              }
              return null;
            },
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: <Widget>[
              Container(
                width: (MediaQuery.of(context).size.width / 2) - 30,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: cpfEditingController,
                  inputFormatters: [cpfmaskFormatter],
                  onSaved: (String valor) {
                    cadastroClienteModel.cpf = valor;
                  },
                  decoration: InputDecoration(
                    labelText: "CPF",
                  ),
                  validator: (value) {
                    if (CPF.isValid(
                        value.replaceAll('.', '').replaceAll('-', ''))) {
                      return null;
                    } else {
                      return "Digite um CPF válido";
                    }
                  },
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              Container(
                width: (MediaQuery.of(context).size.width / 2) - 30,
                child: TextFormField(
                  keyboardType: TextInputType.datetime,
                  controller: dataEditingController,
                  inputFormatters: [datamaskFormatter],
                  onSaved: (String valor) {
                    cadastroClienteModel.dataNascimento = valor;
                  },
                  decoration: InputDecoration(
                    labelText: "Data de Nascimento",
                  ),
                  validator: (value) {
                    if (value.length != 10) {
                      return 'Digite sua data de nascimento';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }

  Widget formularioPessoaJuridica(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              labelText: "Razão Social",
            ),
            onSaved: (String valor) {
              cadastroEmpresaModel.razaoSocial = valor;
            },
            validator: (value) {
              if (value.length < 10) {
                return 'Preencha a razão social';
              }
              return null;
            },
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: cnpjEditingController,
              inputFormatters: [cnpjmaskFormatter],
              onSaved: (String valor) {
                cadastroEmpresaModel.cnpj = valor;
              },
              decoration: InputDecoration(
                labelText: "CNPJ",
              ),
              validator: (value) {
                if (!CNPJ.isValid(value)) {
                  return 'CNPJ inválido';
                }
                return null;
              },
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            child: TextFormField(
              onSaved: (String valor) {
                cadastroEmpresaModel.nomeFantasia = valor;
              },
              decoration: InputDecoration(
                labelText: "Nome Fantasia",
              ),
              validator: (value) {
                if (value.length < 6) {
                  return 'Preencha o nome fantasia';
                }
                return null;
              },
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }

  Widget botoesEndereco(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 50.0,
        ),
        Text(
          "Como deseja informar seu endereço?",
          style: TextStyle(
              color: Colors.orange,
              fontSize: 16.0,
              fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          height: 45.0,
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
                formaPreenchimentoDefinida = true;
                formaPreenchimentoEndereco = "buscarLocalizacaoAtual";
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
        SizedBox(
          height: 10.0,
        ),
        Container(
          height: 45.0,
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
                formaPreenchimentoDefinida = true;
                if(endereco.isNotEmpty){
                  formaPreenchimentoEndereco = "localizacaoMapa";
                }
                else{
                  formaPreenchimentoEndereco = "preencher";
                }
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
        SizedBox(
          height: 10.0,
        ),
        Container(
          height: 45.0,
          width: 250.0,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                side: BorderSide(color: Colors.orange)),
            color: Colors.white,
            onPressed: () {
              setState(() {
                formaPreenchimentoDefinida = true;
                formaPreenchimentoEndereco = "preencher";
              });
            },
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.keyboard,
                  size: 20.0,
                  color: Colors.orange,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  "Preencher",
                  style: TextStyle(color: Colors.orange, fontSize: 16.0),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget buscarLocalizaoMapa(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            initialValue: endereco.isNotEmpty ? endereco["Rua"] : "",
            decoration: InputDecoration(
              labelText: "Rua",
            ),
            onSaved: (String valor) {
              enderecoModel.rua = valor;
            },
            validator: (value) {
              if (value.length < 10) {
                return 'Preencha a rua';
              }
              return null;
            },
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            children: <Widget>[
              Container(
                  width: MediaQuery.of(context).size.width - 150,
                  child: TextFormField(
                    initialValue: endereco.isNotEmpty ? endereco["Bairro"] : "",
                    decoration: InputDecoration(
                      labelText: "Bairro",
                    ),
                    onSaved: (String valor) {
                      enderecoModel.bairro = valor;
                    },
                    validator: (value) {
                      if (value.length < 3) {
                        return 'Preencha o bairro';
                      }
                      return null;
                    },
                  )),
              SizedBox(
                width: 20.0,
              ),
              Container(
                width: 90.0,
                child: TextFormField(
                  initialValue: endereco.isNotEmpty ? endereco["Numero"] : "",
                  decoration: InputDecoration(
                    labelText: "Número",
                  ),
                  onSaved: (String valor) {
                    enderecoModel.numero = valor;
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width - 150,
                child: TextFormField(
                  initialValue: endereco.isNotEmpty ? endereco["Cidade"] : "",
                  decoration: InputDecoration(
                    labelText: "Cidade",
                  ),
                  onSaved: (String valor) {
                    enderecoModel.cidade = valor;
                  },
                  validator: (value) {
                    if (value.length < 2) {
                      return 'Preencha a cidade';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              Container(
                width: 90.0,
                child: TextFormField(
                  initialValue: endereco.isNotEmpty ? endereco["Estado"] : "",
                  decoration: InputDecoration(
                    labelText: "UF",
                  ),
                  onSaved: (String valor) {
                    enderecoModel.estado = valor;
                  },
                  validator: (value) {
                    if (value.length < 2) {
                      return 'Preencha o estado';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }

  Widget preencher(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              labelText: "Rua",
            ),
            onSaved: (String valor) {
              enderecoModel.rua = valor;
            },
            validator: (value) {
              if (value.length < 10) {
                return 'Preencha a rua';
              }
              return null;
            },
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            children: <Widget>[
              Container(
                  width: MediaQuery.of(context).size.width - 150,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Bairro",
                    ),
                    onSaved: (String valor) {
                      enderecoModel.bairro = valor;
                    },
                    validator: (value) {
                      if (value.length < 3) {
                        return 'Preencha o bairro';
                      }
                      return null;
                    },
                  )),
              SizedBox(
                width: 20.0,
              ),
              Container(
                width: 90.0,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Número",
                  ),
                  onSaved: (String valor) {
                    enderecoModel.numero = valor;
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width - 150,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Cidade",
                  ),
                  onSaved: (String valor) {
                    enderecoModel.cidade = valor;
                  },
                  validator: (value) {
                    if (value.length < 2) {
                      return 'Preencha a cidade';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              Container(
                width: 90.0,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "UF",
                  ),
                  onSaved: (String valor) {
                    enderecoModel.estado = valor;
                  },
                  validator: (value) {
                    if (value.length < 2) {
                      return 'Preencha o estado';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }
}
