// lib/features/clibo_ai/data/models/chat_request_model.dart

class ChatRequestModel {
  final String message;
  final String? base64Media;
  final String sessionId;

  ChatRequestModel({
    required this.message,
    this.base64Media,
    required this.sessionId,
  });

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'base64Media': base64Media,
      'sessionId': sessionId,
    };
  }
}
