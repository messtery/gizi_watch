import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Color Palette Constants
const Color kBackgroundColor = Color(0xFFF6F3EC);
const Color kPrimaryColor = Color(0xFF2F5D3A);
const Color kTextColor = Color(0xFF1C1F1A);

// Helper function untuk format waktu (Humanize untuk < 24 jam)
String formatTimestamp(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inMinutes < 1) {
    return 'Just now';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes}m ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours}h ago';
  } else {
    // Lebih dari 24 jam: tampilkan tanggal dan jam
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = months[dateTime.month - 1];
    final year = dateTime.year;
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$day $month $year, $hour:$minute';
  }
}

// Data Model untuk Utasan Forum
class ThreadItemData {
  final String id;
  final String title;
  final String content;
  final String authorName;
  final String authorAvatarUrl;
  final DateTime createdAt;
  final List<String> tags;
  int likesCount;
  int commentsCount;
  bool isLiked;
  bool isFollowed;

  ThreadItemData({
    required this.id,
    required this.title,
    required this.content,
    required this.authorName,
    required this.authorAvatarUrl,
    required this.createdAt,
    required this.tags,
    required this.likesCount,
    required this.commentsCount,
    this.isLiked = false,
    this.isFollowed = false,
  });
}

// Model untuk komentar pada detail thread
class CommentItemData {
  final String authorName;
  final String authorAvatarUrl;
  final String comment;
  final DateTime createdAt;

  CommentItemData({
    required this.authorName,
    required this.authorAvatarUrl,
    required this.comment,
    required this.createdAt,
  });
}

// Mock Data Utasan
List<ThreadItemData> getMockThreads() {
  final now = DateTime.now();
  return [
    ThreadItemData(
      id: '1',
      title: 'Rekomendasi takaran protein harian untuk pemula yang ingin surplus kalori?',
      content:
          'Saya baru mulai rutin gym 3 kali seminggu dengan target menaikkan berat badan secara bersih. Mau tanya rekomendasi rasio protein per kg berat badan dan contoh sumber protein lokal yang murah meriah.',
      authorName: 'Budi Santoso',
      authorAvatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150&auto=format&fit=crop&q=80',
      createdAt: now.subtract(const Duration(minutes: 25)),
      tags: ['Protein', 'MuscleBuilding', 'Nutrition', 'DietPlan'],
      likesCount: 24,
      commentsCount: 8,
      isLiked: true,
      isFollowed: true,
    ),
    ThreadItemData(
      id: '2',
      title: 'Tips menjaga pola makan saat harus sering makan malam di luar kantor',
      content:
          'Pekerjaan menuntut sering meeting malam dan makan bareng klien. Adakah strategi memilih menu di restoran agar kalori harian tidak terlampaui jauh?',
      authorName: 'Siti Rahma',
      authorAvatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&auto=format&fit=crop&q=80',
      createdAt: now.subtract(const Duration(hours: 4)),
      tags: ['EatingOut', 'WeightManagement', 'WorkLife'],
      likesCount: 15,
      commentsCount: 5,
      isLiked: false,
      isFollowed: true,
    ),
    ThreadItemData(
      id: '3',
      title: 'Apakah mengganti nasi putih ke beras merah efektif untuk diet defisit?',
      content:
          'Banyak yang bilang beras merah bikin kenyang lebih lama karena indeks glikemik rendah. Seberapa signifikan pengaruhnya dibanding hanya memotong porsi nasi putih biasa?',
      authorName: 'Andi Wijaya',
      authorAvatarUrl: 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?w=150&auto=format&fit=crop&q=80',
      createdAt: now.subtract(const Duration(hours: 18)),
      tags: ['Carbs', 'WeightLoss'],
      likesCount: 42,
      commentsCount: 19,
      isLiked: false,
      isFollowed: false,
    ),
    ThreadItemData(
      id: '4',
      title: 'Alternatif camilan sehat tinggi serat saat malam hari',
      content:
          'Sering merasa lapar saat lembur malam jam 10-an. Ada rekomendasi snack sehat yang praktis, rendah gula, tapi cukup mengganjal perut?',
      authorName: 'Dewi Lestari',
      authorAvatarUrl: 'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=150&auto=format&fit=crop&q=80',
      createdAt: DateTime(2026, 11, 10, 14, 30),
      tags: ['HealthySnack', 'Fiber', 'LateNight'],
      likesCount: 31,
      commentsCount: 12,
      isLiked: true,
      isFollowed: false,
    ),
    ThreadItemData(
      id: '5',
      title: 'Cara konsisten mencatat intake harian tanpa merasa terbebani',
      content:
          'Di minggu pertama selalu semangat catat tiap makanan, tapi masuk minggu ketiga mulai malas. Gimana cara kalian menjaga habit meal tracking tetap berjalan?',
      authorName: 'Rizky Pratama',
      authorAvatarUrl: 'https://images.unsplash.com/photo-1527980965255-d3b416303d12?w=150&auto=format&fit=crop&q=80',
      createdAt: DateTime(2026, 11, 9, 9, 15),
      tags: ['Habits', 'TrackingProgress'],
      likesCount: 56,
      commentsCount: 27,
      isLiked: false,
      isFollowed: true,
    ),
  ];
}

