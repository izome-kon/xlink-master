class Wallet {
  Wallet({
    this.id,
    this.required,
    this.paidUp,
    this.userId,
  });

  int id;
  double required;
  int paidUp;
  int userId;

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
        id: json["id"],
        required: json["required"].toDouble(),
        paidUp: json["paid_up"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "required": required,
        "paid_up": paidUp,
        "user_id": userId,
      };
}
