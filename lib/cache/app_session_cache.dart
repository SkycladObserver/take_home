/// a pseudo cache. Only persists while app is awake.
class AppSessionCache {
  AppSessionCache._() : map = {};

  Map<String, dynamic> map;

  static AppSessionCache _instance = AppSessionCache._();

  static AppSessionCache get instance => _instance;

  void write({required String key, dynamic value}) {
    map[key] = value;
  }

  void erase({required String key}) {
    map.remove(key);
  }

  dynamic read({required String key}) {
    return map[key];
  }
}
