import 'package:award_task/news/utils/ClipperShape.dart';
import 'package:award_task/news/utils/NewsBox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:award_task/news/classes/newsrepo.dart';
import 'classes/NewsClass.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late Future<List<News>> newsListFuture;
  final NewsRepo newsRepo = NewsRepo();
  final TextEditingController _searchController = TextEditingController();
  List<News> filteredNewsList = [];
  List<News> fullNewsList = [];

  @override
  void initState() {
    super.initState();

    newsListFuture = newsRepo.getNews().then((newsList) {
      setState(() {
        fullNewsList = newsList;
        filteredNewsList = newsList;
      });
      return newsList;
    });
  }

  void _filterNews(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredNewsList = fullNewsList;
      } else {
        filteredNewsList = fullNewsList
            .where((news) => news.news.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Top bar
          Stack(
            children: [
              ClipPath(
                clipper: HexagonalBottomClipper(),
                child: Container(
                  width: double.infinity,
                  height: 125,
                  color: const Color(0xFF050D10),
                  child: CustomPaint(
                    painter: HexagonalBorderPainter(),
                    child: Stack(
                      children: [
                        AppBar(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          centerTitle: true,
                          title: Padding(
                            padding: const EdgeInsets.only(top: 38.0),
                            child: SizedBox(
                              width: 190,
                              height: 27,
                              child: Text(
                                'NOTIFICATIONS',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontFamily: 'Jost',
                                  letterSpacing: 0.70,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 81,
                width: 400,
                left: 0,
                child: SvgPicture.asset('assets/redBorder.svg'),
              ),
            ],
          ),

          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 11),
            child: SizedBox(
              height: 45,
              child: SearchBar(
                controller: _searchController,
                onChanged: _filterNews,
                hintText: 'Search for Updates',
                hintStyle: WidgetStateProperty.all(
                  GoogleFonts.jost(
                    color: Color(0x8FDFDFDF),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                backgroundColor: WidgetStateProperty.all(Colors.black),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                    side: BorderSide(color: Color(0xFFF0F0F0), width: 0.1),
                  ),
                ),
                textStyle: WidgetStateProperty.all(TextStyle(color: Colors.white)),
              ),
            ),
          ),
          SizedBox(height: 8),

          // Scrollable News List with FutureBuilder
          Expanded(
            child: FutureBuilder<List<News>>(
              future: newsListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}", style: TextStyle(color: Colors.white)));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No news available.", style: TextStyle(color: Colors.white)));
                }

                final newsList = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 11),
                  itemCount: newsList.length,
                  itemBuilder: (context, index) {
                    final newsItem = newsList[index];
                    return Column(
                      children: [
                        NewsBox(news: newsItem), // Use dynamically fetched news
                        SizedBox(height: 3),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
