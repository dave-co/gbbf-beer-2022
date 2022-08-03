import 'package:flutter/material.dart';

class BeerMeta {
  bool showDetail;
  bool want = false;
  bool tried = false;
  bool favourite = false;

  BeerMeta(this.showDetail);

  BeerMeta.all(this.showDetail, this.want, this.tried, this.favourite);

  Map toJson() => {
    "showDetail" : showDetail,
    "want" : want,
    "tried" : tried,
    "favourite" : favourite
  };

  factory BeerMeta.fromJson(json) {
    return BeerMeta.all(
        json["showDetail"] as bool,
        json["want"] as bool,
        json["tried"] as bool,
        json["favourite"] as bool
    );
  }
}