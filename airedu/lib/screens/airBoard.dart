import 'package:airedu/constants/api_endpoints.dart';
import 'package:airedu/constants/apptheme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class AirBoardPage extends StatefulWidget {
  @override
  _AirBoardPageState createState() => _AirBoardPageState();
}

class _AirBoardPageState extends State<AirBoardPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))),
        title: Text("AirBoard",style: TextStyle(fontFamily: "Signatra"),),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
      ),
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: Image.network("http://127.0.0.1:3000/video_feed"),
      )
    );
  }
}
