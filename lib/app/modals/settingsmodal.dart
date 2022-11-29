class ConstSettings {
  final bool priceAlert, giftPackage, giveback;
  final double giftPackagePrice, shippingPay, freeShippingLimit;
  final int giveBackTimer;

  ConstSettings(
      {this.priceAlert,
      this.giftPackage,
      this.giveback,
      this.giftPackagePrice,
      this.shippingPay,
      this.freeShippingLimit,
      this.giveBackTimer});

  factory ConstSettings.build(Map json) {
    return ConstSettings(
      priceAlert: json["urun_fiyat_alarmi"] == "TRUE",
      giftPackage: json["hediye_paketi"]["onay"] == "TRUE",
      giftPackagePrice: double.parse(json["hediye_paketi"]["tutar"].toString()),
      giveback: json["iptal_iade"]["onay"] == "TRUE",
      giveBackTimer: int.parse(json["iptal_iade"]["sure"].toString()),
      shippingPay: double.parse(json["kargo"]["sabit_kargo_ucreti"].toString()),
      freeShippingLimit:
          double.parse(json["kargo"]["ucretsiz_kargo_limiti"].toString()),
    );
  }
}
