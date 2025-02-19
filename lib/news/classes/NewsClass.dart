class News {
  final String news;
  final String postTime;
  final String content;
  final String? imageUrl;

  const News({
    required this.news,
    required this.postTime,
    required this.content,
    this.imageUrl,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      news: json["properties"]["News"]["title"].isNotEmpty
          ? json["properties"]["News"]["title"][0]["plain_text"]
          : "No Title",
      postTime: json["properties"]["PostTime"]["created_time"] ?? "",
      content: json["properties"]["Content"]["rich_text"].isNotEmpty
          ? json["properties"]["Content"]["rich_text"]
          .map((item) => item["plain_text"])
          .join("\n")
          : "No Content",
      imageUrl: json["properties"]["ImageURL"]["rich_text"].isNotEmpty
          ? json["properties"]["ImageURL"]["rich_text"][0]["plain_text"]
          : null,
    );
  }
}
