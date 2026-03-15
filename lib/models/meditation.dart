class Meditation {
  final String id;
  final String title;
  final String duration;
  final int index; // 0-based; first 2 are free when not subscribed

  const Meditation({
    required this.id,
    required this.title,
    required this.duration,
    required this.index,
  });
}