// -----------------------------------------------------------------------------
// MAIN FORUM PAGE WIDGET
// -----------------------------------------------------------------------------
class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  int _currentBottomNavIndex = 4; // News / Forum active
  late List<ThreadItemData> _allThreads;

  @override
  void initState() {
    super.initState();
    _allThreads = getMockThreads();
  }

  void _navigateToDetail(ThreadItemData thread) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ThreadDetailPage(
          thread: thread,
          onThreadUpdated: () {
            setState(() {});
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final followedThreads = _allThreads.where((t) => t.isFollowed).toList();

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              
              // Header Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: kPrimaryColor.withOpacity(0.12),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.03),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: kTextColor,
                              size: 20,
                            ),
                          ),
                        ),                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Community Forum',
                            style: GoogleFonts.fraunces(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: kTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),                    const SizedBox(height: 4),
                    Text(
                      'Discuss, ask questions, and share nutrition insights with the community.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        color: kTextColor.withOpacity(0.7),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Section: Followed Threads (Horizontal Cards)
              if (followedThreads.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Followed Threads',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: kTextColor,
                        ),
                      ),
                      Text(
                        '${followedThreads.length} Saved',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: kPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 215,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: followedThreads.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final thread = followedThreads[index];
                      return _FollowedThreadCard(
                        thread: thread,
                        onTap: () => _navigateToDetail(thread),
                        onToggleLike: () => setState(() {
                          thread.isLiked = !thread.isLiked;
                          thread.likesCount += thread.isLiked ? 1 : -1;
                        }),
                        onToggleFollow: () => setState(() {
                          thread.isFollowed = !thread.isFollowed;
                        }),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Search Input
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  style: GoogleFonts.plusJakartaSans(color: kTextColor),
                  decoration: InputDecoration(
                    hintText: 'Search threads or topics...',
                    hintStyle: GoogleFonts.plusJakartaSans(
                      color: kTextColor.withOpacity(0.4),
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(Icons.search, color: kPrimaryColor),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: kPrimaryColor.withOpacity(0.15),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: kPrimaryColor,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Sub-header: Recent Threads
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Recent Threads',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: kTextColor,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Vertical Threads List
              ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _allThreads.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final thread = _allThreads[index];
                  return _ThreadItemCard(
                    thread: thread,
                    onTap: () => _navigateToDetail(thread),
                    onToggleLike: () => setState(() {
                      thread.isLiked = !thread.isLiked;
                      thread.likesCount += thread.isLiked ? 1 : -1;
                    }),
                    onToggleFollow: () => setState(() {
                      thread.isFollowed = !thread.isFollowed;
                    }),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) {
          setState(() {
            _currentBottomNavIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: kTextColor.withOpacity(0.4),
        selectedLabelStyle: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
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
            icon: Icon(Icons.newspaper_outlined),
            activeIcon: Icon(Icons.newspaper),
            label: 'News',
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// COMPONENT: FOLLOWED THREAD CARD (HORIZONTAL SCROLL)
// -----------------------------------------------------------------------------
class _FollowedThreadCard extends StatelessWidget {
  final ThreadItemData thread;
  final VoidCallback onTap;
  final VoidCallback onToggleLike;
  final VoidCallback onToggleFollow;

  const _FollowedThreadCard({
    required this.thread,
    required this.onTap,
    required this.onToggleLike,
    required this.onToggleFollow,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: kPrimaryColor.withOpacity(0.12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Author Avatar + Name + Timestamp
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundImage: NetworkImage(thread.authorAvatarUrl),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        thread.authorName,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: kTextColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        formatTimestamp(thread.createdAt),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          color: kTextColor.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Title
            Text(
              thread.title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: kTextColor,
                height: 1.25,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),

            // Content Snippet (Max 2 lines)
            Text(
              thread.content,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: kTextColor.withOpacity(0.7),
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),

            // Tags + Actions Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: _TagBadgeRow(tags: thread.tags),
                  ),
                ),
                const SizedBox(width: 4),
                _ActionIconButton(
                  icon: thread.isLiked ? Icons.favorite : Icons.favorite_border,
                  iconColor: thread.isLiked ? Colors.redAccent : kTextColor.withOpacity(0.6),
                  count: thread.likesCount,
                  onTap: onToggleLike,
                ),
                const SizedBox(width: 6),
                _ActionIconButton(
                  icon: Icons.chat_bubble_outline_rounded,
                  iconColor: kTextColor.withOpacity(0.6),
                  count: thread.commentsCount,
                  onTap: onTap,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// COMPONENT: VERTICAL THREAD ITEM CARD
// -----------------------------------------------------------------------------
class _ThreadItemCard extends StatelessWidget {
  final ThreadItemData thread;
  final VoidCallback onTap;
  final VoidCallback onToggleLike;
  final VoidCallback onToggleFollow;

  const _ThreadItemCard({
    required this.thread,
    required this.onTap,
    required this.onToggleLike,
    required this.onToggleFollow,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Author Info Header + Eye Icon "Follow thread" Button
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(thread.authorAvatarUrl),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        thread.authorName,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: kTextColor,
                        ),
                      ),
                      Text(
                        formatTimestamp(thread.createdAt),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: kTextColor.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                // Eye Icon Button with Text "Follow thread"
                InkWell(
                  onTap: onToggleFollow,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          thread.isFollowed ? Icons.visibility : Icons.visibility_outlined,
                          color: thread.isFollowed ? kPrimaryColor : kTextColor.withOpacity(0.4),
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          thread.isFollowed ? 'Following' : 'Follow thread',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: thread.isFollowed ? FontWeight.w600 : FontWeight.w500,
                            color: thread.isFollowed ? kPrimaryColor : kTextColor.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Title
            Text(
              thread.title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: kTextColor,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),

            // Footer: Tag Badge + Interactivity Counter Bar
            Row(
              children: [
                Expanded(child: _TagBadgeRow(tags: thread.tags)),
                Row(
                  children: [
                    _ActionIconButton(
                      icon: thread.isLiked ? Icons.favorite : Icons.favorite_border,
                      iconColor: thread.isLiked ? Colors.redAccent : kTextColor.withOpacity(0.6),
                      count: thread.likesCount,
                      onTap: onToggleLike,
                    ),
                    const SizedBox(width: 12),
                    _ActionIconButton(
                      icon: Icons.chat_bubble_outline_rounded,
                      iconColor: kTextColor.withOpacity(0.6),
                      count: thread.commentsCount,
                      onTap: onTap,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// COMPONENT: TAG BADGES (First tag + "+n" badge)
// -----------------------------------------------------------------------------
class _TagBadgeRow extends StatelessWidget {
  final List<String> tags;

  const _TagBadgeRow({required this.tags});

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) return const SizedBox.shrink();

    final firstTag = tags.first;
    final remainingCount = tags.length - 1;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: kPrimaryColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '#$firstTag',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: kPrimaryColor,
            ),
          ),
        ),
        if (remainingCount > 0) ...[
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: kTextColor.withOpacity(0.06),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '+$remainingCount',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: kTextColor.withOpacity(0.6),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// COMPONENT: ACTION ICON BUTTON WITH COUNTER
// -----------------------------------------------------------------------------
class _ActionIconButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final int count;
  final VoidCallback onTap;

  const _ActionIconButton({
    required this.icon,
    required this.iconColor,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Row(
          children: [
            Icon(icon, size: 16, color: iconColor),
            const SizedBox(width: 4),
            Text(
              '$count',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: kTextColor.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// DETAIL PAGE WIDGET
// -----------------------------------------------------------------------------
class ThreadDetailPage extends StatefulWidget {
  final ThreadItemData thread;
  final VoidCallback onThreadUpdated;

  const ThreadDetailPage({
    super.key,
    required this.thread,
    required this.onThreadUpdated,
  });

  @override
  State<ThreadDetailPage> createState() => _ThreadDetailPageState();
}

class _ThreadDetailPageState extends State<ThreadDetailPage> {
  final TextEditingController _commentController = TextEditingController();

  final List<CommentItemData> _comments = [
    CommentItemData(
      authorName: 'Dr. Ratna Sari',
      authorAvatarUrl: 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=150&auto=format&fit=crop&q=80',
      comment: 'Saran saya fokus ke target protein 1.6g - 2.0g per kg berat badan. Telur rebus, tempe, tahu, dan dada ayam tanpa kulit sangat efektif.',
      createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    CommentItemData(
      authorName: 'Fajar Nugraha',
      authorAvatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&auto=format&fit=crop&q=80',
      comment: 'Setuju! Dada ayam fillet rebus atau panggang teflon tanpa minyak adalah sumber paling hemat dan tinggi protein.',
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _addComment() {
    if (_commentController.text.trim().isEmpty) return;
    setState(() {
      _comments.add(
        CommentItemData(
          authorName: 'You',
          authorAvatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&auto=format&fit=crop&q=80',
          comment: _commentController.text.trim(),
          createdAt: DateTime.now(),
        ),
      );
      widget.thread.commentsCount += 1;
      _commentController.clear();
    });
    widget.onThreadUpdated();
  }

  @override
  Widget build(BuildContext context) {
    final thread = widget.thread;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Thread Detail',
          style: GoogleFonts.plusJakartaSans(
            color: kTextColor,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        actions: [
          // Eye Icon Button with Text "Follow thread" in AppBar
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  thread.isFollowed = !thread.isFollowed;
                });
                widget.onThreadUpdated();
              },
              icon: Icon(
                thread.isFollowed ? Icons.visibility : Icons.visibility_outlined,
                color: thread.isFollowed ? kPrimaryColor : kTextColor.withOpacity(0.6),
                size: 18,
              ),
              label: Text(
                thread.isFollowed ? 'Following' : 'Follow thread',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: thread.isFollowed ? FontWeight.w600 : FontWeight.w500,
                  color: thread.isFollowed ? kPrimaryColor : kTextColor.withOpacity(0.7),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Author Profile Header
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(thread.authorAvatarUrl),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            thread.authorName,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: kTextColor,
                            ),
                          ),
                          Text(
                            formatTimestamp(thread.createdAt),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: kTextColor.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Thread Title (Fraunces accent font)
                  Text(
                    thread.title,
                    style: GoogleFonts.fraunces(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: kTextColor,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Thread Main Body Content
                  Text(
                    thread.content,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: kTextColor.withOpacity(0.85),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // All Tags Display
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: thread.tags
                        .map(
                          (tag) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: kPrimaryColor.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '#$tag',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: kPrimaryColor,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 16),

                  // Interaction Counter Bar
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              thread.isLiked = !thread.isLiked;
                              thread.likesCount += thread.isLiked ? 1 : -1;
                            });
                            widget.onThreadUpdated();
                          },
                          child: Row(
                            children: [
                              Icon(
                                thread.isLiked ? Icons.favorite : Icons.favorite_border,
                                color: thread.isLiked ? Colors.redAccent : kTextColor.withOpacity(0.6),
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${thread.likesCount} Likes',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: kTextColor.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.chat_bubble_outline_rounded,
                              color: kTextColor.withOpacity(0.6),
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${thread.commentsCount} Comments',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: kTextColor.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 8),

                  // Comments Header
                  Text(
                    'Replies',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: kTextColor,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Comments List
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _comments.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final c = _comments[index];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundImage: NetworkImage(c.authorAvatarUrl),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  c.authorName,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: kTextColor,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  formatTimestamp(c.createdAt),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10,
                                    color: kTextColor.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              c.comment,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: kTextColor.withOpacity(0.8),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Comment Input Field Sticky Bottom Bar
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      style: GoogleFonts.plusJakartaSans(color: kTextColor),
                      decoration: InputDecoration(
                        hintText: 'Write a reply...',
                        hintStyle: GoogleFonts.plusJakartaSans(
                          color: kTextColor.withOpacity(0.4),
                          fontSize: 13,
                        ),
                        filled: true,
                        fillColor: kBackgroundColor,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _addComment,
                    icon: const Icon(Icons.send_rounded, color: kPrimaryColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}