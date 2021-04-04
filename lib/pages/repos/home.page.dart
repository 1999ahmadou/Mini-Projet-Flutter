import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GitRepositorisPage extends StatefulWidget {
  String  login;
  String avatarUrl;
  String langage;
  GitRepositorisPage({this.login,this.avatarUrl,this.langage});

  @override
  _GitRepositorisPageState createState() => _GitRepositorisPageState();
}

class _GitRepositorisPageState extends State<GitRepositorisPage> {
  dynamic dataRepos;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRepositories();
  }

  void getRepositories() async{
    http.Response response= await http.get(Uri.parse("https://api.github.com/users/${widget.login}/repos"));
    if(response.statusCode==200){
      setState(() {
        dataRepos=json.decode(response.body);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.avatarUrl),
          )
        ],
        title: Text("${widget.login}"),
      ),
      body: Center(
        child: ListView.separated(
            itemBuilder: (context,index)=>ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text("${dataRepos[index]['name']}",style: TextStyle(fontSize: 15),),
                      //SizedBox(width: 60,),
                    ],
                  ),
                  Text("${dataRepos[index]['language']}",style: TextStyle(fontWeight: FontWeight.bold,),),
                ],
              ),
            ),
            separatorBuilder: (context,index)=>Divider(height: 2,color: Colors.deepOrange,),
            itemCount: dataRepos==null? 0 : dataRepos.length
        ),
      ),
    );
  }
}
