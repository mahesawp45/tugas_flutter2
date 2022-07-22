import 'package:book_app/controllers/book_controller.dart';
import 'package:book_app/views/detail_book_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookListPage extends StatefulWidget {
  const BookListPage({Key? key}) : super(key: key);

  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  BookController? bookController;

  @override
  void initState() {
    super.initState();
    bookController = Provider.of<BookController>(context, listen: false);
    bookController!.fecthBookAPI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Catalogue'),
      ),
      body: Consumer<BookController>(
        // dirender 1x ntr" ga dirender lagi
        child: const Center(
          child: CircularProgressIndicator(),
        ),
        builder: (context, bookController, child) => Container(
          child: bookController.bookList == null
              ? child
              : ListView.builder(
                  itemCount: bookController.bookList!.books!.length,
                  itemBuilder: (context, index) {
                    final book = bookController.bookList!.books![index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return DetailBookPage(
                                isbn13: book.isbn13,
                              );
                            },
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Image.network(book.image ?? '',
                              height: 100, width: 100),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(book.title ?? '',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
                                  Text(book.subtitle ?? '',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(book.price ?? '0'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
