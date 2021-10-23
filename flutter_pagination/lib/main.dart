import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int currentPage = 0;
  late int totalPages;
  List<dynamic> pokemanData = [];
  List<dynamic> names = [];
  List<dynamic> urls = [];
  final RefreshController refreshController =
      RefreshController(initialRefresh: true);

  // function to get all data
  Future<bool> getData({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage = 0;
    } else {
      // end of the page
      if (currentPage >= totalPages) {
        refreshController.loadNoData();
        return false;
      }
    }
    var _dio = Dio();
    await _dio
        .get('https://pokeapi.co/api/v2/pokemon?offset=$currentPage&limit=20')
        .then((response) {
      List results = response.data['results'];
      if (isRefresh) {
        pokemanData = results;
      } else {
        pokemanData.addAll(response.data['results']);
      }
      // increase the count of the page once pulled up
      currentPage = currentPage + 20;
      totalPages = response.data['count'];
      print(pokemanData);
      List<String> name = pokemanData.map((e) => e["name"].toString()).toList();
      List<String> url = pokemanData.map((e) => e["url"].toString()).toList();
      print(names);
      setState(() {
        names = name;
        urls = url;
      });
    }).catchError((e) {});
    print('error');
    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Infinite scroll pagination'),
      ),
      body: SmartRefresher(
        controller: refreshController,
        enablePullUp: true,
        onRefresh: () async {
          final result = await getData(isRefresh: true);
          if (result) {
            refreshController.refreshCompleted();
          } else {
            refreshController.refreshFailed();
          }
        },
        onLoading: () async {
          final result = await getData();
          if (result) {
            refreshController.loadComplete();
          } else {
            refreshController.loadFailed();
          }
        },
        child: ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                'Name - ' + names[index],
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                urls[index],
                style: TextStyle(color: Colors.blue),
              ),
            );
          },
          separatorBuilder: (context, index) => Divider(),
          itemCount: pokemanData.length,
        ),
      ),
    );
  }
}
