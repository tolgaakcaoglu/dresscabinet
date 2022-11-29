import 'dart:convert';

IyzicoPayment iyzicoPaymentFromJson(String str) =>
    IyzicoPayment.fromJson(json.decode(str));

String iyzicoPaymentToJson(IyzicoPayment data) => json.encode(data.toJson());

class IyzicoPayment {
  IyzicoPayment({
    this.status,
    this.locale,
    this.systemTime,
    this.conversationId,
    this.price,
    this.paidPrice,
    this.installment,
    this.paymentId,
    this.fraudStatus,
    this.merchantCommissionRate,
    this.merchantCommissionRateAmount,
    this.iyziCommissionRateAmount,
    this.iyziCommissionFee,
    this.cardType,
    this.cardAssociation,
    this.cardFamily,
    this.binNumber,
    this.lastFourDigits,
    this.basketId,
    this.currency,
    this.itemTransactions,
    this.authCode,
    this.phase,
    this.hostReference,
  });

  String status;
  String locale;
  int systemTime;
  String conversationId;
  int price;
  double paidPrice;
  int installment;
  String paymentId;
  int fraudStatus;
  int merchantCommissionRate;
  double merchantCommissionRateAmount;
  double iyziCommissionRateAmount;
  double iyziCommissionFee;
  String cardType;
  String cardAssociation;
  String cardFamily;
  String binNumber;
  String lastFourDigits;
  String basketId;
  String currency;
  List<ItemTransaction> itemTransactions;
  String authCode;
  String phase;
  String hostReference;

  factory IyzicoPayment.fromJson(Map<String, dynamic> json) => IyzicoPayment(
        status: json["status"],
        locale: json["locale"],
        systemTime: json["systemTime"],
        conversationId: json["conversationId"],
        price: json["price"],
        paidPrice: double.parse(json["paidPrice"].toString()),
        installment: json["installment"],
        paymentId: json["paymentId"],
        fraudStatus: json["fraudStatus"],
        merchantCommissionRate: json["merchantCommissionRate"],
        merchantCommissionRateAmount:
            json["merchantCommissionRateAmount"].toDouble(),
        iyziCommissionRateAmount: json["iyziCommissionRateAmount"].toDouble(),
        iyziCommissionFee: json["iyziCommissionFee"].toDouble(),
        cardType: json["cardType"],
        cardAssociation: json["cardAssociation"],
        cardFamily: json["cardFamily"],
        binNumber: json["binNumber"],
        lastFourDigits: json["lastFourDigits"],
        basketId: json["basketId"],
        currency: json["currency"],
        itemTransactions: json["itemTransactions"] == null
            ? null
            : List<ItemTransaction>.from(json["itemTransactions"]
                .map((x) => ItemTransaction.fromJson(x))),
        authCode: json["authCode"],
        phase: json["phase"],
        hostReference: json["hostReference"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "locale": locale,
        "systemTime": systemTime,
        "conversationId": conversationId,
        "price": price,
        "paidPrice": paidPrice,
        "installment": installment,
        "paymentId": paymentId,
        "fraudStatus": fraudStatus,
        "merchantCommissionRate": merchantCommissionRate,
        "merchantCommissionRateAmount": merchantCommissionRateAmount,
        "iyziCommissionRateAmount": iyziCommissionRateAmount,
        "iyziCommissionFee": iyziCommissionFee,
        "cardType": cardType,
        "cardAssociation": cardAssociation,
        "cardFamily": cardFamily,
        "binNumber": binNumber,
        "lastFourDigits": lastFourDigits,
        "basketId": basketId,
        "currency": currency,
        "itemTransactions": itemTransactions == null
            ? null
            : List<dynamic>.from(itemTransactions.map((x) => x.toJson())),
        "authCode": authCode,
        "phase": phase,
        "hostReference": hostReference,
      };
}

class ItemTransaction {
  ItemTransaction({
    this.itemId,
    this.paymentTransactionId,
    this.transactionStatus,
    this.price,
    this.paidPrice,
    this.merchantCommissionRate,
    this.merchantCommissionRateAmount,
    this.iyziCommissionRateAmount,
    this.iyziCommissionFee,
    this.blockageRate,
    this.blockageRateAmountMerchant,
    this.blockageRateAmountSubMerchant,
    this.blockageResolvedDate,
    this.subMerchantPrice,
    this.subMerchantPayoutRate,
    this.subMerchantPayoutAmount,
    this.merchantPayoutAmount,
    this.convertedPayout,
  });

  String itemId;
  String paymentTransactionId;
  int transactionStatus;
  double price;
  double paidPrice;
  int merchantCommissionRate;
  double merchantCommissionRateAmount;
  double iyziCommissionRateAmount;
  double iyziCommissionFee;
  int blockageRate;
  int blockageRateAmountMerchant;
  int blockageRateAmountSubMerchant;
  DateTime blockageResolvedDate;
  int subMerchantPrice;
  int subMerchantPayoutRate;
  int subMerchantPayoutAmount;
  double merchantPayoutAmount;
  ConvertedPayout convertedPayout;

