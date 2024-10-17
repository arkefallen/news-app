import 'package:flutter/material.dart';
import 'package:news_app/core/domain/entity/news_entity.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatelessWidget {
  final NewsEntity news;

  const DetailScreen({super.key, required this.news});

  Future<void> _readNewsInBrowser(Uri imageUrl) async {
    if (await canLaunchUrl(imageUrl)) {
      if (!await launchUrl(imageUrl, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $imageUrl');
      }
    } else {
      throw Exception('URL cannot be launched');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image(
                  image: NetworkImage(news.urlToImage.toString()),
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox.shrink();
                  },
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 12.0, 0, 0),
                  child: IconButton.filled(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
              child: Text(
                news.source.name.toString(),
                style: TextStyle(
                    fontSize: 16.0,
                    color: Theme.of(context).colorScheme.outline),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                news.title.toString(),
                style: const TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 12.0),
            if (news.author.toString() != 'null')
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    const Icon(Icons.edit),
                    const SizedBox(width: 4.0),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Text(
                        news.author.toString(),
                        style: const TextStyle(fontSize: 16.0),
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ),
            const SizedBox(height: 16.0),
            if (news.description.toString() != 'null')
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  news.description.toString(),
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
            const SizedBox(height: 12.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: FilledButton(
                onPressed: () {
                  Uri parsedUrl = Uri.parse(news.url.toString());
                  _readNewsInBrowser(parsedUrl);
                },
                style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(40)),
                child: const Text('Read News'),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
