import 'package:flutter/material.dart';
import 'package:recipe/api_services.dart';
import 'package:url_launcher/url_launcher.dart';

String removeHtmlTags(String htmlText) {
  final regex = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false);
  return htmlText.replaceAll(regex, '');
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  final _ingredient=TextEditingController();
  dynamic api;
  bool isReady=false;
  _getapiwithoutmodel()async{
    final ingredient=_ingredient.text;
    isReady=true;
    ApiServices().getapiwithoutmodel(ingredient).then((value){
      setState(() {
        api=value;
        isReady=false;
      });
    });
  }
  @override
  void initState(){
   // _getapiwithoutmodel();
    super.initState();
  }
  Future<void> _launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Could not launch $url')),
    );
  }
}
  @override
  Widget build(BuildContext context) {
    //final recipe = api?['results'] != null && api['results'].isNotEmpty ? api['results'][0] : null;
    return Scaffold(
      appBar: AppBar(
        title: Text("Recipe Finder"),
      ),
      body:isReady==true?
      Center(
        child: CircularProgressIndicator(),
      ):
      
       Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: TextField(
                controller: _ingredient,
                decoration: InputDecoration(
                  labelText: "Ingredient",
                  labelStyle:TextStyle(fontSize: 20,), 
                  enabledBorder:OutlineInputBorder(borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: Colors.black,width: 2))
                ),
              ),
            ),
          ),
          ElevatedButton(onPressed: _getapiwithoutmodel,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
           child: Text("Recipe",style: TextStyle(color: Colors.white),),),
          Expanded(
            child: ListView.builder(
              itemCount: 1,
              itemBuilder:(context,index){
                final sourceUrl = api?['results']?[0]?['sourceUrl'] ?? '';
                return ListTile(
                  title:  Text("Title: ${api?['results']?[0]?['title'] ??'No data'}"),
                  subtitle: Text(removeHtmlTags("Summary:${api?['results']?[0]?['summary']??'No data'}")),
                  trailing: GestureDetector(
                    onTap: () {
                      //final url = api?['results']?[0]?['sourceUrl'] ?? '';
                      if (sourceUrl.isNotEmpty) {
                        _launchURL(sourceUrl);
                        }},
                        child: Text(
                          'View Recipe',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                   ),
                );
            } ),
          )
        ],
             ),
    );
  }
}