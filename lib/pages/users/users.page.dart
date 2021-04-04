import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // dependence pour envoyer les requettes

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  String query;
  bool notVisible=false;
  TextEditingController queryTextEditingController=new TextEditingController();
  dynamic data; // pour stocker les données au format json

  void _search(String query) { //envoie une requette http vers la partie back-end (api de github) et on récupére les données
    //String url="https://api.github.com/search/users?q=${query}&per_page=20&page=0";
    http.get(Uri.parse('https://api.github.com/search/users?q=${query}&per_page=20&page=0'))
        .then((response){
          setState(() {
            this.data=json.decode(response.body);
          });
    })
        .catchError((err){
          print(err);
    });
  }

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
                    _search(query);
                  });
                },)
              ],
            ),
            Expanded(
              child: ListView.builder( //permet de faire une boucle et d'afficher les elements
                itemCount:(data==null)?0: data['items'].length,  // nombre d'element dans la liste
                  itemBuilder: (context,index){
                    return ListTile(  // Element de la liste
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(data['items'][index]['avatar_url']),
                                radius: 40,
                              ),
                              SizedBox(width: 20,),
                              Text("${data['items'][index]['login']}"),
                            ],
                          ),
                          CircleAvatar(
                            child: Text("${data['items'][index]['score']}"),
                          )
                        ],
                      ),
                    );
                  }
              ),
            )
          ],
        ),
      ),
    );
  }
}
