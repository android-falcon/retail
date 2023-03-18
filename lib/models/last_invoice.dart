class LastInvoice {
  int invoiceNo;
  double total;

  LastInvoice({
    required this.invoiceNo,
    required this.total,
  });

  factory LastInvoice.fromJson(Map<String, dynamic> json) => LastInvoice(
        invoiceNo: json["invoiceNo"] ?? 0,
        total: json["total"]?.toDouble() ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "invoiceNo": invoiceNo,
        "total": total,
      };
}
