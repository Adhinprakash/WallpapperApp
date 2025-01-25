import 'dart:convert';
import 'dart:io';

import 'package:dummyproject/app/const/repository.dart';
import 'package:dummyproject/model/image_model.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';


import 'package:http/http.dart'as http;


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


// Future<void>downloadImage({required String imageurl,required int imageId,required BuildContext context})async{
// //    try {
// //       final response = await http.get(Uri.parse(imageurl));

// //       if (response.statusCode >= 200 && response.statusCode <= 299) {
// //        // Attempt to download the image using image_downloader
// //     var imageId = await ImageDownloader.downloadImage(imageurl);

// //     if (imageId == null) {
// //       // Show an error message if download fails
// //       if (context.mounted) {
// //         ScaffoldMessenger.of(context).clearSnackBars();
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(
// //             backgroundColor: Colors.red,
// //             content: Text("Failed to download image."),
// //             duration: Duration(seconds: 2),
// //           ),
// //         );
// //       }
// //       return;
// //     }

// //     // Find the file path of the downloaded image (optional)
// //     var filePath = await ImageDownloader.findPath(imageId);

// //         if (context.mounted) {
// //           ScaffoldMessenger.of(context).clearSnackBars();

// //           ScaffoldMessenger.of(context).showSnackBar(
// //             SnackBar(
// //               backgroundColor: Colors.green,
// //               content: Text("File's been saved at: ${filePath}"),
// //               duration: const Duration(seconds: 2),
// //             ),
// //           );
// //         }
// //       }
// //     } catch (error) {
// // // Handle any errors during the download process
// //     if (context.mounted) {
// //       ScaffoldMessenger.of(context).clearSnackBars();
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           backgroundColor: Colors.red,
// //           content: Text("Error downloading image: $error"),
// //           duration: const Duration(seconds: 2),
// //         ),
// //       );
// //     }
// // }

// }
// Future<void> downloadImage({
//   required String imageurl,
//   required int imageId,
//   required BuildContext context,
// }) async {
//   try {
//       ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text("Downloading Started...")));
//     final response = await http.get(Uri.parse(imageurl));

//     if (response.statusCode >= 200 && response.statusCode <= 299) {
//       var imageId = await ImageDownloader.downloadImage(imageurl);
//       if (imageId == null) {
//         return;
//       }
//       // Below is a method of obtaining saved image information.
//       var fileName = await ImageDownloader.findName(imageId);
//       var path = await ImageDownloader.findPath(imageId);
//       var size = await ImageDownloader.findByteSize(imageId);
//       var mimeType = await ImageDownloader.findMimeType(imageId);
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text("Downloaded Sucessfully"),
//         action: SnackBarAction(
//             label: "Open",
//             onPressed: () {
//               OpenFile.open(path);
//             }),
//       ));
//       print("IMAGE DOWNLOADED");
        
//     } else {
      
//     }
//   } on PlatformException catch (error) {
//       print(error);
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Error Occured - $error")));
//     }
// }


  // Future<void> downloadImage(
  //     {required String imageUrl,
  //     required int imageId,
  //     required BuildContext context}) async {
  //   try {
  //     final response = await http.get(Uri.parse(imageUrl));

  //     if (response.statusCode >= 200 && response.statusCode <= 299) {
  //       final bytes = response.bodyBytes;
  //       final directory = await ExternalPath.getExternalStoragePublicDirectory(
  //           ExternalPath.DIRECTORY_DOWNLOADS);

  //       final file = File("$directory/$imageId.png");
  //       await file.writeAsBytes(bytes);

  //       MediaScanner.loadMedia(path: file.path);

  //       if (context.mounted) {
  //         ScaffoldMessenger.of(context).clearSnackBars();

  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             backgroundColor: Colors.green,
  //             content: Text("File's been saved at: ${file.path}"),
  //             duration: const Duration(seconds: 2),
  //           ),
  //         );
  //       }
  //     }
  //   } catch (_) {}
  // }
}
