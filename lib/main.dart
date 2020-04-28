import 'AddTransfer.dart';
import 'ChangePassword.dart';
import 'DetectAccount.dart';
import 'LoginForm.dart';
import 'MyDatabase.dart';
import 'TransfersForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'About.dart';
import 'ClassInfo.dart';
import 'MyWidgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';


var initForm = "mainform";
Future<bool> checkLogin(acPhone,acPassword) async {
  try {
    if (!await MyWidgets().checkConnect()) {
      return false;
    }
    List data = await MyWidgets()
        .getData("login.php?phone=$acPhone&password=$acPassword");
    if (data[0]["ac_id"] != null && data[0]["ac_active"] != "0") {
      return true;
    }
    return false;
  }
  catch(ex){
    return false;
  }
}
void main() {
runApp(Progress());
}

class Progress extends StatefulWidget {
  @override
  _ProgressState createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  bool checkData=false;
  void loadData()async{
    try {
      setState(() {
        checkData=true;
      });
      List result;
      String sqlSelect = "select * from mydata";
      result = await MyDatabase().selectData(sqlSelect);
      if (result != null && result.length > 0 && result[0]["re"] != null) {
        if(await checkLogin(result[0]["ac_phone"],result[0]["ac_password"])==true){
          initForm = "mainform";
        }else{
          initForm = "loginform";
        }
      } else {
        initForm = "loginform";
      }
    } catch (ex) {
      String sql = "delete from mydata";
      await MyDatabase().deleteData(sql);
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }finally{
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        checkData=false;
      });
     runApp(MyApp());
    }
  }
  @override
  void initState() {
    loadData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.blue,
      home: Scaffold(
        body: Center(
          child: checkData?Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/images/icon.png",
                height: 200,
                width: 200,
              ),
              Image.asset(
                "assets/images/loading_dots.gif",
                width: 100,
              ),
            ],
          ):Text("Done"),
        ),
      ),
    );
  }
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        FocusScope.of(context).unfocus();
      },
      child: MaterialApp(
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/addtransfer':
              return PageTransition(
                  child: AddTransfer(),
                  type: PageTransitionType.scale,
                  duration: Duration(seconds: 1));
              break;
            case '/transfersform':
              return PageTransition(
                  child: TransfersForm(),
                  type: PageTransitionType.scale,
                  duration: Duration(seconds: 1));
              break;
            case '/detectaccount':
              return PageTransition(
                  child: DetectAccount(),
                  type: PageTransitionType.scale,
                  duration: Duration(seconds: 1));
              break;

            case '/changepassword':
              return PageTransition(
                  child: ChangePassword(),
                  type: PageTransitionType.scale,
                  duration: Duration(seconds: 1));
              break;
            case '/about':
              return PageTransition(
                  child: About(),
                  type: PageTransitionType.scale,
                  duration: Duration(seconds: 1));
              break;
            default:
              return null;
          }
        },
        theme: ThemeData(fontFamily: "NotoIKEAArabic-Bold"),
        debugShowCheckedModeBanner: false,
        routes: {
          'mainform': (context) => MainForm(),
          'loginform': (context) => LoginForm(),
          'addtransfer': (context) => AddTransfer(),
          'transfersform': (context) => TransfersForm(),
          'detectaccount': (context) => DetectAccount(),
          'changepassword': (context) => ChangePassword(),
          'about': (context) => About(),
        },
        initialRoute: initForm,
      ),
    );
  }
}

class MainForm extends StatefulWidget {
  @override
  _MainFormState createState() => _MainFormState();
}

class _MainFormState extends State<MainForm> {


  List data;



////////////////// main form ///////////
  @override
  void initState() {
    super.initState();
    _getDataDrawer();
  }


