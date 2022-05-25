import 'package:brahma_app/stores/login_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class HomePage extends StatefulWidget {
  static String id = "/";
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(width: MediaQuery.of(context).size.width,),
          Text('${context.read<LoginStore>().userData["email"]!} ${context.read<LoginStore>().userData["name"]!} ${context.read<LoginStore>().userData["rollno"]!}'),
          ElevatedButton(onPressed: (){
            context.read<LoginStore>().logOut(context);
          }, child: Text("LogOut"))
        ],
      )
    );
  }
}
