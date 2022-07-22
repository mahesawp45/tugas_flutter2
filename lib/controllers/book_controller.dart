import 'dart:convert';

import 'package:book_app/models/book_detail_response.dart';
import 'package:book_app/models/book_list_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BookController extends ChangeNotifier {
  BookList? bookList;
  BookDetail? bookDetail;
  BookList? similarBook;

  Future<void> fecthBookAPI() async {
    var url = Uri.parse('https://api.itbook.store/1.0/new');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var responseJson = jsonDecode(response.body);

      // masukkin ke model booklist
      bookList = BookList.fromJson(responseJson);

      notifyListeners();
    }
  }

  Future<void> fecthDetailBookAPI(String isbn13) async {
    var url = Uri.parse('https://api.itbook.store/1.0/books/$isbn13');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      bookDetail = BookDetail.fromJson(responseJson);

      // panggil Similar book barengan sama fetch ini biar sklian dpt data title
      fecthSimilarBookAPI(bookDetail!.title!);

      notifyListeners();
    }
  }

  Future<void> fecthSimilarBookAPI(String title) async {
    var url = Uri.parse('https://api.itbook.store/1.0/search/$title');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      similarBook = BookList.fromJson(responseJson);

      notifyListeners();
    }
  }
}
