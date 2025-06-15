import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiServices {
   final String apikey="9a43eec0bd51427eaa672550eccfbb67";
  Future<dynamic>getapiwithoutmodel(String ingredient)async{
    try{
      //var url=Uri.parse("http://www.recipepuppy.com/api/?i=${ingredient}&key=${apikey}");
      var url=Uri.parse("https://api.spoonacular.com/recipes/complexSearch?query=$ingredient&number=5&addRecipeInformation=true&addNutrition=true&apiKey=$apikey");
      var response=await http.get(url);
      if(response.statusCode==200){
        final data=jsonDecode(response.body);
        return data;
      }
      
    }catch(e){
      print(e.toString());
    }
    return null;
  }
}