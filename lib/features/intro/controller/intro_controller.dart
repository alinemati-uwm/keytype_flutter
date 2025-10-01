
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class IntroController extends GetxController {

  final currentPage = 0.obs;
  final pageController = PageController();

  void changePage(int value) {
    currentPage.value = value;
  }

}