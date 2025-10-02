class Category {
  final String id;
  final String name;
  final String icon; // emoji atau string

  Category({
    required this.id,
    required this.name,
    required this.icon,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? 'Unknown',
      icon: map['icon']?.toString() ?? '',
    );
  }
}