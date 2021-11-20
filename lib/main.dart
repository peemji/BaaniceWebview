import 'package:baanice/show_web.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_login/flutter_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:baanice/getdata.dart';

void main() {
  runApp(MyApp());
}

class GetData {
  final String username;
  final String token;

  const GetData(this.username, this.token);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //initialRoute: '/',
      routes: <String, WidgetBuilder>{
        //'/': (BuildContext context) => MyApp(),
        '/ShowWeb': (BuildContext context) => ShowWeb(),
      },
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'ระบบหลังร้าน บ้านไอซ์เชียงใหม่'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var errorMsg;
  final TextEditingController usernameController =
      new TextEditingController(text: 'i003');
  final TextEditingController passwordController =
      new TextEditingController(text: '3');
  static String _tk = '';
  static String _tk1 = '';

  @override
  void initState() {
    super.initState();
    _loadtk();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FlutterLogin(
        navigateBackAfterRecovery: true,
        title: 'บ้านไอซ์ เชียงใหม่',
        logo: 'assets/images/baaniceTran.png',
        logoTag: 'Baanice',
        userType: LoginUserType.name,
        hideForgotPasswordButton: true,
        hideSignUpButton: true,
        messages: LoginMessages(
          userHint: 'ชื่อผูใช้',
          passwordHint: 'รหัสผ่าน',
        ),
        theme: LoginTheme(
          primaryColor: Colors.teal,
          titleStyle: TextStyle(fontSize: 35),
        ),
        onSignup: (loginData) {},
        onLogin: (loginData) {
          //signIn(LoginData.name, LoginData.password);
          _loadtk();
          return _loginUser(loginData);
        },
        onRecoverPassword: (name) {},
        userValidator: (value) {
          if (value!.isEmpty) {
            return "โปรดระบุชื่อผู้ใช้";
          }
          return null;
        },
        passwordValidator: (value) {
          if (value!.isEmpty) {
            return 'โปรดระบุรหัสผ่าน';
          }
          return null;
        },
        // onSubmitAnimationCompleted: (LoginData) async {
        //   Map data = {'user': LoginData.name, 'password': LoginData.password};
        //   var response = await http.post(
        //       Uri.parse('http://banice.thairoyalfrozen.com/users/login'),
        //       body: data);
        //   print(response.statusCode);
        //   Navigator.of(context).pushReplacement(
        //     MaterialPageRoute(
        //       builder: (context) => MyApp(),
        //     ),
        //   );
        // },
      ),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text(widget.title),
    //   ),
    //   body: Center(
    //     child: _isLoading
    //         ? Center(child: CircularProgressIndicator())
    //         : Column(
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             children: <Widget>[
    //               Padding(
    //                 padding: const EdgeInsets.all(8.0),
    //                 child: TextFormField(
    //                   controller: usernameController,
    //                   decoration: const InputDecoration(
    //                     border: OutlineInputBorder(),
    //                     hintText: 'username',
    //                   ),
    //                   validator: (value) {
    //                     if (value!.isEmpty) {
    //                       return 'Username is required';
    //                     }
    //                     return null;
    //                   },
    //                 ),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.all(8.0),
    //                 child: TextFormField(
    //                   controller: passwordController,
    //                   decoration: const InputDecoration(
    //                     border: OutlineInputBorder(),
    //                     hintText: 'password',
    //                   ),
    //                   validator: (value) {
    //                     if (value!.isEmpty) {
    //                       return 'Password is required';
    //                     }
    //                     return null;
    //                   },
    //                 ),
    //               ),
    //               Container(
    //                 width: double.infinity,
    //                 padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
    //                 margin: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
    //                 child: ElevatedButton(
    //                   onPressed: () {
    //                     print("Login pressed");
    //                     setState(() {
    //                       _isLoading = true;
    //                     });
    //                     signIn(
    //                         usernameController.text, passwordController.text);
    //                   },
    //                   child: Text('LOGIN'),
    //                 ),
    //               ),
    //             ],
    //           ),
    //   ),
    // );
  }

  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 1000);
  Future<String?> _loginUser(LoginData data) {
    return Future.delayed(loginTime).then((_) async {
      if (_tk.isNotEmpty) {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ShowWeb(),
        //     settings: RouteSettings(arguments: _tk),
        //   ),
        // );
        //Navigator.pushNamed(context, '/ShowWeb', arguments: _tk);
        Navigator.pushReplacementNamed(context, '/ShowWeb', arguments: _tk);
      } else {
        Map data1 = {'user': data.name, 'password': data.password};
        var response = await http.post(
            Uri.parse('http://banice.thairoyalfrozen.com/users/login'),
            body: data1);
        if (response.statusCode == 200) {
          //final receiveData = ModalRoute.of(context)!.settings.arguments;
          //var result = getDataFromJson(jsonEncode(receiveData));
          //print(response.body);
          var result = getDataFromJson(response.body);
          String token = result.users.token;
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => ShowWeb(),
          //     settings: RouteSettings(arguments: token),
          //   ),
          // );
          //Navigator.pushNamed(context, '/ShowWeb', arguments: token);
          Navigator.pushReplacementNamed(context, '/ShowWeb', arguments: token);
        } else {
          return 'Password does not match';
        }
      }
    });
  }

  void _loadtk() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      //prefs.clear();
      _tk = (prefs.getString('tk') ?? '');
    });
    print('222222');
    print(_tk1);
    if (_tk.isNotEmpty) {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => ShowWeb(),
      //     settings: RouteSettings(arguments: _tk),
      //   ),
      // );
      Navigator.pushReplacementNamed(context, '/ShowWeb', arguments: _tk);
    }
  }

  // signIn(String mobile, pass) async {
  //   Map data = {'user': mobile, 'password': pass};
  //   var jsonResponse = null;
  //   var response = await http.post(
  //       Uri.parse('http://banice.thairoyalfrozen.com/users/login'),
  //       body: data);
  //   print(response.statusCode);
  //   if (response.statusCode == 200) {
  //     jsonResponse = json.decode(response.body);
  //     //Map dataResponse = jsonDecode(response.body);
  //     print(response.body);
  //     if (jsonResponse != null) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => ShowWeb(),
  //           settings: RouteSettings(arguments: jsonDecode(response.body)),
  //         ),
  //       );
  //     }
  //   } else {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     errorMsg = response.body;
  //     print("The error message is: ${response.body}");
  //     return 'Password does not match';
  //   }
  // }
}
