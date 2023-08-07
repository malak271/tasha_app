import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tasha_app/layout/home_layout.dart';
import 'package:tasha_app/layout/menu_layout.dart';

class MainLayout extends StatelessWidget {

  final zoomDrawerController = ZoomDrawerController();

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        backgroundColor: HexColor('6259A8'),
        body: ZoomDrawer(
            controller: zoomDrawerController,
            borderRadius: 30.0,
            showShadow: true,
            isRtl: true,
            angle: 0.0,
            drawerShadowsBackgroundColor: Colors.grey[300]!,
            slideWidth: MediaQuery.of(context).size.width * 0.65,
            menuScreen: MenuLayout(),
            mainScreen: HomeLayout()),
      );
}

