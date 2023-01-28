class ApiResponse<T> {
  ApiResponse({
    required this.code,
    required this.message,
    required this.response,
    required this.result,
  });

  int code;
  String message;
  String response;
  List<T> result;

  factory ApiResponse.fromJson(Map<String, dynamic> json, Function? fromJsonModel) => ApiResponse(
        code: json["code"] ?? 500,
        message: json["message"] ?? "",
        response: json["response"] ?? "",
        result: json["result"] == null
            ? []
            : fromJsonModel == null
                ? json["result"]
                : List<T>.from(json["result"].map((x) => fromJsonModel(x))),
      );

  factory ApiResponse.fromError(int code, String message) => ApiResponse(
        code: code,
        message: message,
        response: "",
        result: [],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "response": response,
        "result": List<dynamic>.from(result.map((x) => x)),
      };
}