  @override
  Widget build(BuildContext context) {
    GetSize _getSize = GetSize(context);
    double dim =
        MediaQuery.of(context).size.height / MediaQuery.of(context).size.width;
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          drawer: getDrawer(),
          appBar: AppBar(
            title: Text("الشاشة الرئيسية"),
            centerTitle: true,
          ),
          body: Padding(
              padding: EdgeInsets.only(
                  top: _getSize.paddingTop,
                  bottom: _getSize.paddingBottom,
                  right: _getSize.paddingRight,
                  left: _getSize.paddingLeft),
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: _getSize.paddingAll,
                mainAxisSpacing: _getSize.paddingAll,
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      Navigator.pushNamed(context, '/addtransfer');
                    },
                    child: Card(
                      shape:
                      UnderlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      color: Colors.grey[300],
                      elevation: 10,
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.speaker_notes,
                            size: dim * 30,
                            color: Colors.blue,
                          ),
                          SizedBox(
                            height: _getSize.paddingBottom,
                          ),
                          Text(
                            "طلب حوالة",
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      Navigator.pushNamed(context, '/transfersform');
                    },
                    child: Card(
                      shape:
                      UnderlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      color: Colors.grey[300],
                      elevation: 10,
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.send,
                            size: dim * 30,
                            color: Colors.blue,
                          ),
                          SizedBox(
                            height: _getSize.paddingBottom,
                          ),
                          Text(
                            "حوالاتي",
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      Navigator.pushNamed(context, '/detectaccount');
                    },
                    child: Card(
                      shape:
                      UnderlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      color: Colors.grey[300],
                      elevation: 10,
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.assignment,
                            size: dim * 30,
                            color: Colors.blue,
                          ),
                          SizedBox(
                            height: _getSize.paddingBottom,
                          ),
                          Text(
                            "كشف حسابي",
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      MyWidgets().getAlertInfo(context,"الخدمة غير متوفره حاليا","سيتم تفعيل هذه الخدمة في التحديث القادم");
                    },
                    child: Card(
                      shape:
                      UnderlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      color: Colors.grey[300],
                      elevation: 10,
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.perm_phone_msg,
                            size: dim * 30,
                            color: Colors.blue,
                          ),
                          SizedBox(
                            height: _getSize.paddingBottom-7,
                          ),
                          Text(
                            "طلب تعبئة",
                          ),
                          Text("رصيد")
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      Navigator.pushNamed(context, '/about');
                    },
                    child: Card(
                      shape:
                      UnderlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      color: Colors.grey[300],
                      elevation: 10,
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.contact_phone,
                            size: dim * 30,
                            color: Colors.blue,
                          ),
                          SizedBox(
                            height: _getSize.paddingBottom,
                          ),
                          Text(
                            "تواصل معنا",
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              ) ),
        ));
  }

  Widget myUserDrawer() {
    if (data != null && data.length > 0) {
      return UserAccountsDrawerHeader(
          accountName: Text(data[0]["ac_phone"]),
          accountEmail: Text(data[0]["ac_name"]));
    } else {
      return CircularProgressIndicator();
    }
  }

  _logOut() async {
    String sql = "delete from mydata";
    await MyDatabase().deleteData(sql);
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  Future _getDataDrawer() async {
    try {
      List selectData;
      String sql = "select * from mydata";
      selectData = await MyDatabase().selectData(sql);
      setState(() {
        data = selectData;
      });
    } catch (ex) {
      MyWidgets().getAlertError(context,"حصل خطأ اثناء الاتصال","يرجئ اعادة المحاولة لاحقاً");
    }
  }

  Widget getDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          myUserDrawer(),
          ListTile(
            title: Text("طلب ارسال حوال"),
            leading: Icon(
              Icons.speaker_notes,
            ),
            onTap: () {
              Navigator.pushNamed(context, '/addtransfer');
            },
          ),
          ListTile(
            title: Text("حوالاتي"),
            leading: Icon(
              Icons.send,
            ),
            onTap: () {
              Navigator.pushNamed(context, '/transfersform');
            },
          ),
          ListTile(
            title: Text("كشف حسابي"),
            leading: Icon(
              Icons.assignment,
            ),
            onTap: () {
              Navigator.pushNamed(context, '/detectaccount');
            },
          ),
          Divider(
            thickness: 1,
          ),
          ListTile(
            title: Text("تغيير كلمة المرور"),
            leading: Icon(
              Icons.account_circle,
            ),
            onTap: () {
              Navigator.pushNamed(context, '/changepassword');
            },
          ),
          Divider(
            thickness: 1,
          ),
          ListTile(
            title: Text("خـــروج"),
            leading: Icon(
              FontAwesomeIcons.signOutAlt,
            ),
            onTap: () {
              _logOut();
            },
          ),
        ],
      ),
    );
  }
}

