import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rflutter_alert/rflutter_alert.dart';

class MyWidgets {
 // String domain="https://hishamforex.000webhostapp.com/aboutworld/";
  String domain = "http://192.168.1.106/aboutworld/";
  String dateToday = DateTime.now().toLocal().toString().split(' ')[0];
  DateTime selectedDate = DateTime.now();
  DateTime monthdDate = DateTime.now();
  String _dateValue = DateTime.now().toLocal().toString().split(' ')[0];
  int month;
  String s="";
  void getPdf() {}

  // ignore: avoid_init_to_null
  Future<bool> checkConnect([context=null]) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      if(context==null){
        return false;
      }
      MyWidgets().getAlertError(
          context, "حصل خط اثناء الاتصال", "يرجئ التأكد من اتصالك بالانترنت");
      return false;
    } else {
      return true;
    }
  }
  String pw="";
  Future<List> getData(String u) async {
    try {
      if(u.contains("?")){
       pw="&pwd=$s";
      }else{
        pw="?pwd=$s";
      }
      var result = await http.get(domain + u+pw);
      if (result.statusCode == 200) {
        var jsonResponse = json.decode(result.body);
        if (jsonResponse.length > 0) {
          return jsonResponse;
        } else {
          return null;
        }
      } else {
        throw new Exception(result.statusCode);
      }
    } catch (e) {
      throw new Exception(e.toString());
    }
  }

  Future setData(String u, [var data]) async {
    try {
      if(u.contains("?")){
        pw="&pwd=$s";
      }else{
        pw="?pwd=$s";
      }
      var result = await http.post(domain + u+pw, body: json.encode(data));
      var jsonResponse = json.decode(result.body);
      if (jsonResponse[0]["result"] == "yes") {
        return true;
      } else if (jsonResponse[0]["result"] == "no") {
        return false;
      }

    } catch (e) {
      throw new Exception(e.toString());
    }
  }

  Future<String> selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2019, 1),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
    }
    _dateValue = "${selectedDate.toLocal()}".split(' ')[0];
    return _dateValue;
  }

  Future<int> selectDateMonth(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: monthdDate,
        firstDate: DateTime(2019, 1),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      month = picked.month;
    }
    return month;
  }

  Future<bool> getAlertQuestion (
    context, [
    String title = "تأكيد العملية",
    String message = "هل تريد تأكيد العملية",
  ]) async{
    return Alert(
      buttons: [
        DialogButton(
          color: Colors.grey,
          height: 45,
          child: Text("الـغـاء",style: TextStyle(color: Colors.white)),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        DialogButton(
          color: Colors.cyan[500],
          height: 45,
          child: Text("موافق",style: TextStyle(color: Colors.white)),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ],
      style: AlertStyle(
        isCloseButton: false,
        isOverlayTapDismiss: false,
        animationType: AnimationType.fromRight,
        descStyle: TextStyle(fontWeight: FontWeight.bold),
        animationDuration: Duration(milliseconds: 200),
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      type: AlertType.info,
      context: context,
      title: title,
      content: Container(
          padding: EdgeInsets.only(top: 20, bottom: 15, left: 5, right: 5),
          child: Text(message,
              style: TextStyle(color: Colors.grey),
              textDirection: TextDirection.rtl)),
    ).show();
  }

  Future<bool> getAlertSuccess(
    context, [
    String title = "تمت العملية بنجاح",
    String message = "تمت العملية بنجاح",
  ])  async{
    return Alert(
      closeFunction: (){
      },
      buttons: [
        DialogButton(
            color: Colors.green[400],
            height: 45,
            child: Text(
              "اغلاق",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.pop(context);
            })
      ],
      style: AlertStyle(
        animationType: AnimationType.fromTop,
        descStyle: TextStyle(fontWeight: FontWeight.bold),
        animationDuration: Duration(milliseconds: 200),
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      type: AlertType.success,
      context: context,
      title: title,
      content: Container(
          padding: EdgeInsets.only(top: 20, bottom: 15, left: 5, right: 5),
          child: Text(message,
              style: TextStyle(color: Colors.grey),
              textDirection: TextDirection.rtl)),
    ).show();
  }

  void getAlertError(
    context, [
    String title = "حصل خطأ",
    String message = "حصل خطأ",
  ]) {
    Alert(
      closeFunction: (){
      },
      buttons: [
        DialogButton(
            color: Colors.red,
            height: 45,
            child: Text(
              "اغلاق",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.pop(context);
            })
      ],
      style: AlertStyle(
        animationType: AnimationType.fromBottom,
        descStyle: TextStyle(fontWeight: FontWeight.bold),
        animationDuration: Duration(milliseconds: 200),
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      type: AlertType.error,
      context: context,
      title: title,
      content: Container(
          padding: EdgeInsets.only(top: 20, bottom: 15, left: 5, right: 5),
          child: Text(message,
              style: TextStyle(color: Colors.grey),
              textDirection: TextDirection.rtl)),
    ).show();
  }

  void getAlertWarning(
    context, [
    String title = "تنبيه",
    String message = "تنبيه",
  ]) {
    Alert(
      closeFunction: (){
      },
      buttons: [
        DialogButton(
            color: Colors.orange,
            height: 45,
            child: Text(
              "اغلاق",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.pop(context);
            })
      ],
      style: AlertStyle(
        animationType: AnimationType.fromLeft,
        descStyle: TextStyle(fontWeight: FontWeight.bold),
        animationDuration: Duration(milliseconds: 200),
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      type: AlertType.warning,
      context: context,
      title: title,
      content: Container(
          padding: EdgeInsets.only(top: 20, bottom: 15, left: 5, right: 5),
          child: Text(
            message,
            style: TextStyle(color: Colors.grey),
            textDirection: TextDirection.rtl,
          )),
    ).show();
  }
  void getAlertInfo(
      context, [
        String title = "تنبيه",
        String message ="تنبيه",
      ]) {
    Alert(
      closeFunction: (){
      },
      buttons: [
        DialogButton(
            color: Colors.cyan[500],
            height: 45,
            child: Text(
              "اغلاق",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.pop(context);
            })
      ],
      style: AlertStyle(
        animationType: AnimationType.shrink,
        descStyle: TextStyle(fontWeight: FontWeight.bold),
        animationDuration: Duration(milliseconds: 200),
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      type: AlertType.info,
      context: context,
      title: title,
      content: Container(
          padding: EdgeInsets.only(top: 20, bottom: 15, left: 5, right: 5),
          child: Text(message,
              style: TextStyle(color: Colors.grey),
              textDirection: TextDirection.rtl)),
    ).show();
  }
}
