import 'package:dresscabinet/app/functions/jsonfunc.dart';
import 'package:dresscabinet/app/modals/categorymodal.dart';

class CategoryFunc {
  static Future getCategories() async {
    List json = await JsonFunctions.getCategories();
    if (json != null) {
      List<Category> c = [];
      for (Map<String, dynamic> data in json) {
        c.add(Category.fromJson(data));
      }

      c.sort((a, b) => a.order.compareTo(b.order));

      return c;
    }
  }

  static List getMainCategories(List allCategories) {
    List list = [];

    for (Category l in allCategories) {
      if (l.parentID == 0) {
        list.add(l);
      }
    }

    list.sort((a, b) => a.order.compareTo(b.order));
    return list;
  }

  static List getSubCategories(List allCategories, int selectedCategoryIndex) {
    List<Category> list = [];
    for (Category cat in allCategories) {
      if (cat.parentID == selectedCategoryIndex) list.add(cat);
    }

    list.sort((a, b) => a.order.compareTo(b.order));

    return list;
  }
}
