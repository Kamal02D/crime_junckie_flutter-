import 'dart:convert';

import 'package:poducts/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev show log;
class HttpService {
  static HttpService? _singltonService;

  HttpService._();

  factory HttpService.create(){
    _singltonService ??= HttpService._();
    return _singltonService!;
  }

  Future<String?> fetchData() async{
    final Uri uri = Uri.parse(Constants.URL);
    try {
     final response = await http.get(uri);
     if(response.statusCode == 200) {
       return utf8.decode(response.bodyBytes);
     }else{
       dev.log("error and response code was ${response.statusCode}");
     }
    }catch(e){
      dev.log("error was thrown : ${e.toString()}");
    }
    return  null;
  }
}
