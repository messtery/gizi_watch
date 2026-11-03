import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

const Color _bg = Color(0xFFF4F2EC);
const Color _green = Color(0xFF3F5B3F);
const Color _ink = Color(0xFF1C1C1A);
const Color _grey = Color(0xFF6B6B66);
const Color _border = Color(0xFFDDD9CF);
const Color _thumb = Color(0xFFD6D0BF);

// ============================================================
// DATA VIDEO: link YouTube tiap resep. Thumbnail, nama channel, dan
// durasi (mm:ss) diambil otomatis dari link ini.
// ============================================================
class _Recipe {
  final String title;
  final String url;
  // Opsional: durasi cadangan (mm:ss) kalau durasi otomatis gagal diambil.
  final String? fallbackDuration;
  const _Recipe(this.title, this.url, {this.fallbackDuration});
}

const List<_Recipe> _recipes = [
  _Recipe(
    'Tumis hati ayam kecap',
    'https://www.youtube.com/watch?v=wOqNq9mtT_4',
  ),
  _Recipe('Sup kacang merah', 'https://www.youtube.com/watch?v=UwVe28dT9vk'),
  _Recipe('Semur daging sapi', 'https://www.youtube.com/watch?v=qsJ0PbzHygc'),
  _Recipe(
    'Oseng tempe kacang panjang',
    'https://www.youtube.com/watch?v=I4HeStZ5nfY',
  ),
];

const List<Color> _itemColors = [
  Color(0xFFCDD3C4),
  Color(0xFFD6D0BF),
  Color(0xFFCED4DC),
];

class _VideoInfo {
  final String channel;
  final String duration;
  const _VideoInfo(this.channel, this.duration);
}

String _formatDuration(Duration d) {
  final m = d.inMinutes;
  final s = (d.inSeconds % 60).toString().padLeft(2, '0');
  return '${m.toString().padLeft(2, '0')}:$s';
}

Future<_VideoInfo> _fetchInfo(_Recipe r) async {
  final yt = YoutubeExplode();
  final fallback = r.fallbackDuration ?? '--:--';
  try {
    final v = await yt.videos.get(r.url).timeout(const Duration(seconds: 20));
    final d = v.duration;
    return _VideoInfo(v.author, d == null ? fallback : _formatDuration(d));
  } catch (_) {
    return _VideoInfo('-', fallback);
  } finally {
    yt.close();
  }
}

String? _thumbUrl(String url) {
  final id = VideoId.parseVideoId(url);
  if (id == null) return null;
  return 'https://img.youtube.com/vi/$id/hqdefault.jpg';
}

Future<void> _openVideo(String url) async {
  await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
}

Widget _thumbImage(String url) {
  final src = _thumbUrl(url);
  if (src == null) return const SizedBox.shrink();
  return Image.network(
    src,
    fit: BoxFit.cover,
    width: double.infinity,
    height: double.infinity,
    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
  );
}

class RecipePage extends StatefulWidget {
  const RecipePage({super.key});

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  static const List<String> _chipLabels = [
    'Rich in iron',
    'High protein',
    'Folate',
    'Calcium',
  ];

  int _chipIndex = 0;
  int _navIndex = 3;
  late final List<Future<_VideoInfo>> _infos;

  @override
  void initState() {
    super.initState();
    _infos = _recipes.map((r) => _fetchInfo(r)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recipes',
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: _ink,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Video recipes grouped by the nutrient they help with',
                      style: TextStyle(fontSize: 12, color: _grey),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 34,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          for (int i = 0; i < _chipLabels.length; i++)
                            _Chip(
                              label: _chipLabels[i],
                              selected: _chipIndex == i,
                              onTap: () => setState(() => _chipIndex = i),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _FeaturedVideo(recipe: _recipes[0], info: _infos[0]),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _openVideo(_recipes[0].url),
                      child: Text(
                        _recipes[0].title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: _ink,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    FutureBuilder<_VideoInfo>(
                      future: _infos[0],
                      builder: (context, snap) => Text(
                        snap.data?.channel ?? '...',
                        style: const TextStyle(fontSize: 12, color: _grey),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _VideoItem(
                      recipe: _recipes[1],
                      info: _infos[1],
                      color: _itemColors[0],
                    ),
                    const SizedBox(height: 9),
                    _VideoItem(
                      recipe: _recipes[2],
                      info: _infos[2],
                      color: _itemColors[1],
                    ),
                    const SizedBox(height: 9),
                    _VideoItem(
                      recipe: _recipes[3],
                      info: _infos[3],
                      color: _itemColors[2],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            _BottomNav(
              selectedIndex: _navIndex,
              onTap: (i) => setState(() => _navIndex = i),
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _Chip({
    required this.label,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 7),
        padding: const EdgeInsets.symmetric(horizontal: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? _green : Colors.white,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: selected ? _green : _border),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : _ink,
          ),
        ),
      ),
    );
  }
}

class _FeaturedVideo extends StatelessWidget {
  final _Recipe recipe;
  final Future<_VideoInfo> info;
  const _FeaturedVideo({required this.recipe, required this.info});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openVideo(recipe.url),
      child: Container(
        width: double.infinity,
        height: 170,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: _thumb,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Positioned.fill(child: _thumbImage(recipe.url)),
            Center(
              child: Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: Color(0xFF55554D),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
            Positioned(
              right: 9,
              bottom: 9,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _ink,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: FutureBuilder<_VideoInfo>(
                  future: info,
                  builder: (context, snap) => Text(
                    snap.data?.duration ?? '--:--',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VideoItem extends StatelessWidget {
  final _Recipe recipe;
  final Future<_VideoInfo> info;
  final Color color;
  const _VideoItem({
    required this.recipe,
    required this.info,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _openVideo(recipe.url),
      child: Row(
        children: [
          Container(
            width: 104,
            height: 62,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                Positioned.fill(child: _thumbImage(recipe.url)),
                const Center(
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: Color(0xFFF4F2EC),
                    size: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _ink,
                  ),
                ),
                const SizedBox(height: 3),
                FutureBuilder<_VideoInfo>(
                  future: info,
                  builder: (context, snap) => Text(
                    snap.data?.channel ?? '...',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11, color: _grey),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  const _BottomNav({required this.selectedIndex, required this.onTap});

  static const List<IconData> _icons = [
    Icons.home_outlined,
    Icons.assignment_outlined,
    Icons.show_chart,
    Icons.rice_bowl_outlined,
    Icons.article_outlined,
  ];
  static const List<String> _labels = [
    'Home',
    'Diary',
    'Body',
    'Recipes',
    'News',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE8E5DC))),
      ),
      child: Row(
        children: [
          for (int i = 0; i < _labels.length; i++)
            _NavItem(
              icon: _icons[i],
              label: _labels[i],
              selected: selectedIndex == i,
              onTap: () => onTap(i),
            ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _NavItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? _green : const Color(0xFF3A3A36);
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
