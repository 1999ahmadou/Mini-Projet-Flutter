
import 'package:flutter/material.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  String query;
  bool notVisible=false;

  TextEditingController queryTextEditingController=new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User : ${query}"),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        obscureText: notVisible, // pour cacher la saisit du text (géneralement pour les password)
                        onChanged: (value){ // Pour avoir quelque chose de reactif
                          setState(() {
                            this.query=value;
                          });
                        },
                        controller: queryTextEditingController,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: (){
                                setState(() {
                                  notVisible=!notVisible; // pour basculer du mode visible à invisible et inversement
                                });
                              },
                                icon: Icon(
                                    notVisible==true? Icons.visibility_off : Icons.visibility
                                )
                            ),
                            contentPadding: EdgeInsets.only(left: 20),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(
                                    width: 2,
                                    color: Colors.deepOrange
                                )
                            )
                        ),
                      )
                  ),
                ),
                IconButton(icon: Icon(Icons.search,color: Colors.deepOrange,),onPressed: (){
                  setState(() {
                    this.query=queryTextEditingController.text; // récuperation du text qui à été saisit
                  });
                },)
              ],
            )
          ],
        ),
      ),
    );
  }
}
