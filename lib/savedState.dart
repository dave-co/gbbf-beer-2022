import 'package:flutter/material.dart';

import 'beerMeta.dart';

class SavedState{
  bool nameSearch;
  String searchText;
  double abvMin;

  SavedState(this.nameSearch, this.searchText, this.abvMin);

  Map toJson() => {
    "nameSearch" : nameSearch,
    "searchText" : searchText,
    "abvMin" : abvMin
  };
  factory SavedState.fromJson(dynamic json) {
    return SavedState(json['nameSearch'] as bool, json['searchText'] as String, json['abvMin'] as double);
  }
}