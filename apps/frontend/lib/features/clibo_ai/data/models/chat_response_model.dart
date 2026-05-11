// lib/features/clibo_ai/data/models/chat_response_model.dart

class ChatResponseModel {
  final String aiData;
  final String status;
  final Map<String, dynamic> metadata;

  ChatResponseModel({
    required this.aiData,
    required this.status,
    required this.metadata,
  });

  factory ChatResponseModel.fromJson(Map<String, dynamic> json) {
    return ChatResponseModel(
      aiData: json['aiData'] ?? '',
      status: json['status'] ?? 'unknown',
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }
}
