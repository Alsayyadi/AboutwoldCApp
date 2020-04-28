import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'MyDatabase.dart';
import 'MyWidgets.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  GlobalKey<FormState> _form = GlobalKey<FormState>();
  List data;
  String oldPassword, newPassword, confirmPassword;
  bool check = false;
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2= FocusNode();

  Future _getMyData() async {
    try {
      List selectData;
      String sql = "select * from mydata";
      selectData = await MyDatabase().selectData(sql);
      setState(() {
        data = selectData;
      });
    } catch (ex) {
    }
  }

  Future _changeMyData() async {
    try {
      var info = {};
     if(await MyWidgets().setData("change_password.php?new_password=$newPassword&ac_id=${data[0]["ac_id"]}",info)){
       String sql = "delete from mydata";
       await MyDatabase().deleteData(sql);
        await MyWidgets().getAlertSuccess(
           context, "تغيير كلمة المرور", "تمت العملية بنجاح");
           SystemChannels.platform.invokeMethod('SystemNavigator.pop');
     }else{
       MyWidgets().getAlertError(
           context, "حصل خطأ", "لا يمكن تنفيذ هذه العملية");
     }

    } catch (ex) {
      MyWidgets().getAlertError(
          context, "حصل خطأ اثناء الاتصال", "يرجئ اعادة المحاولة لاحقاً");
    }finally{
      setState(() {
        check = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getMyData();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        FocusScope.of(context).unfocus();
      },
      child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              title: Text("تغيير كلمة المرور"),
            ),
            body: Padding(
              padding: EdgeInsets.all(10),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      onFieldSubmitted: (val) {
                        FocusScope.of(context)
                            .requestFocus(focusNode1);
                      },
                      obscureText: true,
                      onChanged: (v) {},
                      keyboardType: TextInputType.text,
                      onSaved: (val) {
                        setState(() {
                          oldPassword = val;
                        });
                      },
                      validator: (val) {
                        if (val.isEmpty) {
                          return "يرجىء ملىء كافة الحقول";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: "كلمة المرور الحالية",
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      onFieldSubmitted: (val) {
                        FocusScope.of(context)
                            .requestFocus(focusNode2);
                      },
                      focusNode:  focusNode1,
                      obscureText: true,
                      onChanged: (v) {},
                      keyboardType: TextInputType.text,
                      onSaved: (val) {
                        setState(() {
                          newPassword = val;
                        });
                      },
                      validator: (val) {
                        if (val.isEmpty) {
                          return "يرجىء ملىء كافة الحقول";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: "كلمة المرور الجديدة",
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      focusNode:  focusNode2,
                      obscureText: true,
                      onChanged: (v) {},
                      keyboardType: TextInputType.text,
                      onSaved: (val) {
                        setState(() {
                          confirmPassword = val;
                        });
                      },
                      validator: (val) {
                        if (val.isEmpty) {
                          return "يرجىء ملىء كافة الحقول";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: "تأكيد كلمة المرور",
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton.icon(
                        color: Colors.blue,
                        onPressed: () async {
                          if (_form.currentState.validate()) {
                            _form.currentState.save();
                            if (!await MyWidgets().checkConnect(context)) {
                              return;
                            }
                            if (oldPassword != data[0]["ac_password"]) {
                              MyWidgets().getAlertError(
                                  context,
                                  "بيانات غير صحيحة",
                                  "كلمة المرور الحالية غير صحيحة");
                              return;
                            }
                            if (newPassword != confirmPassword) {
                              MyWidgets().getAlertError(context,
                                  "بيانات غير صحيحة", "كلمة المرور غير متطابقة");
                              return;
                            }
                            if (await MyWidgets().getAlertQuestion(
                                context,
                                "تأكيد تغيير كلمة المرور",
                                "هل تريد بالفعل تغيير كلمة المرور")) {
                              await _changeMyData();
                            }
                          }
                        },
                        icon: Icon(
                          Icons.save,
                          color: Colors.white,
                        ),
                        label: Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              "حـــفـــظ",
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ))),
                    check
                        ? Container(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          CircularProgressIndicator()
                        ],
                      ),
                    )
                        : SizedBox(),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
