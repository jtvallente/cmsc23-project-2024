import 'package:flutter/material.dart';

class SwitchController extends ChangeNotifier {
  bool _isSwitchOn = false;
  bool get isSwitchOn => _isSwitchOn;

  void setValue(bool value) {
    _isSwitchOn = value;
    notifyListeners();
  }
}

class RadioButtonController extends ChangeNotifier {
  final Map<String, bool> options;
  RadioButtonController({required this.options});

  late String _selectedOption = options.keys.elementAt(0);
  String get selectedOption => _selectedOption;

  void setValue(String value) {
    _selectedOption = value;
    notifyListeners();
  }
}

class SliderController extends ChangeNotifier {
  double _sliderValue = 0;
  double get sliderValue => _sliderValue;

  void setValue(double value) {
    _sliderValue = value;
    notifyListeners();
  }
}

class DropdownController extends ChangeNotifier{
  final List<String> options;
  DropdownController({required this.options});

  late String _selectedOption = options.elementAt(0);
  String get selectedOption => _selectedOption;

  void setValue(String value){
    _selectedOption = value;
    notifyListeners();
  }
}