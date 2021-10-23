// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

pokeData dataFromJson(String str) => pokeData.fromJson(json.decode(str));

String dataToJson(pokeData data) => json.encode(data.toJson());

class pokeData {
  pokeData({
    required this.count,
    required  this.next,
    required  this.previous,
    required  this.results,
  });

  int count;
  String next;
  dynamic previous;
  List<Result> results;

  factory pokeData.fromJson(Map<String, dynamic> json) => pokeData(
    count: json["count"],
    next: json["next"],
    previous: json["previous"],
    results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "next": next,
    "previous": previous,
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
  };
}

class Result {
  Result({
    required  this.name,
    required  this.url,
  });

  String name;
  String url;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    name: json["name"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "url": url,
  };
}
