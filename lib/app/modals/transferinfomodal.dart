class BankTransfer {
  final int id;
  final String bank, accountName, branchCode, bankNo, name, iban;

  BankTransfer(
      {this.id,
      this.bank,
      this.accountName,
      this.branchCode,
      this.bankNo,
      this.name,
      this.iban});

  factory BankTransfer.build(Map json) {
    return BankTransfer(
      id: int.parse(json["id"].toString()),
      bank: json["banka"],
      accountName: json["hesap_adi"],
      branchCode: json["sube_kodu"],
      bankNo: json["hesap_no"],
      name: json["hesap_sahibi"],
      iban: json["iban"],
    );
  }
}
