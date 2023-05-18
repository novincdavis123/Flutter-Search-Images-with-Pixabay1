import 'package:flutter/material.dart';
import 'package:pixabay_search/search_module.dart';

import 'photo.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _controller = TextEditingController();
  final searchModule = SearchModule();

  @override
  void initState() {
    super.initState();
    _controller.text = "dessert";
    searchModule.search(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search Images with Pixabay',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Pixabay Images'),
        ),
        body: Column(
          children: <Widget>[
            TextField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              onSubmitted: (value) => searchModule.search(value),
              decoration: InputDecoration(
                hintText: "Enter a value",
                prefixIcon: IconButton(
                  onPressed: () => _controller.clear(),
                  icon: Icon(Icons.clear),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    searchModule.search(_controller.text);
                  },
                  icon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<AlbumPhoto>(
                  stream: searchModule.stream,
                  builder: (BuildContext context,
                      AsyncSnapshot<AlbumPhoto> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.photos.isEmpty)
                        return Center(child: Text('No results found'));

                      return GestureDetector(
                        onTap: () =>
                            FocusScope.of(context).requestFocus(FocusNode()),
                        child: GridView.count(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            crossAxisCount: 3,
                            children: snapshot.data.photos.map((Photo photo) {
                              return GridTile(
                                  child: Image.network(photo.url,
                                      fit: BoxFit.cover));
                            }).toList()),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text("${snapshot.error}"));
                    }

                    return Center(child: CircularProgressIndicator());
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
