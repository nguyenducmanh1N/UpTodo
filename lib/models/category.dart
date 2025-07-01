class Category {
  final String id;
  final String name;
  final String color;
  final String? icon;

  Category({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
  });

  @override
  String toString() {
    return 'Category{id: $id, name: $name, color: $color, icon: $icon}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'icon': icon,
    };
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      color: json['color'] as String,
      icon: json['icon'] as String?,
    );
  }
}
