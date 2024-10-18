import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:news_app/core/data/datasource/remote_news_datasource.dart';
import 'package:news_app/core/data/repository/news_repository_impl.dart';
import 'package:news_app/core/domain/usecases/fetch_all_news_usecase.dart';
import 'package:news_app/core/domain/usecases/fetch_top_headlines_usecase.dart';
import 'package:news_app/core/resource/notificiation_notifier.dart';
import 'package:news_app/core/resource/theme_notifier.dart';
import 'package:news_app/feature/blocs/news_bloc.dart';
import 'package:news_app/feature/blocs/news_event.dart';
import 'package:news_app/feature/blocs/news_state.dart';
import 'package:news_app/feature/page/detail_screen.dart';
import 'package:news_app/feature/page/settings_screen.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.theme});

  final String title;
  final ThemeNotifier theme;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _newsCategoryIndex = 0;
  String _newsCategoryValue = 'general';
  final List<String> _newsCategories = [
    'General',
    'Business',
    'Technology',
    'Sports',
    'Politic'
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificiationNotifier>(builder: (context, notif, _) {
      return Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              PopupMenuButton(itemBuilder: (BuildContext context) {
                return ['Settings']
                    .map((menuItem) => PopupMenuItem(
                          child: Text(menuItem),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SettingsScreen(theme: widget.theme, notif: notif,)));
                          },
                        ))
                    .toList();
              })
            ],
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: Text(widget.title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          body: MultiBlocProvider(providers: [
            BlocProvider(
                create: (context) => HeadlineNewsBloc(FetchTopHeadlinesUsecase(
                    NewsRepositoryImpl(NewsRemoteDataSource())))
                  ..add(FetchHeadlineNews())),
            BlocProvider(
                create: (context) => EverythingNewsBloc(FetchAllNewsUsecase(
                    NewsRepositoryImpl(NewsRemoteDataSource())))
                  ..add(FetchEverythingNews(_newsCategoryValue)))
          ], child: homePageBuilder(context)));
    });
  }

  SingleChildScrollView homePageBuilder(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          topHeadlineBuilder(),
          Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 12.0),
              child: Text(
                'Explore News',
                style: TextStyle(
                    fontSize: 20.0,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold),
              )),
          SingleChildScrollView(
            padding: const EdgeInsets.only(left: 16.0),
            scrollDirection: Axis.horizontal,
            child: BlocBuilder<EverythingNewsBloc, NewsState>(
                builder: (context, _) {
              return Row(
                children:
                    List<Widget>.generate(_newsCategories.length, (int index) {
                  return Container(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: ChoiceChip(
                      label: Text(_newsCategories[index]),
                      selected: _newsCategoryIndex == index,
                      onSelected: (bool selected) {
                        setState(() {
                          _newsCategoryIndex = index;
                          _newsCategoryValue = _newsCategories[index];
                        });
                        BlocProvider.of<EverythingNewsBloc>(context)
                            .add(FetchEverythingNews(_newsCategoryValue));
                      },
                    ),
                  );
                }),
              );
            }),
          ),
          exploreNewsBuilder()
        ],
      ),
    );
  }

  Widget topHeadlineBuilder() {
    return BlocBuilder<HeadlineNewsBloc, NewsState>(builder: (context, state) {
      if (state is HeadlineNewsLoading) {
        return const Center(
            child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(),
        ));
      } else if (state is HeadlineNewsError) {
        return const SizedBox.shrink();
      } else if (state is HeadlineNewsSuccess) {
        if (state.newsArticles.isEmpty) {
          return const SizedBox.shrink();
        } else {
          return topHeadlines(state);
        }
      } else {
        return const Center(child: Text('No news available'));
      }
    });
  }

  Widget exploreNewsBuilder() {
    return BlocBuilder<EverythingNewsBloc, NewsState>(
        builder: (context, state) {
      if (state is EverythingNewsLoading) {
        return const Center(
            child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(),
        ));
      } else if (state is EverythingNewsError) {
        return Center(child: Text(state.errorMessage.toString()));
      } else if (state is EverythingNewsSuccess) {
        return newsList(state);
      } else {
        return const Center(child: Text('No news available'));
      }
    });
  }

  Column topHeadlines(HeadlineNewsSuccess state) {
    return Column(
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
        FlutterCarousel.builder(
          options: FlutterCarouselOptions(
            aspectRatio: 16 / 9,
            height: 190.0,
            showIndicator: false,
          ),
          itemCount: state.newsArticles.length,
          itemBuilder:
              (BuildContext context, int itemIndex, int pageViewIndex) {
            return headlineCard(context, state, itemIndex);
          },
        ),
      ],
    );
  }

  Card headlineCard(
      BuildContext context, HeadlineNewsSuccess state, int itemIndex) {
    return Card.filled(
        clipBehavior: Clip.hardEdge,
        child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailScreen(
                            news: state.newsArticles[itemIndex],
                          )));
            },
            child: Stack(
              children: [
                Image.network(
                  state.newsArticles[itemIndex].urlToImage.toString(),
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
                          state.newsArticles[itemIndex].title.toString(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 16.0,
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontWeight: FontWeight.bold),
                        ))
                  ],
                )
              ],
            )));
  }

  Widget newsList(EverythingNewsSuccess state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: List<Widget>.generate(state.newsArticles.length, (int index) {
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
        }),
      ),
    );
  }
}
