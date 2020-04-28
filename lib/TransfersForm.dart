import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'MyDatabase.dart';
import 'MyWidgets.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class TransfersForm extends StatefulWidget {
  @override
  _TransfersFormState createState() => _TransfersFormState();
}

class _TransfersFormState extends State<TransfersForm> {

  int transferFilterType = 1, transferFilterDate = 2;
  String dateTransfer,accId;
  List transferList,myData;
  bool check=false;

  Future _getMyData() async {
    try {
      List selectData;
      String sql = "select * from mydata";
      selectData = await MyDatabase().selectData(sql);
      setState(() {
        myData = selectData;
        accId=myData[0]["ac_id"];
      });

    } catch (ex) {
      MyWidgets().getAlertError(context,"حصل خطأ اثناء الاتصال","يرجئ اعادة المحاولة لاحقاً");
    }
  }
  Future<void> getTransfers() async {
    setState(() {
      check=true;
      transferList=null;
    });
   try{
     String sqlDate;
     if (transferFilterDate == 1) {
       sqlDate = " ";
     } else if (transferFilterDate == 2) {
       sqlDate = " and tr_date='$dateTransfer'";
     }
     String sqlStatus;
     if (transferFilterType == 4) {
       sqlStatus = " ";
     } else {
       sqlStatus = " and tr_status=$transferFilterType";
     }
     String sqlAccount=" and tbl_transfers.ac_id=$accId";
     List data = await MyWidgets().getData(
         "transfers.php?process_type=select_one&filter_date=$sqlDate&tr_status=$sqlStatus&ac_id=$sqlAccount");
     setState(() {
       if (data == null) {
         transferList = [
           {"result": "no"}
         ];
       } else {
         transferList = data;
       }

     });
   }catch(e){
     setState(() {
       transferList = [
         {"result": "no"}
       ];
     });
     MyWidgets().getAlertError(context,"حصل خطأ اثناء الاتصال","يرجئ اعادة المحاولة لاحقاً");
   }
  }
  ScrollController _scrollController=ScrollController();
  Future<void> _shareTransfer(String m) async {
    try {
      await Share.share(m,subject:  "مشاركة تفاصيل الحوالة");
    } catch (e) {
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    dateTransfer = MyWidgets().dateToday;
    _getMyData();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        floatingActionButton: _getFAB(context),
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () async{
                  if (!await MyWidgets().checkConnect(context)) {
                  return;
                  }
                  getTransfers();
                })
          ],
          title: Text("الحوالات"),
        ),
        body: Padding(
          padding: const EdgeInsets.only(right: 7, left: 7),
          child: ListView(
            controller: _scrollController,
            shrinkWrap: true,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              DropdownButtonFormField(
                  elevation: 4,
                  isDense: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      contentPadding: EdgeInsets.all(13)),
                  hint: Text("عرض حسب"),
                  value: transferFilterType,
                  items: [
                    DropdownMenuItem(
                      child: Center(child: Text("حوالات تحت الطلب")),
                      value: 1,
                    ),
                    DropdownMenuItem(
                      child: Center(child: Text("حوالات مرفوضة")),
                      value: 2,
                    ),
                    DropdownMenuItem(
                      child: Center(child: Text("حوالات تمت")),
                      value: 3,
                    ),
                    DropdownMenuItem(
                      child: Center(child: Text("الكل")),
                      value: 4,
                    ),
                  ],
                  onChanged: (v) {
                    setState(() {
                      transferFilterType = v;
                    });
                  }),
              SizedBox(
                height: 5,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: DropdownButtonFormField(
                          elevation: 4,
                          isDense: true,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              contentPadding: EdgeInsets.all(13)),
                          hint: Text("التاريخ"),
                          value: transferFilterDate,
                          items: [
                            DropdownMenuItem(
                              child: Center(child: Text("الكل")),
                              value: 1,
                            ),
                            DropdownMenuItem(
                              child: Center(child: Text("بتاريخ")),
                              value: 2,
                            ),
                          ],
                          onChanged: (v) {
                            setState(() {
                              transferFilterDate = v;
                            });
                          })),
                  SizedBox(
                    width: 10,
                  ),
                  FlatButton.icon(
                      onPressed: () async {
                        String data = await MyWidgets().selectDate(context);
                        setState(() {
                          dateTransfer = data;
                        });
                      },
                      icon: Icon(Icons.calendar_today),
                      label: Text(dateTransfer))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(right:3,left: 3),
                child: RaisedButton.icon(
                    onPressed: () async{
                      if (!await MyWidgets().checkConnect(context)) {
                        return;
                      }
                      getTransfers();
                    },
                    icon: Icon(Icons.remove_red_eye),
                    label: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "عـــرض",
                        style: TextStyle(fontSize: 20),
                      ),
                    )),
              ),
              SizedBox(
                height: 15,
              ),
             check?transferList != null && transferList[0]["result"] == "no"
               ? Center(child: Text("لاتوجد اي قيمة لعرضها"))
              : transferList == null
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: transferList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Card(
                    shape: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 10,
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "اسم الحساب : " +
                                transferList[index]["ac_name"],
                            style: TextStyle(color: Colors.blue),
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.share),
                                onPressed: () async {
                                  String msg="${"المبلغ : " +
                                      transferList[index]["tr_amount"]}\n"
                                      "${"العملة : " +
                                      transferList[index]["cu_name"]}\n"
                                      "${"المرسل : " +
                                      transferList[index]["tr_sender_name"]}\n"
                                      "${"المستلم : " +
                                      transferList[index]["tr_reciver_name"]}\n"
                                      "${"ملاحظات : " +
                                      transferList[index]["tr_notes"]}\n";
                                  await _shareTransfer(msg);
                                },
                              ),
                              Text((index+1).toString()),
                              Text(transferList[index]["tr_date"])
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Text("المبلغ : " +
                                  transferList[index]["tr_amount"]),
                              SizedBox(
                                width: 20,
                              ),
                              Text("العملة : " +
                                  transferList[index]["cu_name"]),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Text("المرسل : " +
                                  transferList[index]["tr_sender_name"]),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Text("المستلم : " +
                                  transferList[index]["tr_reciver_name"]),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Text("ملاحظات : " +
                                  transferList[index]["tr_notes"]),
                            ],
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              transferList[index]["tr_status"] == "1"
                                  ? Text("الحالة : " + "تحت الطلب")
                                  : transferList[index]["tr_status"] ==
                                  "2"
                                  ? Text("الحالة : " + "مرفوضة")
                                  : transferList[index]
                              ["tr_status"] ==
                                  "3"
                                  ? Text("الحالة : " + "تمت")
                                  : SizedBox(),
                            ],
                          )
                        ],
                      ),
                    ));
              }):SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  Widget _getFAB(context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SpeedDial(
        closeManually: true,
        elevation: 10,
        marginRight: 50,
        tooltip: "خصائص",
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22),
        visible: true,
        children: [
          SpeedDialChild(
              child: Icon(Icons.print),
              onTap: () {
                MyWidgets().getAlertWarning(context,"في التحديث القادم","هذه الميزة سيتم تفعيلها في التحديث القادم");
              },
              label: 'PDF طباعة',
              labelStyle: TextStyle(
                color: Colors.white,
              ),
              labelBackgroundColor: Colors.blue),
          SpeedDialChild(
              child: Icon(Icons.arrow_upward),
              onTap: () {
                _scrollController.animateTo(0.0, duration: Duration(seconds: 1), curve: Curves.easeInOut);
              },
              label: 'الصعود الى الاعلى',
              labelStyle: TextStyle(
                color: Colors.white,
              ),
              labelBackgroundColor: Colors.blue),
        ],
      ),
    );
  }
}
