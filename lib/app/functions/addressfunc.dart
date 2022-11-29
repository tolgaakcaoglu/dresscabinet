import 'package:dresscabinet/app/modals/districtmodal.dart';
import 'package:dresscabinet/app/modals/provincemodal.dart';

import 'jsonfunc.dart';

class AddressFunc {
  static Future<List<Province>> getProvinces() async {
    List json = await JsonFunctions.getProvincesList();
    List<Province> list = [];
    for (Map item in json) {
      var pr = Province.build(item);
      if (pr.countryId == 223) {
        list.add(pr);
      }
    }

    return list;
  }

  static Future<List<District>> getDistricts(int province) async {
    List json = await JsonFunctions.getDistrictList();
    List<District> list = [];
    for (Map item in json) {
      var dis = District.build(item);
      if (dis.provinceId == province) {
        list.add(dis);
      }
    }

    return list;
  }

  static Future<Province> getProvinceWithId(int id) async {
    List json = await JsonFunctions.getProvincesList();
    Province province;

    for (Map item in json) {
      var pr = Province.build(item);
      if (pr.id == id) {
        province = pr;
      }
    }

    return province;
  }

  static Future<District> getDistrictWithId(int id) async {
    List json = await JsonFunctions.getDistrictList();
    District district;

    for (Map item in json) {
      var dis = District.build(item);
      if (dis.id == id) {
        district = dis;
      }
    }

    return district;
  }
}
