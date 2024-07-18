import 'package:flutter/material.dart';
import 'package:my_friend/auth/register_screen.dart';
import 'package:my_friend/my_shar.dart';

import '../list/list.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();

    // 3 soniya kutib, OtherScreen ga otish
    Future.delayed(const Duration(seconds: 3), ()
    {
      if (isCheck() == true) {

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ListScreen()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => RegisterScreen()),
        );
      }
    });
  }


  Future<bool?> isCheck() async{
    var v= await MyShare.getName();
  return v;
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
      ),
      body: Center(
        child: Center(
          child: Image.network("https://i.pinimg.com/564x/9b/4a/9c"
              "/9b4a9c6aad04735a755b5f50d9040cd3.jpg"),
        ),
      ),
    );
  }
}

class OtherScreen extends StatelessWidget {
  const OtherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Boshqa Screen'),
      ),
    );
  }
}