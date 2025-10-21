class Category {
  final String id;
  final String name;
  final String icon; // bisa string emoji atau nama asset

  Category({
    required this.id,
    required this.name,
    this.icon = '📌',
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String? ?? '📌',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
    };
  }
}
