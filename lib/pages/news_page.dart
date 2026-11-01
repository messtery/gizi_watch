import 'package:flutter/material.dart';

// Data Model untuk Berita
class NewsItem {
  final String category;
  final String title;
  final String content;
  final String dateTime;

  NewsItem({
    required this.category,
    required this.title,
    required this.content,
    required this.dateTime,
  });
}

// Config Style Warna untuk Kategori Terbatas
class CategoryStyle {
  final Color backgroundColor;
  final Color textColor;

  const CategoryStyle({
    required this.backgroundColor,
    required this.textColor,
  });
}

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  int _currentIndex = 4; // Tab aktif: News (Indeks 4)
  final TextEditingController _searchController = TextEditingController();

  // Pemetaan Warna Kategori Terbatas (Pre-defined)
  static const Map<String, CategoryStyle> _categoryStyles = {
    'Nutrition': CategoryStyle(
      backgroundColor: Color(0xFFE8F5E9),
      textColor: Color(0xFF2E7D32),
    ),
    'Stunting': CategoryStyle(
      backgroundColor: Color(0xFFFFF3E0),
      textColor: Color(0xFFE65100),
    ),
    'Malnutrition': CategoryStyle(
      backgroundColor: Color(0xFFFFEBEE),
      textColor: Color(0xFFC62828),
    ),
    'Child Health': CategoryStyle(
      backgroundColor: Color(0xFFE3F2FD),
      textColor: Color(0xFF1565C0),
    ),
  };

  // Dataset Berita Dummy
  final List<NewsItem> _allNews = [
    NewsItem(
      category: 'Nutrition',
      title: 'Essential Animal Protein Intake to Prevent Stunting in Children',
      content:
          'Animal protein sources such as eggs, fish, and meat contain essential amino acids vital for child growth and brain development during early childhood.',
      dateTime: '12 May 2024, 09:30',
    ),
    NewsItem(
      category: 'Stunting',
      title: 'Identifying Key Symptoms of Stunting and Early Intervention',
      content:
          'Stunting can be identified when a child’s height falls below standard growth charts. Early nutritional support during the first 1,000 days is critical.',
      dateTime: '11 May 2024, 14:15',
    ),
    NewsItem(
      category: 'Malnutrition',
      title: 'Long-term Effects of Chronic Undernutrition on Cognitive Function',
      content:
          'Unaddressed chronic malnutrition impairs long-term memory, academic concentration, and weakens the immune response against childhood infections.',
      dateTime: '10 May 2024, 16:45',
    ),
    NewsItem(
      category: 'Child Health',
      title: 'Maternal Nutrition Guidelines for Healthy Infant Outcomes',
      content:
          'Proper prenatal nutrition including folic acid, iron, and calcium supplementation drastically reduces the risk of low birth weight and neonatal complications.',
      dateTime: '09 May 2024, 08:00',
    ),
  ];

  List<NewsItem> _filteredNews = [];

  @override
  void initState() {
    super.initState();
    _filteredNews = List.from(_allNews);
  }

  void _filterNews(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredNews = List.from(_allNews);
      } else {
        final lowerQuery = query.toLowerCase();
        _filteredNews = _allNews.where((news) {
          final matchesTitle = news.title.toLowerCase().contains(lowerQuery);
          final matchesCategory = news.category.toLowerCase().contains(lowerQuery);
          final matchesContent = news.content.toLowerCase().contains(lowerQuery);
          return matchesTitle || matchesCategory || matchesContent;
        }).toList();
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _filterNews('');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  CategoryStyle _getCategoryStyle(String category) {
    return _categoryStyles[category] ??
        const CategoryStyle(
          backgroundColor: Color(0xFFEEEEEE),
          textColor: Color(0xFF616161),
        );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF2F5D3A);
    const Color textColor = Color(0xFF1C1F1A);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'News',
                    style: TextStyle(
                      fontFamily: 'Fraunces',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Stay informed with the latest insights on child nutrition, stunting prevention, and wellness.',
                    style: TextStyle(
                      fontSize: 14,
                      color: textColor,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: TextField(
                controller: _searchController,
                onChanged: _filterNews,
                style: const TextStyle(color: textColor, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search by title, category, or content...',
                  hintStyle: TextStyle(
                    color: textColor.withOpacity(0.45),
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(Icons.search, color: primaryColor),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: textColor, size: 20),
                          onPressed: _clearSearch,
                          tooltip: 'Clear search',
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: primaryColor.withOpacity(0.12)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: primaryColor, width: 1.5),
                  ),
                ),
              ),
            ),

            // Main News List View
            Expanded(
              child: _filteredNews.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 48,
                            color: textColor.withOpacity(0.3),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No news found',
                            style: TextStyle(
                              color: textColor.withOpacity(0.8),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Try searching with different keywords.',
                            style: TextStyle(
                              color: textColor.withOpacity(0.5),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                      itemCount: _filteredNews.length,
                      itemBuilder: (context, index) {
                        final item = _filteredNews[index];
                        final categoryStyle = _getCategoryStyle(item.category);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Badge Kategori Terdaftar
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: categoryStyle.backgroundColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    item.category,
                                    style: TextStyle(
                                      color: categoryStyle.textColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // Judul Berita (Maksimal 1 baris dengan Ellipsis)
                                Text(
                                  item.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Isi Konten Singkat (Maksimal 3 baris dengan Ellipsis)
                                Text(
                                  item.content,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: textColor.withOpacity(0.8),
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Tanggal & Waktu
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time_rounded,
                                      size: 14,
                                      color: textColor.withOpacity(0.45),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      item.dateTime,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: textColor.withOpacity(0.45),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: textColor.withOpacity(0.45),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            activeIcon: Icon(Icons.book),
            label: 'Diary',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.accessibility_new_outlined),
            activeIcon: Icon(Icons.accessibility_new),
            label: 'Body',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu_outlined),
            activeIcon: Icon(Icons.restaurant_menu),
            label: 'Recipes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            activeIcon: Icon(Icons.article),
            label: 'News',
          ),
        ],
      ),
    );
  }
}