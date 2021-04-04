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
  int currentPage=0;
  int totalPages=0;
  int pageSize=20;
  List<dynamic> items=[];
  ScrollController scrollController=new ScrollController(); //Pour controller le scrolling d'une page

  void _search(String query) { //envoie une requette http vers la partie back-end (api de github) et on récupére les données
    //String url="https://api.github.com/search/users?q=${query}&per_page=20&page=0";
    http.get(Uri.parse('https://api.github.com/search/users?q=${query}&per_page=$pageSize&page=$currentPage'))
        .then((response){
          setState(() {
            data=json.decode(response.body);
             this.items.addAll(data['items']); // on stock les données dans la liste pour pouvoir les retrouvées quant on remonte le scrolling
            if(data['total_count'] % pageSize ==0){
              totalPages=data['total_count']~/pageSize;  //division entiére
            }
            else{
              totalPages=(data['total_count']/pageSize).floor() +1;
            }
          });
    })
        .catchError((err){
          print(err);
    });
  }

  //cette methode s'exécute avant la methode builder, juste aprés l'instanciation du state
  //Utilisé pour initialiser les données
  //Elle s'execute une seule fois
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController.addListener(() {
      if(scrollController.position.pixels==scrollController.position.maxScrollExtent){
        setState(() {
          if(currentPage<totalPages-1){
            ++currentPage;
            _search(query);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${query} . Pages : $currentPage sur $totalPages"),
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
                    //Nouvelle recherche
                    items=[];
                    currentPage=0;

                    this.query=queryTextEditingController.text; // récuperation du text qui à été saisit
                    _search(query);
                  });
                },)
              ],
            ),
            Expanded(
              child: ListView.builder( //permet de faire une boucle et d'afficher les elements
                controller: scrollController,
                itemCount: items.length,  //(data==null)?0: data['items'].length,  // nombre d'element dans la liste
                  itemBuilder: (context,index){
                    return ListTile(  // Element de la liste
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(items[index]['avatar_url']), //NetworkImage(data['items'][index]['avatar_url']),
                                radius: 40,
                              ),
                              SizedBox(width: 20,),
                              Text("${items[index]['login']}"),
                            ],
                          ),
                          CircleAvatar(
                            child: Text("${items[index]['score']}"),
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
