import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'MyDatabase.dart';
import 'MyWidgets.dart';

class DetectAccount extends StatefulWidget {
  @override
  _DetectAccountState createState() => _DetectAccountState();
}

class _DetectAccountState extends State<DetectAccount> {
  String dateFilter, dateFilter1, dateFilter2,accId;
  List reportList=["null"], currenciesList,myData;
  int typeFilter = 1, _currency, _detectType;
  List detectTypeList = [
    {"name": "تفصيلي", "id": "1"},
    {"name": "تجميعي", "id": "2"}
  ];
  List dateList = [
    {"name": "خلال يوم", "id": "1"},
    {"name": "حتى يوم", "id": "2"},
    {"name": "خلال شهر", "id": "3"},
    {"name": "بين تاريخين", "id": "4"}
  ];

  var dataTable;
  ScrollController _scrollController=ScrollController();
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
  Future<void> getReport() async {
    try {
      reportList=null;
      dataTable = null;
      if (_currency == null || _detectType == null) {
        MyWidgets().getAlertWarning(
            context, "حقول فارغة", "الرجاء تحديد عناصر عرض الكشف");
        reportList=["null"];
        return;
      }
      String sqlDate, sqlCurrency;
      if (typeFilter == 1) {
        sqlDate = " and tbl_entriesdetails.de_date='$dateFilter1' ";
      } else if (typeFilter == 2) {
        sqlDate = " and tbl_entriesdetails.de_date<='$dateFilter1' ";
      } else if (typeFilter == 3) {
        sqlDate = " and month(tbl_entriesdetails.de_date)=$dateFilter1 ";
      } else if (typeFilter == 4) {
        sqlDate =
            " and tbl_entriesdetails.de_date between '$dateFilter1' and '$dateFilter2' ";
      }
      if (_currency == 0) {
        sqlCurrency = " ";
      } else {
        sqlCurrency = " and tbl_entriesdetails.cu_id=$_currency ";
      }

      List data = await MyWidgets().getData("one_account_rpt.php?"
          "process_type=$_detectType&ac_id=$accId&cu_id=$sqlCurrency&filter_date=$sqlDate");
      setState(() {
        if (data == null) {
          reportList = [
            {"result": "no"}
          ];
        } else {
          reportList = data;
        }
        if(reportList != null &&
            reportList[0]["result"] == "no"){
          dataTable=Center(child: Text("لاتوجد اي قيمة لعرضها"));
        }else{
          if (_detectType == 1) {
            dataTable = Card(
              elevation: 10,
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                          columns: [
                            DataColumn(
                                label: Text(
                                  "مدين",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.blue[700]),
                                )),
                            DataColumn(
                                label: Text("دائن",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.blue[700]))),
                            DataColumn(
                                label: Text("العملة",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.blue[700]))),
                            DataColumn(
                                label: Text("اسم المستند",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.blue[700]))),
                            DataColumn(
                                label: Text("رقم المستند",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.blue[700]))),
                            DataColumn(
                                label: Text("التاريخ",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.blue[700]))),
                            DataColumn(
                                label: Text("الملاحظات",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.blue[700]))),
                          ],
                          rows: reportList.map((val) {
                            return DataRow(cells: [
                              DataCell(Text(val["maden"])),
                              DataCell(Text(val["daen"])),
                              DataCell(Text(val["cu_name"])),
                              DataCell(Text(val["do_name"])),
                              DataCell(Text(val["do_id"])),
                              DataCell(Text(val["de_date"])),
                              DataCell(Text(val["de_notes"])),
                            ]);
                          }).toList()))),
            );
          }
          else if (_detectType == 2) {
            dataTable = Card(
              elevation: 10,
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                          columns: [
                            DataColumn(
                                label: Text(
                                  "مدين",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.blue[700]),
                                )),
                            DataColumn(
                                label: Text("دائن",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.blue[700]))),
                            DataColumn(
                                label: Text("العملة",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.blue[700]))),
                            DataColumn(
                                label: Text("المقابل مدين",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.blue[700]))),
                            DataColumn(
                                label: Text("المقابل دائن",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.blue[700]))),
                          ],
                          rows: reportList.map((val) {
                            return DataRow(cells: [
                              DataCell(Text(val["maden"])),
                              DataCell(Text(val["daen"])),
                              DataCell(Text(val["cu_name"])),
                              DataCell(Text(val["mcmaden"])),
                              DataCell(Text(val["mcdaen"])),
                            ]);
                          }).toList()))),
            );
          }
        }

      });
    } catch (e) {
      MyWidgets().getAlertError(
          context, "حصل خطأ اثناء الاتصال", "يرجئ اعادة المحاولة لاحقاً");
      reportList=["null"];
    }
  }
  Future<void> getData() async {
    try {
      List data = await MyWidgets().getData("currencies.php");
      setState(() {
        currenciesList = data;
        currenciesList.add({"cu_name": "كافة العملات", "cu_id": "0"});
      });

    } catch (e) {
      MyWidgets().getAlertError(context,"حصل خطأ اثناء الاتصال","يرجئ اعادة المحاولة لاحقاً");
    }
  }

  @override
  void initState() {
    super.initState();
    dateFilter = dateFilter1 = dateFilter2 = MyWidgets().dateToday;
    getData();
    _getMyData();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: (){
          _scrollController.animateTo(0.0, duration: Duration(seconds: 1), curve: Curves.easeInOut);
        },child: Icon(Icons.arrow_upward),),
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () async{
                  if (!await MyWidgets().checkConnect(context)) {
                    return;
                  }
                  getData();
                })
          ],
          title: Text("كشف حساب واحد"),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 5, right: 5, left: 5),
          child: ListView(
            controller: _scrollController,
            shrinkWrap: true,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              detectTypeList != null
                  ? DropdownButtonFormField(
                      decoration: InputDecoration(
                        filled: true,
                        contentPadding: EdgeInsets.all(13),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: "نوع الكشف",
                      ),
                      value: _detectType,
                      isDense: true,
                      items: detectTypeList.map((item) {
                        return DropdownMenuItem(
                          child: Center(child: Text(item["name"].toString())),
                          value: int.parse(item["id"]),
                        );
                      }).toList(),
                      onChanged: (v) {
                        setState(() {
                          _detectType = v;
                        });
                      })
                  : Center(child: CircularProgressIndicator()),
              SizedBox(
                height: 10,
              ),
              currenciesList != null
                  ? DropdownButtonFormField(
                      decoration: InputDecoration(
                        filled: true,
                        contentPadding: EdgeInsets.all(13),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: "العملة",
                      ),
                      value: _currency,
                      isDense: true,
                      items: currenciesList.map((item) {
                        return DropdownMenuItem(
                          child: Wrap(
                            children: <Widget>[
                              Center(child: Text(item["cu_name"].toString())),
                            ],
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
              SizedBox(
                height: 10,
              ),
              dateList != null
                  ? DropdownButtonFormField(
                      decoration: InputDecoration(
                        filled: true,
                        contentPadding: EdgeInsets.all(13),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: "التاريخ",
                      ),
                      value: typeFilter,
                      isDense: true,
                      items: dateList.map((item) {
                        return DropdownMenuItem(
                          child: Wrap(
                            children: <Widget>[
                              Center(child: Text(item["name"].toString())),
                            ],
                          ),
                          value: int.parse(item["id"]),
                        );
                      }).toList(),
                      onChanged: (v) {
                        setState(() {
                          typeFilter = v;
                        });
                      })
                  : Center(child: CircularProgressIndicator()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FlatButton.icon(
                      onPressed: () async {
                        if (typeFilter == 3) {
                          int date = await MyWidgets().selectDateMonth(context);
                          setState(() {
                            dateFilter1 = date.toString();
                          });
                        } else {
                          String date = await MyWidgets().selectDate(context);
                          setState(() {
                            dateFilter1 = date;
                          });
                        }
                      },
                      icon: Icon(Icons.calendar_today),
                      label: Text(dateFilter1.toString())),
                  FlatButton.icon(
                      onPressed: () async {
                        String date = await MyWidgets().selectDate(context);
                        setState(() {
                          dateFilter2 = date;
                        });
                      },
                      icon: Icon(Icons.calendar_today),
                      label: Text(dateFilter2.toString())),
                ],
              ),
              RaisedButton.icon(
                  onPressed: () async {
                    if (!await MyWidgets().checkConnect(context)) {
                      return;
                    }
                    setState(() {
                      getReport();
                    });
                  },
                  icon: Icon(Icons.remove_red_eye),
                  label: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "عـــرض",
                      style: TextStyle(fontSize: 20),
                    ),
                  )),
              SizedBox(
                height: 10,
              ),
              dataTable != null?dataTable :reportList==null?Center(child: CircularProgressIndicator()):SizedBox(),
            ],
          ),
        ),
      ),
    );
  }


}
