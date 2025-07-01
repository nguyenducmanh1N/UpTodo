import 'dart:convert';

abstract class BaseService<T> {
  // late final String key;
  // BaseService(this.key);

  // Future<List<Map<String, dynamic>>> getAll() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final jsonString = prefs.getString(key);
  //   if (jsonString != null) {
  //     final List<dynamic> decoded = jsonDecode(jsonString);
  //     return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
  //   }
  //   return [];
  // }

  // Future<Map<String, dynamic>?> getById(String id) async {
  //   final list = await getAll();
  //   final result = list.firstWhere((item) => item['id'] == id, orElse: () => <String, dynamic>{});
  //   return result.isNotEmpty ? result : null;
  // }

  // Future<void> add(Map<String, dynamic> object) async {
  //   final list = await getAll();
  //   list.add(object);
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString(key, jsonEncode(list));
  // }

  // Future<void> update(String id, Map<String, dynamic> updatedObject) async {
  //   final list = await getAll();
  //   final index = list.indexWhere((item) => item['id'] == id);
  //   if (index != -1) {
  //     list[index] = updatedObject;
  //     final prefs = await SharedPreferences.getInstance();
  //     await prefs.setString(key, jsonEncode(list));
  //   }
  // }

  // Future<void> delete(String id) async {
  //   final list = await getAll();
  //   list.removeWhere((item) => item['id'] == id);
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString(key, jsonEncode(list));
  // }
}
