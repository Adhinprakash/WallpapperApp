import 'dart:ui';

import 'package:flutter/material.dart';

class CustomScroll extends MaterialScrollBehavior{
    @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}