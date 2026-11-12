import 'package:flutter/material.dart';
import 'package:gizi_watch/pages/forum_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Health & News App',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF6F3EC),
        fontFamily: 'Plus Jakarta Sans',
      ),
      home: const NewsPage(),
    );
  }
}

// Data Model Berita
class NewsItem {
  final int id;
  final String category;
  final String title;
  final String imageUrl;
  final String summary;
  final List<String> contentParagraphs;
  final String keyQuote;
  final String dateTime;

  NewsItem({
    required this.id,
    required this.category,
    required this.title,
    required this.imageUrl,
    required this.summary,
    required this.contentParagraphs,
    required this.keyQuote,
    required this.dateTime,
  });

  String get fullSearchText => '$title $category $summary ${contentParagraphs.join(' ')}';
}

// Config Style Warna Kategori Terbatas
class CategoryStyle {
  final Color backgroundColor;
  final Color textColor;

  const CategoryStyle({
    required this.backgroundColor,
    required this.textColor,
  });
}

const Map<String, CategoryStyle> categoryStyles = {
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

CategoryStyle getCategoryStyle(String category) {
  return categoryStyles[category] ??
      const CategoryStyle(
        backgroundColor: Color(0xFFEEEEEE),
        textColor: Color(0xFF616161),
      );
}

// ==========================================
// HALAMAN DETAIL BERITA (NewsDetailPage)
// ==========================================
class NewsDetailPage extends StatefulWidget {
  final NewsItem news;
  final List<NewsItem> allNews;
  final Set<int> bookmarkedIds;
  final Function(int) onToggleBookmark;

  const NewsDetailPage({
    super.key,
    required this.news,
    required this.allNews,
    required this.bookmarkedIds,
    required this.onToggleBookmark,
  });

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  void _shareArticle() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing article: "${widget.news.title}"'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _navigateToDetail(NewsItem item) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => NewsDetailPage(
          news: item,
          allNews: widget.allNews,
          bookmarkedIds: widget.bookmarkedIds,
          onToggleBookmark: widget.onToggleBookmark,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF2F5D3A);
    const Color textColor = Color(0xFF1C1F1A);
    final categoryStyle = getCategoryStyle(widget.news.category);
    final isBookmarked = widget.bookmarkedIds.contains(widget.news.id);

    final recommendedNews = widget.allNews.where((item) => item.id != widget.news.id).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.network(
                    widget.news.imageUrl,
                    width: double.infinity,
                    height: 280,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 280,
                      color: primaryColor.withOpacity(0.1),
                      child: const Center(
                        child: Icon(Icons.image_not_supported_rounded, size: 48, color: primaryColor),
                      ),
                    ),
                  ),

                  Positioned(
                    top: MediaQuery.of(context).padding.top + 12,
                    left: 16,
                    right: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: textColor, size: 18),
                            onPressed: () => Navigator.pop(context),
                            tooltip: 'Back',
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.share_outlined, color: textColor, size: 20),
                                onPressed: _shareArticle,
                                tooltip: 'Share article',
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: Icon(
                                  isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                                  color: isBookmarked ? primaryColor : textColor,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    widget.onToggleBookmark(widget.news.id);
                                  });
                                },
                                tooltip: isBookmarked ? 'Remove bookmark' : 'Bookmark article',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: categoryStyle.backgroundColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            widget.news.category,
                            style: TextStyle(
                              color: categoryStyle.textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 16,
                              color: textColor.withOpacity(0.5),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              widget.news.dateTime,
                              style: TextStyle(
                                fontSize: 13,
                                color: textColor.withOpacity(0.6),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.news.title,
                      style: const TextStyle(
                        fontFamily: 'Fraunces',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Color(0xFFE0DCD3), height: 1),
                    const SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 15,
                          color: textColor,
                          height: 1.7,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Penting untuk diketahui: ',
                            style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
                          ),
                          TextSpan(text: widget.news.contentParagraphs[0]),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(12),
                        border: const Border(
                          left: BorderSide(color: primaryColor, width: 4),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.format_quote_rounded, color: primaryColor, size: 28),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              widget.news.keyQuote,
                              style: const TextStyle(
                                fontFamily: 'Fraunces',
                                fontSize: 15,
                                fontStyle: FontStyle.italic,
                                color: primaryColor,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: widget.news.contentParagraphs.sublist(1).map((para) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            para,
                            style: const TextStyle(
                              fontSize: 15,
                              color: textColor,
                              height: 1.7,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    const Divider(color: Color(0xFFE0DCD3), height: 1),
                    const SizedBox(height: 24),
                    const Text(
                      'You May Like',
                      style: TextStyle(
                        fontFamily: 'Fraunces',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: recommendedNews.length,
                      itemBuilder: (context, index) {
                        final item = recommendedNews[index];
                        final itemCategoryStyle = getCategoryStyle(item.category);
                        final isItemBookmarked = widget.bookmarkedIds.contains(item.id);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6F3EC).withOpacity(0.5),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: primaryColor.withOpacity(0.08)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    item.imageUrl,
                                    width: 100,
                                    height: 105,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      width: 100,
                                      height: 105,
                                      color: primaryColor.withOpacity(0.1),
                                      child: const Icon(Icons.image_not_supported_rounded, color: primaryColor),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: itemCategoryStyle.backgroundColor,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              item.category,
                                              style: TextStyle(
                                                color: itemCategoryStyle.textColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            icon: Icon(
                                              isItemBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                                              color: isItemBookmarked ? primaryColor : textColor.withOpacity(0.4),
                                              size: 20,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                widget.onToggleBookmark(item.id);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        item.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: textColor,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item.summary,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: textColor.withOpacity(0.75),
                                          height: 1.35,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            item.dateTime,
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: textColor.withOpacity(0.45),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () => _navigateToDetail(item),
                                            borderRadius: BorderRadius.circular(4),
                                            child: const Row(
                                              children: [
                                                Text(
                                                  'Read More',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: primaryColor,
                                                  ),
                                                ),
                                                SizedBox(width: 2),
                                                Icon(Icons.arrow_forward_ios_rounded, size: 10, color: primaryColor),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// HALAMAN LIST BOOKMARK (BookmarkedNewsPage)
// ==========================================
class BookmarkedNewsPage extends StatefulWidget {
  final List<NewsItem> bookmarkedNews;
  final Function(int) onRemoveBookmark;
  final List<NewsItem> allNews;
  final Set<int> bookmarkedIds;

  const BookmarkedNewsPage({
    super.key,
    required this.bookmarkedNews,
    required this.onRemoveBookmark,
    required this.allNews,
    required this.bookmarkedIds,
  });

  @override
  State<BookmarkedNewsPage> createState() => _BookmarkedNewsPageState();
}

class _BookmarkedNewsPageState extends State<BookmarkedNewsPage> {
  late List<NewsItem> _currentList;

  @override
  void initState() {
    super.initState();
    _currentList = List.from(widget.bookmarkedNews);
  }

  void _removeItem(int id, int index) {
    widget.onRemoveBookmark(id);
    setState(() {
      _currentList.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Dihapus dari simpanan'),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _navigateToDetail(NewsItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewsDetailPage(
          news: item,
          allNews: widget.allNews,
          bookmarkedIds: widget.bookmarkedIds,
          onToggleBookmark: widget.onRemoveBookmark,
        ),
      ),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 16, 20, 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: primaryColor),
                    onPressed: () => Navigator.pop(context),
                    tooltip: 'Back',
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Saved Bookmarks',
                    style: TextStyle(
                      fontFamily: 'Fraunces',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _currentList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bookmark_border_rounded,
                            size: 64,
                            color: textColor.withOpacity(0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No bookmarked articles yet',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Articles you save will appear here for easy access.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: textColor.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                      itemCount: _currentList.length,
                      itemBuilder: (context, index) {
                        final item = _currentList[index];
                        final categoryStyle = getCategoryStyle(item.category);

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
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    item.imageUrl,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      width: 100,
                                      height: 100,
                                      color: primaryColor.withOpacity(0.1),
                                      child: const Icon(Icons.image_not_supported, color: primaryColor),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: categoryStyle.backgroundColor,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          item.category,
                                          style: TextStyle(
                                            color: categoryStyle.textColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        item.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: textColor,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item.summary,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: textColor.withOpacity(0.75),
                                          height: 1.3,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            onTap: () => _navigateToDetail(item),
                                            child: const Row(
                                              children: [
                                                Text(
                                                  'Read More',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: primaryColor,
                                                  ),
                                                ),
                                                Icon(Icons.arrow_forward_ios_rounded, size: 10, color: primaryColor),
                                              ],
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () => _removeItem(item.id, index),
                                            child: const Row(
                                              children: [
                                                Icon(Icons.delete_outline_rounded, size: 14, color: Colors.redAccent),
                                                SizedBox(width: 2),
                                                Text(
                                                  'Remove',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.redAccent,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
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
    );
  }
}

// ==========================================
// HALAMAN UTAMA LIST BERITA (NewsPage)
// ==========================================
class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  int _currentIndex = 4;
  final TextEditingController _searchController = TextEditingController();
  final Set<int> _bookmarkedIds = {};
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Nutrition',
    'Stunting',
    'Malnutrition',
    'Child Health',
  ];

  final List<NewsItem> _allNews = [
    NewsItem(
      id: 1,
      category: 'Nutrition',
      title: 'Pentingnya Asupan Protein Hewani untuk Mencegah Stunting Anak',
      imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=800&q=80',
      summary: 'Protein hewani seperti telur dan ikan kaya akan asam amino esensial yang optimal untuk tumbuh kembang anak.',
      contentParagraphs: [
        'Sumber protein hewani seperti telur, ikan, dan daging mengandung asam amino esensial lengkap yang sangat dibutuhkan oleh tubuh anak dalam masa pertumbuhan. Protein hewani memiliki tingkat penyerapan (bioavailabilitas) yang jauh lebih tinggi dibandingkan sumber nabati.',
        'Mengonsumsi protein hewani secara rutin dapat meningkatkan massa otot, memperkuat kepadatan tulang, serta mendukung perkembangan jaringan otak secara signifikan. Para ahli gizi merekomendasikan pemberian protein hewani secara bervariasi sejak dimulainya Makanan Pendamping ASI (MPASI) di usia 6 bulan.',
        'Hati ayam, ikan kembung, dan telur merupakan pilihan ekonomis yang kaya akan zat besi dan seng. Asupan konsisten dari bahan pangan lokal ini terbukti efektif menjaga grafik pertumbuhan anak tetap optimal pada kurva standar WHO.',
      ],
      keyQuote: 'Pemberian satu butir telur per hari pada balita terbukti dapat menurunkan risiko stunting hingga 47%.',
      dateTime: '12 Mei 2024, 09:30',
    ),
    NewsItem(
      id: 2,
      category: 'Stunting',
      title: 'Deteksi Dini Gejala Stunting dan Langkah Intervensi Cepat',
      imageUrl: 'https://images.unsplash.com/photo-1502086223501-7ea6ecd79368?auto=format&fit=crop&w=800&q=80',
      summary: 'Mengenali tanda stunting sejak awal membantu orang tua memberikan penanganan gizi yang lebih efektif.',
      contentParagraphs: [
        'Stunting ditandai ketika tinggi badan anak berada di bawah standar panjang badan sesuai usianya. Selain masalah fisik, anak yang mengalami stunting juga berisiko mengalami hambatan perkembangan kognitif dan rentan terkena penyakit infeksi.',
        'Intervensi pada 1.000 Hari Pertama Kehidupan (HPK)—sejak pembuahan dalam kandungan hingga anak berusia dua tahun—adalah periode emas yang menentukan. Penanganan setelah lewat dari periode ini akan jauh lebih sulit dan hasilnya kurang maksimal.',
        'Pemantauan rutin di Posyandu setiap bulan menjadi kunci utama deteksi dini. Jika grafik berat dan tinggi badan anak melandai, segera konsultasikan dengan tenaga kesehatan untuk evaluasi gizi lebih lanjut.',
      ],
      keyQuote: '1.000 Hari Pertama Kehidupan adalah jendela kesempatan terbaik untuk memastikan anak tumbuh sehat tanpa stunting.',
      dateTime: '11 Mei 2024, 14:15',
    ),
    NewsItem(
      id: 3,
      category: 'Malnutrition',
      title: 'Dampak Gizi Buruk Kronis terhadap Fungsi Kognitif Anak',
      imageUrl: 'https://images.unsplash.com/photo-1498837167922-ddd27525d352?auto=format&fit=crop&w=800&q=80',
      summary: 'Kekurangan nutrisi jangka panjang dapat memengaruhi memori, fokus belajar, dan daya tahan tubuh anak.',
      contentParagraphs: [
        'Kurang gizi kronis yang tidak ditangani sejak dini dapat merusak pembentukan sambungan saraf di otak. Kekurangan zat mikro penting seperti asam lemak esensial, yodium, dan zat besi menurunkan kemampuan daya ingat dan daya konsentrasi belajar anak.',
        'Dampak jangka panjang dari malnutrisi mencakup penurunan prestasi akademik dan produktivitas saat dewasa. Selain itu, kondisi ini juga memicu kerentanan terhadap gangguan metabolik di kemudian hari.',
        'Program pemberian makanan tambahan berbasis bahan pangan lokal yang dipadukan dengan edukasi kebersihan diri menjadi langkah komprehensif dalam memutus mata rantai masalah kurang gizi.',
      ],
      keyQuote: 'Investasi gizi pada usia dini adalah bentuk jaminan terbaik bagi masa depan intelektual dan kesehatan anak.',
      dateTime: '10 Mei 2024, 16:45',
    ),
    NewsItem(
      id: 4,
      category: 'Child Health',
      title: 'Panduan Nutrisi Ibu Hamil untuk Mencegah Risiko BBLR pada Bayi',
      imageUrl: 'https://images.unsplash.com/photo-1516627145497-ae6968895b74?auto=format&fit=crop&w=800&q=80',
      summary: 'Asupan asam folat, zat besi, dan kalsium yang cukup saat hamil menjaga kesehatan janin secara menyeluruh.',
      contentParagraphs: [
        'Pemenuhan gizi seimbang selama masa kehamilan sangat mempengaruhi kualitas kelahiran bayi. Konsumsi suplemen penambah darah, asam folat, serta kalsium mencegah terjadinya kondisi Berat Badan Lahir Rendah (BBLR).',
        'Kebutuhan metabolisme ibu meningkat tajam demi mendukung pembentukan organ vital janin. Dukungan nutrisi yang adekuat disertai pemeriksaan kehamilan secara rutin meminimalkan risiko anemia pada ibu hamil.',
        'Pola hidup sehat, istirahat cukup, dan dukungan penuh dari anggota keluarga menciptakan lingkungan emosional yang kondusif bagi tumbuh kembang janin di dalam kandungan.',
      ],
      keyQuote: 'Kesehatan bayi baru lahir bermula dari nutrisi seimbang dan perawatan teratur yang diterima ibu selama masa kehamilan.',
      dateTime: '09 Mei 2024, 08:00',
    ),
  ];

  List<NewsItem> _filteredNews = [];

  @override
  void initState() {
    super.initState();
    _applyFilter();
  }

  void _applyFilter() {
    setState(() {
      final query = _searchController.text.toLowerCase();
      _filteredNews = _allNews.where((news) {
        final matchesCategory = _selectedCategory == 'All' || news.category == _selectedCategory;
        final matchesQuery = query.isEmpty || news.fullSearchText.toLowerCase().contains(query);
        return matchesCategory && matchesQuery;
      }).toList();
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _applyFilter();
  }

  void _toggleBookmark(int id) {
    setState(() {
      if (_bookmarkedIds.contains(id)) {
        _bookmarkedIds.remove(id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dihapus dari simpanan'),
            duration: Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        _bookmarkedIds.add(id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Disimpan ke bookmark'),
            duration: Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  void _navigateToDetail(NewsItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewsDetailPage(
          news: item,
          allNews: _allNews,
          bookmarkedIds: _bookmarkedIds,
          onToggleBookmark: _toggleBookmark,
        ),
      ),
    );
  }

  void _navigateToBookmarkPage() {
    final bookmarkedItems = _allNews.where((item) => _bookmarkedIds.contains(item.id)).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookmarkedNewsPage(
          bookmarkedNews: bookmarkedItems,
          allNews: _allNews,
          bookmarkedIds: _bookmarkedIds,
          onRemoveBookmark: (id) {
            setState(() {
              _bookmarkedIds.remove(id);
            });
          },
        ),
      ),
    );
  }

  void _navigateToForumPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ForumPage(),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF2F5D3A);
    const Color textColor = Color(0xFF1C1F1A);

    final latestNewsList = _allNews.take(3).toList();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Top Bar Header dengan Link Bookmark & Link Forum Hashtag
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Articles & News',
                          style: TextStyle(
                            fontFamily: 'Fraunces',
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        Row(
                          children: [
                            // Tombol Link ke Bookmark
                            InkWell(
                              onTap: _navigateToBookmarkPage,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.bookmark_rounded,
                                      color: primaryColor,
                                      size: 22,
                                    ),
                                    if (_bookmarkedIds.isNotEmpty) ...[
                                      const SizedBox(width: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          '${_bookmarkedIds.length}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Tombol Link ke Forum (Icon Hashtag #)
                            InkWell(
                              onTap: _navigateToForumPage,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.tag_rounded,
                                  color: primaryColor,
                                  size: 22,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
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
            ),

            // Search Bar Input
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => _applyFilter(),
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
            ),

            // Section "Latest News"
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 16, 20, 10),
                    child: Text(
                      'Latest News',
                      style: TextStyle(
                        fontFamily: 'Fraunces',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 190,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: latestNewsList.length,
                      itemBuilder: (context, index) {
                        final item = latestNewsList[index];
                        final categoryStyle = getCategoryStyle(item.category);

                        return Container(
                          width: 280,
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          child: InkWell(
                            onTap: () => _navigateToDetail(item),
                            borderRadius: BorderRadius.circular(16),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Image.network(
                                      item.imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        color: primaryColor.withOpacity(0.2),
                                        child: const Icon(Icons.image_not_supported, color: primaryColor),
                                      ),
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withOpacity(0.3),
                                            Colors.black.withOpacity(0.85),
                                          ],
                                          stops: const [0.0, 0.4, 1.0],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 14,
                                    left: 14,
                                    right: 14,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: categoryStyle.backgroundColor.withOpacity(0.9),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            item.category,
                                            style: TextStyle(
                                              color: categoryStyle.textColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          item.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            height: 1.3,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.access_time_rounded,
                                              size: 12,
                                              color: Colors.white70,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              item.dateTime,
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Category Filter
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((cat) {
                      final isSelected = _selectedCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(cat),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedCategory = cat;
                                _applyFilter();
                              });
                            }
                          },
                          selectedColor: primaryColor,
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : textColor,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            fontSize: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: isSelected ? primaryColor : primaryColor.withOpacity(0.15),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

            // Main News List
            _filteredNews.isEmpty
                ? SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
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
                      ),
                    ),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final item = _filteredNews[index];
                          final categoryStyle = getCategoryStyle(item.category);
                          final isBookmarked = _bookmarkedIds.contains(item.id);

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
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      item.imageUrl,
                                      width: 105,
                                      height: 115,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        width: 105,
                                        height: 115,
                                        color: primaryColor.withOpacity(0.1),
                                        child: const Icon(
                                          Icons.image_not_supported_rounded,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 3,
                                              ),
                                              decoration: BoxDecoration(
                                                color: categoryStyle.backgroundColor,
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                item.category,
                                                style: TextStyle(
                                                  color: categoryStyle.textColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(),
                                              icon: Icon(
                                                isBookmarked
                                                    ? Icons.bookmark_rounded
                                                    : Icons.bookmark_border_rounded,
                                                color: isBookmarked
                                                    ? primaryColor
                                                    : textColor.withOpacity(0.4),
                                                size: 22,
                                              ),
                                              onPressed: () => _toggleBookmark(item.id),
                                              tooltip: isBookmarked ? 'Remove bookmark' : 'Bookmark article',
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          item.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: textColor,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          item.summary,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: textColor.withOpacity(0.75),
                                            height: 1.35,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.access_time_rounded,
                                                  size: 12,
                                                  color: textColor.withOpacity(0.45),
                                                ),
                                                const SizedBox(width: 3),
                                                Text(
                                                  item.dateTime,
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: textColor.withOpacity(0.45),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            InkWell(
                                              onTap: () => _navigateToDetail(item),
                                              borderRadius: BorderRadius.circular(4),
                                              child: const Row(
                                                children: [
                                                  Text(
                                                    'Read More',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      color: primaryColor,
                                                    ),
                                                  ),
                                                  SizedBox(width: 2),
                                                  Icon(
                                                    Icons.arrow_forward_ios_rounded,
                                                    size: 10,
                                                    color: primaryColor,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        childCount: _filteredNews.length,
                      ),
                    ),
                  ),
          ],
        ),
      ),
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