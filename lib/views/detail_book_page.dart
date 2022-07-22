import 'package:book_app/controllers/book_controller.dart';
import 'package:book_app/views/subViews/image_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailBookPage extends StatefulWidget {
  const DetailBookPage({
    Key? key,
    required this.isbn13,
  }) : super(key: key);

  final String? isbn13;

  @override
  State<DetailBookPage> createState() => _DetailBookPageState();
}

class _DetailBookPageState extends State<DetailBookPage> {
  BookController? bookController;

  @override
  void initState() {
    super.initState();
    bookController = Provider.of<BookController>(context, listen: false);
    bookController!.fecthDetailBookAPI(widget.isbn13!);
  }

  @override
  Widget build(BuildContext context) {
    Uri urlBook = Uri.parse(bookController!.bookDetail!.url == null
        ? ''
        : bookController!.bookDetail!.url!);

    return Scaffold(
      appBar: AppBar(
        title: Consumer<BookController>(
          builder: (BuildContext context, book, Widget? child) => Text(
              book.bookDetail!.title == null ? '' : book.bookDetail!.title!),
        ),
      ),
      body: Consumer<BookController>(builder: (context, bookController, child) {
        return bookController.bookDetail == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImageView(
                                  imageUrl: bookController.bookDetail!.image!,
                                ),
                              ),
                            );
                          },
                          child: Image.network(
                            bookController.bookDetail!.image!,
                            height: 150,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bookController.bookDetail!.title!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                bookController.bookDetail!.authors!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: List.generate(
                                  5,
                                  (index) => Icon(
                                    Icons.star,
                                    color: index <
                                            int.parse(bookController
                                                .bookDetail!.rating!)
                                        ? Colors.yellow
                                        : Colors.grey,
                                  ),
                                ).toList(),
                              ),
                              Text(
                                bookController.bookDetail!.subtitle!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                bookController.bookDetail!.price!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            // Pake URL Launcher harus use permision internet sama query di Androidmanifest
                            await launchUrl(urlBook);
                          } catch (e) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Sorry Error :('),
                                    content: Text(e.toString()),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Close'),
                                      ),
                                    ],
                                  );
                                });
                          }
                        },
                        child: const Text('BUY'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(bookController.bookDetail!.desc!),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("Year : ${bookController.bookDetail!.year!}"),
                        Text("ISBN ${bookController.bookDetail!.isbn13!}"),
                        Text("${bookController.bookDetail!.pages!} Pages"),
                        Text(
                            "Publisher : ${bookController.bookDetail!.publisher!}"),
                        Text(
                            "Language : ${bookController.bookDetail!.language!}"),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Similar'),
                        TextButton(
                          onPressed: () {},
                          child: const Text('More'),
                        ),
                      ],
                    ),
                    bookController.similarBook == null
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            height: 180,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  bookController.similarBook!.books!.length,
                              itemBuilder: (context, index) {
                                var current =
                                    bookController.similarBook!.books![index];

                                return SizedBox(
                                  width: 115,
                                  child: Column(
                                    children: [
                                      Image.network(
                                        current.image!,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      ),
                                      Text(
                                        current.title!,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                  ],
                ),
              );
      }),
    );
  }
}
