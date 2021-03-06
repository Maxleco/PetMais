import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:petmais/app/shared/utils/colors.dart';
import 'package:petmais/app/shared/utils/font_style.dart';
import 'adocao_controller.dart';
import 'pages/aba_adocao/aba_adocao_page.dart';
import 'pages/aba_conversa/aba_conversa_page.dart';

class AdocaoPage extends StatefulWidget {
  @override
  _AdocaoPageState createState() => _AdocaoPageState();
}

class _AdocaoPageState extends ModularState<AdocaoPage, AdocaoController>
    with SingleTickerProviderStateMixin {
  //use 'controller' variable to access controller

  @override
  void initState() {
    super.initState();
    controller.setTaController(TabController(
      length: 2,
      vsync: this,
    ));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    controller.setContext(context);  
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      backgroundColor: DefaultColors.secondary,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.height * 0.168),
        child: Observer(
          builder: (BuildContext context) {
            return AppBar(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                    controller.animationDrawer.isShowDrawer ? 40 : 0),
              )),
              leading: controller.auth.isLogged
                  ? IconButton(
                      icon: Icon(
                        controller.animationDrawer.isShowDrawer
                            ? Icons.arrow_back
                            : Icons.menu,
                        color: Colors.black26,
                        size: 26,
                      ),
                      onPressed: () {
                        if (controller.animationDrawer.isShowDrawer) {
                          controller.animationDrawer.closeDrawer();
                        } else {
                          FocusScope.of(context).unfocus();
                          controller.animationDrawer.openDrawer();

                        }
                      })
                  : Container(),
              centerTitle: true,
              title: Container(
                width: 70,
                child: Image.asset(
                  "assets/images/logo.png",
                  fit: BoxFit.cover,
                ),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    controller.auth.isLogged
                        ? FontAwesomeIcons.signOutAlt
                        : FontAwesomeIcons.signInAlt,
                    color: Colors.black26,
                  ),
                  onPressed: () async {
                    if (controller.auth.isLogged) {
                      Modular.to.showDialog(builder: (_) {
                        return AlertDialog(
                          backgroundColor: Colors.transparent,
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          content: Center(
                            child: Container(
                              color: Colors.transparent,
                              height: 40,
                              width: 40,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(
                                    DefaultColors.primarySmooth),
                              ),
                            ),
                          ),
                        );
                      });

                      Future.delayed(Duration(milliseconds: 250))
                          .whenComplete(() {
                        Modular.to.pop();
                        controller.home.setOffline();
                        controller.removerUsuarioLocalmente();
                        Modular.to.pushNamedAndRemoveUntil("/auth", (_) => false);
                      });
                    } else {
                      Modular.to.pushNamedAndRemoveUntil("/auth", (_) => false);
                    }
                  },
                ),
              ],
              // actionsIconTheme: DefaultIconTheme.iconTheme,
              bottom: TabBar(
                controller: controller.tabController,
                indicatorColor: DefaultColors.others.withOpacity(0.5),
                indicatorWeight: 4,
                labelStyle: kLabelTabStyle,
                labelColor: DefaultColors.background,

                onTap: (index) {
                  // setState(() {
                  //   tab = index;
                  // });
                },
                tabs: [
                  Tab(text: "Adoções"),
                  Tab(text: "Conversas"),
                ],
              ),
            );
          },
        ),
      ),
      body: Observer(builder: (_) {
        return Container(
          height: size.height * 0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(
                controller.animationDrawer.isShowDrawer ? 40 : 0,
              ),
            ),
          ),
          child: TabBarView(
            controller: controller.tabController,
            children: <Widget>[
              AbaAdocaoPage(),
              AbaConversaPage(),
            ],
          ),
        );
      }),
    );
  }
}
