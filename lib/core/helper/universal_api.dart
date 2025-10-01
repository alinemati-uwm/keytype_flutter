import 'dart:async';
import 'dart:typed_data';
import 'package:keytype/core/helper/stream/json_stream.dart';
import '../../ui_imports.dart';
import '../init/dependency_injection.dart';
import '../models/chat_bot_model/chat_bot_conversation_res_model.dart';
import '../models/chat_bot_model/features_request_model.dart';
import '../network/ai_writer/ai_writer_api_calls.dart';

class UniversalApi {
  static final _aiWriterApiCalls = getIt<AIWriterApiCalls>();
  static final _jsonStream = JsonStream();

  static Future<void> generateAi({
    required FeaturesRequestModel data,
    required void Function(String message) onNewMessage,
    required Function onDone,
    Function? onError,
  }) async {
    final result = await _aiWriterApiCalls.generateAIWriter(data: data);
    result.fold(
      (left) {
        debugPrint(left.message);
      },
      (data) {
        _handleStream(
            stream: data,
            onNewMessage: onNewMessage,
            onDone: onDone,
            onError: onError);
      },
    );
  }

  static void _handleStream({
    required Stream<Uint8List> stream,
    required void Function(String message) onNewMessage,
    required Function onDone,
    Function? onError,
  }) {
    String buffer = '';
    String completeMsg = '';
    _jsonStream
        .jsonDecodeHandler(
      stream: stream,
      startWith: 'data: ',
    )
        .listen(
      (json) {
        final data = ChatBotConversationResModel.fromJson(json);
        if (data.content != null) {
          if (data.content?.isNotEmpty ?? false) {
            buffer += data.content!;
            completeMsg += buffer;
            buffer = '';
            onNewMessage(completeMsg);
          }
        }
      },
      onError: (error) {
        // _removeItemFromList(id: id);
        onError?.call();
      },
      onDone: () {
        onDone.call();
      },
    );
  }
}
