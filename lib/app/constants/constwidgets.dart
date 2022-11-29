import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ConstWidgets {
  static loadingWidget(bool isDark) => Center(
      child: isDark
          ? Container(
              constraints: const BoxConstraints(maxWidth: 84.0),
              child: Image.asset('assets/images/loading_dark.gif'))
          : Container(
              constraints: const BoxConstraints(maxHeight: 120.0),
              child: Image.asset('assets/images/loading_light.gif')));

  static viewImage(String image) => CachedNetworkImage(
        imageUrl: image,
        fit: BoxFit.cover,
        fadeInDuration: Duration.zero,
        filterQuality: FilterQuality.low,
        fadeInCurve: Curves.easeInCirc,
        fadeOutCurve: Curves.easeOutCirc,
        errorWidget: (context, url, error) =>
            const Center(child: Text('Bağlantınızı kontrol edin')),
        progressIndicatorBuilder: (context, url, progress) => Image.asset(
          'assets/images/no_image.jpg',
          fit: BoxFit.cover,
        ),
      );

  static textField(bool isDark,
          {TextEditingController controller,
          Widget prefix,
          String label,
          String hint,
          bool enabled,
          bool obscureText,
          TextInputType type,
          void Function(String) onChang}) =>
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: TextField(
          controller: controller,
          enabled: enabled ?? true,
          obscureText: obscureText ?? false,
          style: const TextStyle(fontSize: 16.0),
          keyboardType: type ?? TextInputType.text,
          decoration: InputDecoration(
            labelStyle: TextStyle(color: isDark ? Colors.white : Colors.black),
            labelText: label,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none),
            filled: true,
            fillColor: isDark ? Colors.white10 : Colors.white,
            prefixIcon: prefix != null
                ? SizedBox(
                    width: 24.0,
                    height: 24.0,
                    child: Center(child: prefix),
                  )
                : null,
            hintText: hint,
          ),
          onChanged: onChang,
        ),
      );
}
