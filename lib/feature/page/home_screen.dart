import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:news_app/core/data/datasource/remote_news_datasource.dart';
import 'package:news_app/core/data/repository/news_repository_impl.dart';
import 'package:news_app/core/domain/usecases/fetch_top_headlines_usecase.dart';
import 'package:news_app/feature/blocs/news_bloc.dart';
import 'package:news_app/feature/blocs/news_event.dart';
import 'package:news_app/feature/blocs/news_state.dart';
import 'package:news_app/feature/page/detail_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Center(
          child: Text(widget.title,
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Top Headlines',
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold),
                )),
            BlocProvider(
              create: (context) => NewsBloc(FetchTopHeadlinesUsecase(
                  NewsRepositoryImpl(NewsRemoteDataSource())))
                ..add(FetchNews()),
              child:
                  BlocBuilder<NewsBloc, NewsState>(builder: (context, state) {
                if (state is NewsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is NewsError) {
                  return Center(child: Text(state.errorMessage));
                } else if (state is NewsSuccess) {
                  var articles = [];
                  for (var article in state.newsArticles) {
                    if (article.urlToImage.toString() != 'null') {
                      articles.add(article);
                    }
                  }
                  return FlutterCarousel.builder(
                    options: FlutterCarouselOptions(
                      aspectRatio: 16 / 9,
                      height: 190.0,
                      showIndicator: false,
                    ),
                    itemCount: articles.length,
                    itemBuilder: (BuildContext context, int itemIndex,
                        int pageViewIndex) {
                      return Card.filled(
                          clipBehavior: Clip.hardEdge,
                          child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailScreen(
                                              news: articles[itemIndex],
                                            )));
                              },
                              child: Stack(
                                children: [
                                  Image.network(
                                    articles[itemIndex].urlToImage.toString(),
                                    fit: BoxFit.cover,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.black.withOpacity(0.7),
                                          Colors.transparent,
                                        ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text(
                                            articles[itemIndex]
                                                .title
                                                .toString(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 16.0,
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                fontWeight: FontWeight.bold),
                                          ))
                                    ],
                                  )
                                ],
                              )));
                    },
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  ListView newsList(NewsSuccess state, Axis scrollDirection) {
    return ListView.builder(
      scrollDirection: scrollDirection,
      padding: const EdgeInsets.all(16.0),
      itemCount: state.newsArticles.length,
      itemBuilder: (BuildContext context, int index) {
        return Card.filled(
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailScreen(
                            news: state.newsArticles[index],
                          )));
            },
            child: SizedBox(
              child: Column(
                children: [
                  Image(
                      image: NetworkImage(
                          state.newsArticles[index].urlToImage.toString()),
                      errorBuilder: (context, error, stackTrace) {
                        return const SizedBox.expand(
                          child: Icon(Icons.image),
                        );
                      }),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.newsArticles[index].source.name.toString(),
                          style: TextStyle(
                              fontSize: 14.0,
                              color: Theme.of(context).colorScheme.outline),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          state.newsArticles[index].title.toString(),
                          style: const TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
