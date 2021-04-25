import 'dart:ui';

import 'package:airedu/constants/api_endpoints.dart';
import 'package:airedu/constants/apptheme.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:drawing_animation/drawing_animation.dart';
//import 'package:firebase_storage_web/firebase_storage_web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:drawing_animation/src/parser.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

/// FIXME [NOTE] Web: HTML Renderer, firebaseWeb enabled [7, 31, 135, 166]
/// FIXME [NOTE] Mobile: firebaseWeb disabled

class AirScriptPage extends StatefulWidget {
  @override
  _AirScriptPageState createState() => _AirScriptPageState();
}

class _AirScriptPageState extends State<AirScriptPage> {
  bool run = true;
  double _biases = 0.75;

  bool loading = false;

//  FirebaseStorageWeb  firebaseStorageWeb = FirebaseStorageWeb(bucket: "airscript-87512.appspot.com");



  TextEditingController _handwriting = TextEditingController();
  var handWrite;
  apiCall() async {
    double _bias = _biases * 5;
    final String TO_WRITE = "/${_handwriting.text}/$_bias/$selectedStyle";
    print(TO_WRITE);
    setState(() {
      loading = true;
      run = true;
    });
    try {
      var res = await http.post(
        Uri.parse(url + TO_WRITE),

      ).then((value) {
        print(value.body);
        setState(() {
          loading =false;
        });
      });

    } on Exception catch (e) {
      print(e.toString());
    }
  }

  textField() {
    return Container(
      margin: EdgeInsets.all(15.0),
      height: 61,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35.0),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 3), blurRadius: 5, color: Colors.grey)
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
//                      inputFormatters: [
//                        new LengthLimitingTextInputFormatter(75),// for mobile
//                      ],
                      controller: _handwriting,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          hintText: "Type Something...",
                          hintStyle:
                              TextStyle(color: AppTheme.subTitleTextColor),
                          border: InputBorder.none),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 15),
          Container(
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
                color: AppTheme.primaryColor, shape: BoxShape.circle),
            child: InkWell(
              onTap: () {
                apiCall();
              },
              child: Icon(
                Icons.mode_edit,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  List<int> styles = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  int selectedStyle = 5;

  parseSvg() {
    SvgParser parser = SvgParser();
    parser.loadFromString(handWrite);
    return parser.getPaths();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          actions: [
            IconButton(icon: Icon(Icons.download_outlined,color: Colors.white,), onPressed: ()async{
              print("doing");
//              var download = await  firebaseStorageWeb.ref("images/server.png").getDownloadURL();
              var download = "";
              await UrlLauncher.launch(download);
            })
          ],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          title: Text(
            "AirScript",
            style: TextStyle(fontFamily: "Signatra"),
          ),
          centerTitle: true,
          backgroundColor: AppTheme.primaryColor,
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      //NOTE [WORKS in HTML Renderer]
                      flex: 4,
                      child: kIsWeb
                          ? loading
                              ? Center(child: FadeAnimatedTextKit(text: ["AirScript"], textStyle: TextStyle(fontSize: 100,fontFamily: "Signatra"),repeatForever: true,))
                              : StreamBuilder(
//                        stream: firebaseStorageWeb.ref("images/server.png").getDownloadURL().asStream(),
                        builder: (_, snap) {
                          if (!snap.hasData || snap.data==null) {
                            return Center(child: FadeAnimatedTextKit(text: ["AirScript"], textStyle: TextStyle(fontSize: 100,fontFamily: "Signatra"),repeatForever: true,));
                          }
                          else{
                            return Image.network(snap.data);
                          }
                        },
                      )
                          : loading
                              ? Center(child: FadeAnimatedTextKit(text: ["AirScript"], textStyle: TextStyle(fontSize: 100,fontFamily: "Signatra"),repeatForever: true,))
                              : StreamBuilder(
                                  stream: http
                                      .get(Uri.parse(url + GET_IMG))
                                      .asStream(),
                                  builder: (_, snap) {
                                    if (!snap.hasData || snap.data.body==null) {
                                      return Center(child: FadeAnimatedTextKit(text: ["AirScript"], textStyle: TextStyle(fontSize: 100,fontFamily: "Signatra"),repeatForever: true,));
                                    }
                                    else {
                                      return Center(
                                        child: Container(
                                          height: _size.height*0.5,
                                          child: InteractiveViewer(
                                            panEnabled: false,
                                            minScale: 1,
                                            maxScale: 4,
                                            boundaryMargin: EdgeInsets.all(32),
                                            child:
                                                Container(child: SvgPicture.string(snap.data.body)),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                )
                      ),
                  Expanded(
                    child: textField(),
                    flex: 2,
                  )
                ],
              ),
            ),
            Container(
              child: DraggableScrollableSheet(
                initialChildSize: 0.1,
                minChildSize: 0.1,
                maxChildSize: 0.3,
                builder: (context, controller) {
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40)),
                        color: AppTheme.primaryColor),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(8),
                      controller: controller,
                      child: Column(
                        children: [
                          Icon(Icons.arrow_upward),
                          SizedBox(height: _size.height*0.05,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Biases"),
                              Slider(
                                min: 0,
                                max: 1,
                                value: _biases,
                                activeColor: AppTheme.secondaryColor,
                                inactiveColor: AppTheme.backgroundColor,
                                onChanged: (val) {
                                  setState(() {
                                    _biases = val;
                                  });
                                },
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Style"),
                              DropdownButton(
                                value: selectedStyle,
                                onChanged: (val) => setState(() {
                                  selectedStyle = val;
                                }),
                                items: styles
                                    .map((e) => DropdownMenuItem(
                                          child: Text(
                                            e.toString(),
                                          ),
                                          value: e,
                                        ))
                                    .toList(),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