  factory ItemTransaction.fromJson(Map<String, dynamic> json) =>
      ItemTransaction(
        itemId: json["itemId"],
        paymentTransactionId: json["paymentTransactionId"],
        transactionStatus: json["transactionStatus"],
        price: json["price"].toDouble(),
        paidPrice: json["paidPrice"].toDouble(),
        merchantCommissionRate: json["merchantCommissionRate"],
        merchantCommissionRateAmount:
            json["merchantCommissionRateAmount"].toDouble(),
        iyziCommissionRateAmount: json["iyziCommissionRateAmount"].toDouble(),
        iyziCommissionFee: json["iyziCommissionFee"].toDouble(),
        blockageRate: json["blockageRate"],
        blockageRateAmountMerchant: json["blockageRateAmountMerchant"],
        blockageRateAmountSubMerchant: json["blockageRateAmountSubMerchant"],
        blockageResolvedDate: json["blockageResolvedDate"] == null
            ? null
            : DateTime.parse(json["blockageResolvedDate"]),
        subMerchantPrice: json["subMerchantPrice"],
        subMerchantPayoutRate: json["subMerchantPayoutRate"],
        subMerchantPayoutAmount: json["subMerchantPayoutAmount"],
        merchantPayoutAmount: json["merchantPayoutAmount"].toDouble(),
        convertedPayout: json["convertedPayout"] == null
            ? null
            : ConvertedPayout.fromJson(json["convertedPayout"]),
      );

  Map<String, dynamic> toJson() => {
        "itemId": itemId,
        "paymentTransactionId": paymentTransactionId,
        "transactionStatus": transactionStatus,
        "price": price,
        "paidPrice": paidPrice,
        "merchantCommissionRate": merchantCommissionRate,
        "merchantCommissionRateAmount": merchantCommissionRateAmount,
        "iyziCommissionRateAmount": iyziCommissionRateAmount,
        "iyziCommissionFee": iyziCommissionFee,
        "blockageRate": blockageRate,
        "blockageRateAmountMerchant": blockageRateAmountMerchant,
        "blockageRateAmountSubMerchant": blockageRateAmountSubMerchant,
        "blockageResolvedDate": blockageResolvedDate.toIso8601String(),
        "subMerchantPrice": subMerchantPrice,
        "subMerchantPayoutRate": subMerchantPayoutRate,
        "subMerchantPayoutAmount": subMerchantPayoutAmount,
        "merchantPayoutAmount": merchantPayoutAmount,
        "convertedPayout": convertedPayout.toJson(),
      };
}

class ConvertedPayout {
  ConvertedPayout({
    this.paidPrice,
    this.iyziCommissionRateAmount,
    this.iyziCommissionFee,
    this.blockageRateAmountMerchant,
    this.blockageRateAmountSubMerchant,
    this.subMerchantPayoutAmount,
    this.merchantPayoutAmount,
    this.iyziConversionRate,
    this.iyziConversionRateAmount,
    this.currency,
  });

  double paidPrice;
  double iyziCommissionRateAmount;
  double iyziCommissionFee;
  int blockageRateAmountMerchant;
  int blockageRateAmountSubMerchant;
  int subMerchantPayoutAmount;
  double merchantPayoutAmount;
  int iyziConversionRate;
  int iyziConversionRateAmount;
  String currency;

  factory ConvertedPayout.fromJson(Map<String, dynamic> json) =>
      ConvertedPayout(
        paidPrice: json["paidPrice"].toDouble(),
        iyziCommissionRateAmount: json["iyziCommissionRateAmount"].toDouble(),
        iyziCommissionFee: json["iyziCommissionFee"].toDouble(),
        blockageRateAmountMerchant: json["blockageRateAmountMerchant"],
        blockageRateAmountSubMerchant: json["blockageRateAmountSubMerchant"],
        subMerchantPayoutAmount: json["subMerchantPayoutAmount"],
        merchantPayoutAmount: json["merchantPayoutAmount"].toDouble(),
        iyziConversionRate: json["iyziConversionRate"],
        iyziConversionRateAmount: json["iyziConversionRateAmount"],
        currency: json["currency"],
      );

  Map<String, dynamic> toJson() => {
        "paidPrice": paidPrice,
        "iyziCommissionRateAmount": iyziCommissionRateAmount,
        "iyziCommissionFee": iyziCommissionFee,
        "blockageRateAmountMerchant": blockageRateAmountMerchant,
        "blockageRateAmountSubMerchant": blockageRateAmountSubMerchant,
        "subMerchantPayoutAmount": subMerchantPayoutAmount,
        "merchantPayoutAmount": merchantPayoutAmount,
        "iyziConversionRate": iyziConversionRate,
        "iyziConversionRateAmount": iyziConversionRateAmount,
        "currency": currency,
      };
}
