import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  const ImageView({
    Key? key,
    this.imageUrl,
  }) : super(key: key);

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    var bodyHeight = MediaQuery.of(context).size.height;
    var bodyWidth = MediaQuery.of(context).size.width;

    var padTop = MediaQuery.of(context).padding.top;
    var appHeight = bodyHeight + padTop;
    double containerImage = 300;

    return Scaffold(
      body: SizedBox(
        height: appHeight,
        width: bodyWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  color: Colors.black,
                  height: containerImage,
                  width: bodyWidth,
                  child: Image.network(
                    imageUrl == null ? '' : imageUrl!,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  color: Colors.black.withOpacity(0.5),
                  height: containerImage,
                  width: bodyWidth,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: padTop),
                  child: SizedBox(
                    width: bodyWidth,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const CircleAvatar(
                                child: Icon(Icons.arrow_back),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          const Expanded(
                            flex: 3,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
