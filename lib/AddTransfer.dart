import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'MyDatabase.dart';
import 'MyWidgets.dart';

class AddTransfer extends StatefulWidget {
  @override
  _AddTransferState createState() => _AddTransferState();
}

class _AddTransferState extends State<AddTransfer> {
  GlobalKey<FormState> _form = GlobalKey<FormState>();
  List currenciesList, myData;
  int _currency;
  String accId, sender, receiver, notes, trDate;
  double _amount;
  bool check = false;
  FocusNode myFocusNode1 = FocusNode();
  FocusNode myFocusNode2 = FocusNode();
  FocusNode myFocusNode3 = FocusNode();
  TextEditingController _txtAmount = TextEditingController();
  TextEditingController _txtSender = TextEditingController();
  TextEditingController _txtReceiver = TextEditingController();
  Future _getMyData() async {
    try {
      List selectData;
      String sql = "select * from mydata";
      selectData = await MyDatabase().selectData(sql);
      setState(() {
        myData = selectData;
        accId = myData[0]["ac_id"];
      });
    } catch (ex) {
      MyWidgets().getAlertError(
          context, "حصل خطأ اثناء الاتصال", "يرجئ اعادة المحاولة لاحقاً");
    }
  }

  Future<void> getData() async {
    try {
      List data = await MyWidgets().getData("currencies.php");
      setState(() {
        currenciesList = data;
      });
    } catch (e) {
      MyWidgets().getAlertError(
          context, "حصل خطأ اثناء الاتصال", "يرجئ اعادة المحاولة لاحقاً");
    }
  }

  Future<void> insertTransfer() async {
    try {
      setState(() {
        check = true;
      });
      var date = {
        "tr_amount": _amount,
        "cu_id": _currency,
        "tr_sender_name": sender,
        "tr_reciver_name": receiver,
        "ac_id": accId,
        "tr_notes": notes,
        "tr_date": trDate,
      };
      if (await MyWidgets()
          .setData("transfers.php?process_type=insert", date)) {
       await MyWidgets().getAlertSuccess(context, "طلب حوالة", "تمت العملية بنجاح");
      } else {
        MyWidgets().getAlertError(
            context, "حصل خطأ", "لا يمكن تنفيذ هذه العملية");
      }
    } catch (e) {
      MyWidgets().getAlertError(
          context, "حصل خطأ اثناء الاتصال", "يرجئ اعادة المحاولة لاحقاً");
    } finally {
      setState(() {
        check = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
    _getMyData();
    setState(() {
      trDate = MyWidgets().dateToday;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.clear_all),
                onPressed: () async {
                  _txtAmount.text = "";
                  _txtSender.text = "";
                  _txtReceiver.text = "";
                  FocusScope.of(context).requestFocus(myFocusNode1);
                },
              ),
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () async {
                  if (!await MyWidgets().checkConnect(context)) {
                    return;
                  }
                  getData();
                },
              ),
            ],
            title: Text("طلب ارسال حوالة"),
          ),
          body: Padding(
            padding: EdgeInsets.all(10),
            child: Form(
              key: _form,
              child: ListView(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          controller: _txtAmount,
                          focusNode: myFocusNode1,
                          keyboardType: TextInputType.number,
                          onFieldSubmitted: (val) {
                            FocusScope.of(context).requestFocus(myFocusNode2);
                          },
                          onSaved: (val) {
                            setState(() {
                              _amount = double.parse(val);
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
                            labelText: "المبلغ",
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: currenciesList != null
                            ? DropdownButtonFormField(
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  labelText: "العملة",
                                ),
                                value: _currency,
                                isDense: true,
                                items: currenciesList.map((item) {
                                  return DropdownMenuItem(
                                    child: Center(
                                      child: Text(item["cu_name"].toString()),
                                    ),
                                    value: int.parse(item["cu_id"]),
                                  );
                                }).toList(),
                                onChanged: (v) {
                                  setState(() {
                                    _currency = v;
                                  });
                                })
                            : Center(child: CircularProgressIndicator()),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _txtSender,
                    focusNode: myFocusNode2,
                    onFieldSubmitted: (val) {
                      FocusScope.of(context).requestFocus(myFocusNode3);
                    },
                    keyboardType: TextInputType.text,
                    onSaved: (val) {
                      setState(() {
                        sender = val;
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
                      labelText: "اسم المرسل",
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _txtReceiver,
                    focusNode: myFocusNode3,
                    keyboardType: TextInputType.text,
                    onSaved: (val) {
                      setState(() {
                        receiver = val;
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
                      labelText: "اسم المستلم",
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    onSaved: (val) {
                      setState(() {
                        notes = val;
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: "ملاحظات",
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  RaisedButton.icon(
                      onPressed: () async {
                        if (_form.currentState.validate()) {
                          _form.currentState.save();
                          if (!await MyWidgets().checkConnect(context)) {
                            return;
                          }
                          if (_currency == null) {
                            MyWidgets().getAlertWarning(context, "حقول فارغة",
                                "يرجئ تعبئة كافة الحقول");
                            return;
                          }
                          if (await MyWidgets().getAlertQuestion(
                              context,
                              "تأكيد طلب ارسال حوالة",
                              "هل تريد بالفعل طلب ارسال حوالة")) {
                            insertTransfer();
                          }
                        }
                      },
                      color: Colors.blue,
                      textColor: Colors.white,
                      icon: Icon(Icons.receipt),
                      label: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "طــلــب",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ))),
                  SizedBox(
                    height: 20,
                  ),
                  check
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircularProgressIndicator(),
                          ],
                        )
                      : SizedBox()
                ],
              ),
            ),
          ),
        ));
  }
}
