import 'package:award_task/news/classes/NewsClass.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class NewsBox extends StatelessWidget {
  final News news;

  const NewsBox({super.key, required this.news});

  /// Checks if an image URL is provided and valid.
  bool _hasImage() {
    return news.imageUrl != null && news.imageUrl!.isNotEmpty;
  }

  String timeAgo(String postedTimeString) {
    DateTime postedTime = DateTime.parse(postedTimeString);
    DateTime now = DateTime.now();
    Duration difference = now.difference(postedTime);

    if (difference.inMinutes < 60) {
      return "${difference.inMinutes}M AGO";
    } else if (difference.inHours < 24) {
      return "${difference.inHours}H AGO";
    } else {
      return "${difference.inDays}D AGO";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [Color(0x9F0F0F0F), Color(0xFFE2E2E2).withAlpha(1)],
                radius: 6,
              ),
              borderRadius: BorderRadius.zero,
              border: Border.all(color: Color(0xFFE2E2E2), width: 0.3),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                expansionTileTheme: ExpansionTileThemeData(
                  iconColor: Colors.white,
                ),
              ),
              child: ExpansionTile(
                tilePadding: EdgeInsets.only(left: 15,right: 15,bottom: 15,top: 5),
                expansionAnimationStyle: AnimationStyle(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                ),
                title: Text(
                  news.news,
                  style: GoogleFonts.jost(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                childrenPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                maintainState: true,
                trailing: Icon(
                  Icons.expand_more,
                  color: Colors.white,
                ),
                children: [
                  if (_hasImage())
                    ClipRRect(
                      borderRadius: BorderRadius.zero,
                      child: Image.network(
                        news.imageUrl!,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.error, size: 50, color: Colors.red);
                        },
                      ),
                    ),
                  if (news.content.isNotEmpty)
                    Text(
                      news.content,
                      style: GoogleFonts.jost(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: SvgPicture.asset('assets/Group 37755.svg'),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: SvgPicture.asset('assets/Path 19520.svg'),
          ),
          Positioned(
            bottom: 0,
            right: 20,
            child: Text(
              timeAgo(news.postTime),
              style: GoogleFonts.openSans(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}