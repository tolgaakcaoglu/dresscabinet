import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ri.dart';

List<BottomNavigationBarItem> bottomItems(bool isDark) => [
      BottomNavigationBarItem(
          icon: Iconify(
            Ri.home_3_line,
            color: isDark ? Colors.white : Colors.black,
          ),
          activeIcon: Iconify(
            Ri.home_3_fill,
            color: isDark ? Colors.white : Colors.black,
          ),
          label: 'Anasayfa'),
      BottomNavigationBarItem(
          icon: Iconify(
            Ri.list_check_2,
            color: isDark ? Colors.white : Colors.black,
          ),
          activeIcon: Iconify(
            Ri.list_check_2,
            color: isDark ? Colors.white : Colors.black,
          ),
          label: 'Kategoriler'),
      BottomNavigationBarItem(
          icon: Iconify(
            Ri.shopping_cart_line,
            color: isDark ? Colors.white : Colors.black,
          ),
          activeIcon: Iconify(
            Ri.shopping_cart_fill,
            color: isDark ? Colors.white : Colors.black,
          ),
          label: 'Sepetim'),
      BottomNavigationBarItem(
          icon: Iconify(
            Ri.heart_2_line,
            color: isDark ? Colors.white : Colors.black,
          ),
          activeIcon: Iconify(
            Ri.heart_2_fill,
            color: isDark ? Colors.white : Colors.black,
          ),
          label: 'Favorilerim'),
      BottomNavigationBarItem(
          icon: Iconify(
            Ri.user_3_line,
            color: isDark ? Colors.white : Colors.black,
          ),
          activeIcon: Iconify(
            Ri.user_3_fill,
            color: isDark ? Colors.white : Colors.black,
          ),
          label: 'Hesabım'),
    ];
