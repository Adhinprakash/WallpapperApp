import 'dart:convert';
import 'dart:io';

import 'package:dummyproject/app/const/repository.dart';
import 'package:dummyproject/model/image_model.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';


import 'package:http/http.dart'as http;
import 'package:path_provider/path_provider.dart';


class ApiServices {

final Repository repository=Repository();
Future<List<Images>>getImagesList({required int? pageNumber})async{
String url='';
if(pageNumber==null){
  url='${repository.baseUrl}curated?per_page=80';
}else{
  url='${repository.baseUrl}curated?per_page=80&page=$pageNumber';
}

List<Images>imageList=[];

print(repository.apikey);
print(url);
try {
  final response=await http.get(Uri.parse(url),headers: {
    "Authorization":repository.apikey
  });
  if(response.statusCode>=200&&response.statusCode<=299){
final jsonData=json.decode(response.body);

  for(final json in jsonData['photos'] as Iterable){
final image=Images.fromJson(json);
imageList.add(image);
  }

  }
} catch (_) {}
  
return imageList;


}

Future<Images>getImagebyId({required int id})async{
  final url="${repository.baseUrl}photos/$id";

  Images image=Images.emptyConstructor();

  try {
    final response=await http.get(Uri.parse(url),headers: {
       "Authorization":repository.apikey
    });

    if(response.statusCode>=200&&response.statusCode<=299){
final jsonData=json.decode(response.body);

  image=Images.fromJson(jsonData);

  }
  } catch (_) {
    
  }
  return image;
}


Future<List<Images>>getImagebySerarch({required String query})async{
  String url="${repository.baseUrl}search?query=$query&per_page=10";


List<Images>imageList=[];
try {
  final response=await http.get(Uri.parse(url),headers: {
    "Authorization":repository.apikey
  });
  if(response.statusCode>=200&&response.statusCode<=299){
final jsonData=json.decode(response.body);

  for(final json in jsonData['photos'] as Iterable){
final image=Images.fromJson(json);
imageList.add(image);
  }

  }
} catch (_) {}
  
return imageList;

}


Future<void> downloadImage({
  required String imageUrl,
  required int imageId,
  required BuildContext context,
}) async {
  try {
    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      final bytes = response.bodyBytes;

      final directory = await getApplicationDocumentsDirectory();

      final file = File("${directory.path}/$imageId.png");

      await file.writeAsBytes(bytes);

      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text("File's been saved at: ${file.path}"),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else {
      throw Exception("Failed to download image.");
    }
  } catch (e) {
    // Handle errors gracefully
    if (context.mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Failed to save the image: $e"),
          duration: const Duration(seconds: 2),
        ),
      );
}
}
}}