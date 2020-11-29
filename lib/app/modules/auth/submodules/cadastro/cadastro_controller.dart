import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:petmais/app/modules/auth/auth_controller.dart';
import 'package:petmais/app/shared/models/dados_endereco/dados_endereco_model.dart';
import 'package:petmais/app/shared/models/usuario/usuario_info_model.dart';
import 'package:petmais/app/shared/models/usuario/usuario_model.dart';
import 'package:petmais/app/shared/repository/usuario_remote/usuario_remote_repository.dart';
part 'cadastro_controller.g.dart';

class CadastroController = _CadastroControllerBase with _$CadastroController;

abstract class _CadastroControllerBase extends Disposable with Store {
  AuthController authController;
  _CadastroControllerBase(this.authController);

  UsuarioModel _usuarioModel = UsuarioModel();

  UsuarioModel get usuario => this._usuarioModel;
  dynamic get usuarioInf => this._usuarioModel.usuarioInfo;

  set setUsuarioModel(UsuarioModel value) {
    this._usuarioModel = value;
  }
  set setUsuarioInfo(dynamic value) {
    this._usuarioModel.usuarioInfo = value;
  }

  DadosEnderecoModel dadosEndereco = DadosEnderecoModel();
  void setDadosEndereco(DadosEnderecoModel dadosEnd){
    this.dadosEndereco = dadosEnd;
  }
  void disposeDadosEndereco(){
    this.dadosEndereco = DadosEnderecoModel();
  }

  //* Verificar Email
  Future<String> checkEmail(String email, {bool isLoading}) async {
    final usuarioRepository = UsuarioRemoteRepository();
    Map<String, dynamic> result;
    result = await usuarioRepository.checkEmail(email, loading: isLoading);
    return result["Result"];
  }

  //* Verificar CNPJ
  Future<String> checkCnpj(String cnpj, {bool isLoading}) async {
    final usuarioRepository = UsuarioRemoteRepository();
    Map<String, dynamic> result;
    result = await usuarioRepository.checkCNPJ(cnpj, loading: isLoading);
    return result["Result"];
  }

  //* Cadastrar
  Future<String> cadastrar(File fileImage, bool isLoading) async {
    return await this.authController.cadastrar(this.usuario, fileImage, isLoading);
  }

  //* Gerencimaento das Paginas
  PageController pageController = PageController(initialPage: 0);

  @observable
  double page = 0;

  @action
  setPage(double value) => this.page = value;

  @action
  void changePage(double value) {
    double page;
    if (value == 3) {
      page = maxExtentPages;
    } else {
      page = ((maxExtentPages / 4) * (value + 0.3));
    }
    if (value >= 2)
      pageController.jumpTo(page);
    else
      pageController.animateTo(
        page,
        duration: Duration(milliseconds: 250),
        curve: Curves.linear,
      );
    setPage(value);
  }

  double get maxExtentPages => this.pageController.position.maxScrollExtent;

  @override
  void dispose() {
    pageController.dispose();
  }
}
