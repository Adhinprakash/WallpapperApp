import 'package:dummyproject/model/user_model.dart';
import 'package:dummyproject/services/api_services.dart';
import 'package:flutter/material.dart';

// class GetImageListcontroller extends ChangeNotifier {
//   final ApiServices apiServices=ApiServices();
// String? _errormessage;
// bool _isloading=false;

// String? get errormessage  =>_errormessage;
// bool get isloading=>_isloading;

// Future<void>loadUsers()async{

// _isloading=true;
// _errormessage=null;
// notifyListeners();
// try{

// }
// catch(e){
// _errormessage=e.toString();
// }
// finally{
//   _isloading=false;
//   notifyListeners();
// }

// }import 'package:flutter/material.dart';
import 'package:dummyproject/services/api_services.dart';
import 'package:dummyproject/model/image_model.dart';

class GetImagesController extends ChangeNotifier {
  final ApiServices _apiServices = ApiServices();
  List<Images> _images = [];
  bool _isLoading = false;
  int _pageNumber = 1;
   String selectedCategory = "";
  String? _errormessage;

  List<Images> get images => _images;
  bool get isLoading => _isLoading;
String? get errormessage  =>_errormessage;

  Future<void> fetchImages({bool loadMore = false}) async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final newImages = await _apiServices.getImagesList(pageNumber: _pageNumber);
      if (loadMore) {
        _images.addAll(newImages);
      } else {
        _images = newImages;
      }
      _pageNumber++;
    } catch (e) {
      _errormessage=e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _images = [];
    _pageNumber = 1;
    notifyListeners();
  }

   Future<void> fetchImagesByCategory(String category) async {
    if (isLoading) return;

    _isLoading = true;
    selectedCategory = category;
    notifyListeners();

    try {
      _images = await _apiServices.getImagebySerarch(query: category);
    } catch (error) {
    }

    _isLoading = false;
    notifyListeners();
  }
}
