import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pixabay_search/photo.dart';

class SearchModule {

  static const API_KEY = "api-key"; // TODO: change
  final _controller = StreamController<AlbumPhoto>.broadcast();

  // Input stream. We add our notes to the stream using this variable.
  StreamSink<AlbumPhoto> get _sink => _controller.sink;

  // Output stream. This one will be used within our pages to display the notes.
  Stream<AlbumPhoto> get stream => _controller.stream;

  Future<AlbumPhoto> fetchAlbumPhoto(String query, [String lang = "en" ]) async {

    var url = Uri.encodeFull('https://pixabay.com/api/?key=$API_KEY&q=$query&image_type=photo&pretty=true&per_page=40&lang=$lang');
    final response =
        await http.get(url);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return AlbumPhoto.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  void search(String query) async {
    AlbumPhoto album = await fetchAlbumPhoto(query);
    _sink.add(album);
  }
}