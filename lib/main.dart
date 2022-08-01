import 'dart:convert';

import 'package:flutter/material.dart';
import 'beerlist.dart';
import 'beer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  var beers = [];
  bool showSearch = false;
  final searchTextController = TextEditingController();
  String searchText = '';

  bool nameSearch = true;
  bool notesSearch = false;
  bool brewerySearch = false;
  bool barSearch = true;
  bool styleSearch = false;
  bool countrySearch = false;

  RangeValues abvRange = const RangeValues(3.8, 12);

  bool onlyShowWants = false;
  bool onlyShowFavourites = false;
  bool onlyShowTried = false;

  void _search(){
    debugPrint("beer - _search on \"${searchTextController.text}\" searching fields: "
        "${nameSearch == true ? 'name ' : ''}${notesSearch == true ? 'notes ' : ''}${brewerySearch == true ? 'brewery ' : ''}"
        "${barSearch == true ? 'bar ' : ''}${styleSearch == true ? 'style ' : ''}${countrySearch == true ? 'country ' : ''} within abv range ${abvRange.start} to ${abvRange.end}" );

  }

  void _incrementCounter() {
    debugPrint("beer - _incrementCounter");
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gbbf Beers 2022'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child : GestureDetector(
              onTap: (){
                setState(() {
                  showSearch = !showSearch;
                });
                debugPrint("tap");
              },
              child: const Icon(
                  Icons.search,
                  size: 26
              )
            )
          )
        ],
      ),
      body: Stack(
        children: [
          ListView.builder(
              itemBuilder: (BuildContext context, int i) {
                return Column(children: [const Divider(height: 10,),
                  Row(
                      children: [
                        Expanded(
                            flex: 4,
                            child: Text('${beers[i].name}')
                        ),
                        Expanded(
                            flex: 2,
                            child: Text('${beers[i].abv}%')
                        ),
                        const Expanded(
                            flex: 2,
                            child: Text(' ')
                        )

                      ]),
                  Row(
                      children: [
                        Expanded(
                            flex: 4,
                            child: Text('  ${beers[i].brewery}')
                        ),
                        Expanded(
                            flex: 2,
                            child: Text('${beers[i].style}')
                        ),
                        Expanded(
                            flex: 2,
                            child: Text('${beers[i].barCode}')
                        )
                      ])
                ]);
              }),
          Visibility(
              visible: showSearch,
              child: Container(
                color: Colors.white,
                height: 310, // TODO tweak this
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: TextField(
                              controller: searchTextController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Search...'
                              ),
                            )
                        )
                      ],
                    ),
                    Row(
                      children :[
                        Expanded(
                          flex: 2,
                          child: CheckboxListTile(
                            title: const Text('Name'),
                            value: nameSearch,
                            onChanged: (bool? value){
                              setState((){
                                nameSearch = !nameSearch;
                                _search();
                              });
                            },
                          )
                        ),
                        Expanded(
                            flex: 2,
                            child: CheckboxListTile(
                              title: const Text('Notes'),
                              value: notesSearch,
                              onChanged: (bool? value){
                                setState((){
                                  notesSearch = !notesSearch;
                                  _search();
                                });
                              },
                            )
                        ),
                        Expanded(
                            flex: 2,
                            child: CheckboxListTile(
                              title: const Text('Brewery'),
                              value: brewerySearch,
                              contentPadding: const EdgeInsets.all(5),
                              onChanged: (bool? value){
                                setState((){
                                  brewerySearch = !brewerySearch;
                                  _search();
                                });
                              },
                            )
                        )
                      ]
                    ),
                    Row(
                        children :[
                          Expanded(
                              flex: 2,
                              child: CheckboxListTile(
                                title: const Text('Bar'),
                                value: barSearch,
                                onChanged: (bool? value){
                                  setState((){
                                    barSearch = !barSearch;
                                    _search();
                                  });
                                },
                              )
                          ),
                          Expanded(
                              flex: 2,
                              child: CheckboxListTile(
                                title: const Text('Style'),
                                value: styleSearch,
                                onChanged: (bool? value){
                                  setState((){
                                    styleSearch = !styleSearch;
                                    _search();
                                  });
                                },
                              )
                          ),
                          Expanded(
                              flex: 2,
                              child: CheckboxListTile(
                                title: const Text('Country'),
                                value: countrySearch,
                                contentPadding: const EdgeInsets.all(5),
                                onChanged: (bool? value){
                                  setState((){
                                    countrySearch = !countrySearch;
                                    _search();
                                  });
                                },
                              )
                          )
                        ]
                    ),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 17),
                          child: Text('ABV', textScaleFactor: 1.1),
                        ),
                        RangeSlider(
                            values: abvRange,
                            max: 20, //TODO tweak based on max abv in list

                            onChanged: (RangeValues values) {
                              setState(() {
                                abvRange = values;
                                _search();
                              });
                            }
                        )
                      ],
                    ),
                    Row(
                        children :[
                          Expanded(
                              flex: 2,
                              child: CheckboxListTile(
                                title: const Text('Want'),
                                value: onlyShowWants,
                                onChanged: (bool? value){
                                  setState((){
                                    onlyShowWants = !onlyShowWants;
                                    _search();
                                  });
                                },
                              )
                          ),
                          Expanded(
                              flex: 2,
                              child: CheckboxListTile(
                                title: const Text('Tried'),
                                value: onlyShowTried,
                                onChanged: (bool? value){
                                  setState((){
                                    onlyShowTried = !onlyShowTried;
                                    _search();
                                  });
                                },
                              )
                          ),
                          Expanded(
                              flex: 2,
                              child: CheckboxListTile(
                                title: const Text('Favourite'),
                                value: onlyShowFavourites,
                                contentPadding: const EdgeInsets.all(5),
                                onChanged: (bool? value){
                                  setState((){
                                    onlyShowFavourites = !onlyShowFavourites;
                                    _search();
                                  });
                                },
                              )
                          )
                        ]
                    ),
                  ],
                )
              )
          ),
        ],
      )
    );
  }

  @override
  void initState() {
      super.initState();
      searchTextController.addListener(_search);
      loadBeers();
  }

  void loadBeers() {
    debugPrint("allBeers.length=${allBeers.length}");
    final b = List.generate(allBeers.length, (index) {
      // debugPrint("allBeers[$index]=${allBeers[index]}");
      var beer = Beer.fromJson(jsonDecode(allBeers[index]));
      // debugPrint("beer.id=${beer.id}");
      return beer;
    });

    // for(var i = 0; i < allBeers.length; i++){
    // }
    debugPrint("beers.length=${b.length}");

    setState(() {
      beers = b;
    });
  }
}
