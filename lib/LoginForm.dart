import 'ClassInfo.dart';
import 'MyDatabase.dart';
import 'MyWidgets.dart';
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _rememberMe = false;
  String _ac_id, _ac_name, _ac_phone, _ac_password, _ac_address;
  GlobalKey<FormState> _form = GlobalKey<FormState>();
  bool _auth = false;
  List user;
  FocusNode myFocusNode = FocusNode();

  Future checkLogin() async {
    try {
      if (!await MyWidgets().checkConnect(context)) {
        return;
      }
      setState(() {
        _auth = true;
      });
      List data = await MyWidgets()
          .getData("login.php?phone=$_ac_phone&password=$_ac_password");
      setState(() {
        user = data;
      });
      if (user[0]["ac_id"] == null) {
        MyWidgets().getAlertError(
            context, "بيانات غير صحيحة", "رقم الهاتف او كلمة المرور غير صحيح");
        return;
      } else {
        if (user[0]["ac_active"] == "0") {
          MyWidgets().getAlertError(context, "تم ايقاف هذا الحساب",
              "هذ الحساب موقف من قبل مدير النظام");
          return;
        }
        setState(() {
          _ac_id = user[0]["ac_id"];
          _ac_name = user[0]["ac_name"];
          _ac_phone = user[0]["ac_phone"];
          _ac_password = user[0]["ac_password"];
          _ac_address = user[0]["ac_address"];
        });

        String sqlDelete = "delete from mydata";
        String sqlInsesrt;
        if (_rememberMe) {
          sqlInsesrt =
              "insert into mydata(ac_id,ac_name,ac_phone,ac_password,ac_address,re) values($_ac_id,'$_ac_name','$_ac_phone','$_ac_password','$_ac_address',1)";
        } else {
          sqlInsesrt =
              "insert into mydata(ac_id,ac_name,ac_phone,ac_password,ac_address) values($_ac_id,'$_ac_name','$_ac_phone','$_ac_password','$_ac_address')";
        }
        await MyDatabase().deleteData(sqlDelete);
        await MyDatabase().insertData(sqlInsesrt);
        setState(() {
          _auth = false;
        });
        await MyWidgets().getAlertSuccess(
            context, "تسجيل الدخول بنجاح", "مرحباً بك \n" + user[0]["ac_name"]);
        await Future.delayed(Duration(milliseconds: 30));
        Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
                type: PageTransitionType.rotate,
                child: MainForm(),
                duration: Duration(seconds: 1)),
            (Route<dynamic> route) => false);
      }
    } catch (e) {
      MyWidgets()
          .getAlertError(context, "حصل خطأ", "حصل خطأ يرجىء المحاولة لاحقاً");
    } finally {
      setState(() {
        _auth = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GetSize _getSize = GetSize(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        FocusScope.of(context).unfocus();
      },
      child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: Colors.blue,
            body: Padding(
              padding: EdgeInsets.all(_getSize.paddingAll),
              child: Form(
                  key: _form,
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      SizedBox(
                        height: _getSize.paddingTop *5,
                      ),
                      Card(
                        shape: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        color: Colors.white,
                        elevation: 10,
                        child: Container(
                          padding: EdgeInsets.all(_getSize.paddingAll),
                          child: Column(
                            children: <Widget>[
                              Image.asset(
                                "assets/images/icon.png",
                                height: 200,
                                width: 200,
                              ),
                              TextFormField(
                                onFieldSubmitted: (val) {
                                  FocusScope.of(context)
                                      .requestFocus(myFocusNode);
                                },
                                keyboardType: TextInputType.phone,
                                onSaved: (val) {
                                  setState(() {
                                    _ac_phone = val;
                                  });
                                },
                                validator: (val) {
                                  if (val.isEmpty) {
                                    return "يرجىء ملىء كافة الحقول";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    labelText: "رقم الهاتف",
                                    icon: Icon(Icons.phone)),
                              ),
                              TextFormField(
                                focusNode: myFocusNode,
                                obscureText: true,
                                keyboardType: TextInputType.visiblePassword,
                                onSaved: (val) {
                                  setState(() {
                                    _ac_password = val;
                                  });
                                },
                                validator: (val) {
                                  if (val.isEmpty) {
                                    return "يرجىء ملىء كافة الحقول";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    labelText: "كلمة المرور",
                                    icon: Icon(Icons.vpn_key)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: _getSize.paddingTop * 2),
                              ),
                              Row(
                                children: <Widget>[
                                  Checkbox(
                                      value: _rememberMe,
                                      onChanged: (val) {
                                        setState(() {
                                          _rememberMe = val;
                                        });
                                      }),
                                  Text("تذكر دخولي"),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: _getSize.paddingBottom * 2,
                                    top: _getSize.paddingTop * 2),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: RaisedButton.icon(
                                      onPressed: () {
                                        if (_form.currentState.validate()) {
                                          _form.currentState.save();
                                          checkLogin();
                                        }
                                      },
                                      icon: Icon(FontAwesomeIcons.signInAlt),
                                      label: Padding(
                                          padding: EdgeInsets.all(3),
                                          child: Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Text(
                                                "تسجيل الدخول",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              ))),
                                      color: Colors.blue,
                                      textColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(_getSize.paddingBottom),
                                height: 50,
                                child: _auth
                                    ? CircularProgressIndicator()
                                    : SizedBox(),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          )),
    );
  }
}
