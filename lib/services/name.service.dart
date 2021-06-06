import 'package:english_words/english_words.dart';
import 'package:myapp/models/name.model.dart';

class NameService {
  final _suggestions = <NameModel>[];
  final _saved = <NameModel>{};

  NameService._privateConstructor();
  static final NameService _instance = NameService._privateConstructor();
  static NameService get instance => _instance;

  NameModel getName(int i) {
    var index = i ~/ 2;
    // If they are requesting more names than we currently have, generate more
    if(index >= _suggestions.length) {
      var newWordPairs = generateWordPairs().take(10);

      newWordPairs.forEach((element) {
        _suggestions.add(new NameModel(element.asPascalCase, false));
      });
    }
    return _suggestions[index];
  }

  void saveName(NameModel name) {
    _saved.add(name);
  }

  void unsaveName(NameModel name) {
    _saved.remove(name);
  }

  Set<NameModel> getAllSaved() {
    return _saved;
  }
}