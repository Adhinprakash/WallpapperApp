import 'package:dummyproject/controller/get_images_controller.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers=[
  ...independentprovider,
];

List<SingleChildWidget>independentprovider=[
  ChangeNotifierProvider(create: (context)=>GetImagesController()),
];