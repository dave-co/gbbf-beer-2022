import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gbbf2022/beerMeta.dart';
import 'package:gbbf2022/savedState.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  // String searchText = '';

  bool nameSearch = true;
  bool notesSearch = false;
  bool brewerySearch = false;
  bool barSearch = true;
  bool styleSearch = false;
  bool countrySearch = false;

  bool showHandpull = true;
  bool showKeyKeg = true;
  bool showBottles = false;

  final int abvDivisions = 13;
  final double maxAbv = 13;
  RangeValues abvRange = const RangeValues(3.8, 12);

  bool onlyShowWants = false;
  bool onlyShowFavourites = false;
  bool onlyShowTried = false;

  var beerMetaData = [];

  void _search(){
    debugPrint("beer - _search on \"${searchTextController.text}\" searching fields: "
        "${nameSearch == true ? 'name ' : ''}${notesSearch == true ? 'notes ' : ''}${brewerySearch == true ? 'brewery ' : ''}"
        "${barSearch == true ? 'bar ' : ''}${styleSearch == true ? 'style ' : ''}${countrySearch == true ? 'country ' : ''} within abv range ${abvRange.start} to ${abvRange.end}" );

  }

  bool _showBeer(Beer beer) {
    // check abv first, if outside the range we don't care about the rest of the search options
    if(beer.abv < abvRange.start || (abvRange.end != maxAbv && beer.abv > abvRange.end)){
      return false;
    }
    // now check dispense method
    if(beer.dispenseMethod == "Handpull" && !showHandpull || beer.dispenseMethod == "KeyKeg" && !showKeyKeg || beer.dispenseMethod == "Bottle" && !showBottles){
      return false;
    }

    String text = searchTextController.text.toLowerCase();
    if(nameSearch    && beer.name.toLowerCase().contains(text)){return true;}
    if(notesSearch   && beer.notes.toLowerCase().contains(text)){return true;}
    if(brewerySearch && beer.brewery.toLowerCase().contains(text)){return true;}
    if(barSearch     && beer.barCode.toLowerCase().contains(text)){return true;}
    if(styleSearch   && beer.style.toLowerCase().contains(text)){return true;}
    if(countrySearch && beer.country.toLowerCase().contains(text)){return true;}

    if(!nameSearch && !notesSearch && !brewerySearch && !barSearch && !styleSearch && !countrySearch){
      return true;
    }
    return false;
  }

  String _getLabel(BeerMeta beerMeta){
    if (beerMeta.favourite == true) {
      return 'Fave';
    } else if (beerMeta.tried == true) {
      return 'Tried';
    } else if (beerMeta.want == true) {
      return 'Want';
    }
    return '';
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

  Future<void> executeAfterBuild() async {
    // this code will get executed after the build method
    // because of the way async functions are scheduled
    final prefs = await SharedPreferences.getInstance();
    debugPrint("executeAfterBuild $notesSearch");

    String json = jsonEncode(SavedState(
        showSearch,
        searchTextController.text,
        nameSearch,
        notesSearch,
        brewerySearch,
        barSearch,
        styleSearch,
        countrySearch,
        showHandpull,
        showKeyKeg,
        showBottles,
        abvRange.start,
        abvRange.end,
        onlyShowWants,
        onlyShowFavourites,
        onlyShowTried));
    debugPrint("json=$json");
    prefs.setString("state", json);
  }

  @override
  Widget build(BuildContext context) {
    executeAfterBuild();
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
            itemCount: beers.length,
              itemBuilder: (BuildContext context, int i) {
                return GestureDetector(
                  onTap: (){
                    setState(() {
                      beerMetaData[i].showDetail = !beerMetaData[i].showDetail;
                    });
                  },
                  child: Visibility(
                    visible: _showBeer(beers[i]),
                      child: Column(
                        children: [
                              const Divider(height: 10,),
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
                                    Expanded(
                                        flex: 2,
                                        child: Text('${beers[i].dispenseMethod}')
                                    ),
                                    // const Expanded(
                                    //     flex: 0,
                                    //     child: Text(' ')
                                    // ),
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
                                        flex: 1,
                                        child: Text('${beers[i].barCode}')
                                    ),
                                    Expanded(
                                        flex: 1,
                                        child: Text(_getLabel(beerMetaData[i]))
                                    ),
                                  ]),
                              Visibility(
                                  visible: beerMetaData[i].showDetail,
                                  child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(child: Text('${beers[i].notes}'))
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: CheckboxListTile(
                                                title: const Text('Want'),
                                                value: beerMetaData[i].want,
                                                onChanged: (bool? value){
                                                  setState((){
                                                    beerMetaData[i].want = !beerMetaData[i].want;
                                                  });
                                                },
                                              )
                                            ),
                                            Expanded(
                                                flex: 2,
                                                child: CheckboxListTile(
                                                  title: const Text('Tried'),
                                                  value: beerMetaData[i].tried,
                                                  onChanged: (bool? value){
                                                    setState((){
                                                      beerMetaData[i].tried = !beerMetaData[i].tried;
                                                      if(beerMetaData[i].tried == true && beerMetaData[i].want == true) {
                                                        beerMetaData[i].want = false;
                                                      }
                                                    });
                                                  },
                                                )
                                            ),
                                            Expanded(
                                                flex: 2,
                                                child: CheckboxListTile(
                                                  title: const Text('Favourite'),
                                                  contentPadding: const EdgeInsets.all(5),
                                                  value: beerMetaData[i].favourite,
                                                  onChanged: (bool? value){
                                                    setState((){
                                                      beerMetaData[i].favourite = !beerMetaData[i].favourite;
                                                    });
                                                  },
                                                )
                                            )
                                          ],
                                        )
                                ])
                              )
                            ]
                      )
                    )
                );
              }),
          Visibility(
              visible: showSearch,
              child: Container(
                color: Colors.white,
                height: 410, // TODO tweak this
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
                                // _search();
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
                                  // _search();
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
                                  // _search();
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
                                    // _search();
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
                                    // _search();
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
                                    // _search();
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
                            divisions: abvDivisions,
                            max: maxAbv,
                            onChanged: (RangeValues values) {
                              setState(() {
                                abvRange = values;
                                // _search();
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
                                title: const Text('Bottle'),
                                value: showBottles,
                                onChanged: (bool? value){
                                  setState((){
                                    showBottles = !showBottles;
                                    // _search();
                                  });
                                },
                              )
                          ),
                          Expanded(
                              flex: 2,
                              child: CheckboxListTile(
                                title: const Text('Keykeg'),
                                value: showKeyKeg,
                                onChanged: (bool? value){
                                  setState((){
                                    showKeyKeg = !showKeyKeg;
                                    // _search();
                                  });
                                },
                              )
                          ),
                          Expanded(
                              flex: 2,
                              child: CheckboxListTile(
                                title: const Text('Handpull'),
                                value: showHandpull,
                                contentPadding: const EdgeInsets.all(5),
                                onChanged: (bool? value){
                                  setState((){
                                    showHandpull = !showHandpull;
                                    // _search();
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
                                title: const Text('Want'),
                                value: onlyShowWants,
                                onChanged: (bool? value){
                                  setState((){
                                    onlyShowWants = !onlyShowWants;
                                    // _search();
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
                                    // _search();
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
                                    // _search();
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
      // searchTextController.addListener(_search);
      _loadStaticBeers();
      _createMetaData();
      _loadSavedState();
  }

  void _createMetaData() {
    final m = List.generate(allBeers.length, (index) {
      // TODO may need to change when loading saved metadata
      return BeerMeta(false);
    });
    beerMetaData = m;
    // setState(() {
    // });
  }

  void _loadStaticBeers() {
    debugPrint("allBeers.length=${allBeers.length}");
    final b = List.generate(allBeers.length, (index) {
      // debugPrint("allBeers[$index]=${allBeers[index]}");
      var beer = Beer.fromJson(jsonDecode(allBeers[index]));
      // debugPrint("beer.id=${beer.id}");
      return beer;
    });

    debugPrint("beers.length=${b.length}");

    beers = b;
    // setState(() {
    // });
  }

  Future _loadSavedState() async {
    // var test = '{"nameSearch":true,"searchText":"ipa","abvMin":3.8}';
    try {
      final prefs = await SharedPreferences.getInstance();
      String json = prefs.getString("state") ?? '';
      if (json.isNotEmpty) {
        SavedState savedState = SavedState.fromJson(jsonDecode(json));
        debugPrint("nameSearch=${savedState.nameSearch} searchText=${savedState
            .searchText} abvMin=${savedState.abvMin}");

        showSearch = savedState.showSearch;
        searchTextController.text = savedState.searchText;
        nameSearch = savedState.nameSearch;
        notesSearch = savedState.notesSearch;
        brewerySearch = savedState.brewerySearch;
        barSearch = savedState.barSearch;
        styleSearch = savedState.styleSearch;
        countrySearch = savedState.countrySearch;
        showHandpull = savedState.showHandpull;
        showKeyKeg = savedState.showKeyKeg;
        showBottles = savedState.showBottles;
        abvRange = RangeValues(savedState.abvMin, savedState.abvMax);
        onlyShowWants = savedState.onlyShowWants;
        onlyShowTried = savedState.onlyShowTried;
        onlyShowFavourites = savedState.onlyShowFavourites;
      }
    } catch(e){
      debugPrint('Failed to load saved state');
      debugPrint(e.toString());

      const snackBar = SnackBar(
        content: Text('Failed to load saved state'),
      );

      // Find the ScaffoldMessenger in the widget tree
      // and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
