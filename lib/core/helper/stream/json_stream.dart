import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

abstract class AbstractJsonStream {
  Stream<Map<String, dynamic>> jsonDecodeHandler(
      {required Stream<Uint8List> stream, required String startWith});
}

class JsonStream extends AbstractJsonStream {
  @override
  Stream<Map<String, dynamic>> jsonDecodeHandler(
      {required Stream<Uint8List> stream, required String startWith}) async* {
    await for (var data in stream
        .transform(_utf8DecoderTransformer())
        .transform(const LineSplitter())) {
      if (data.startsWith(startWith)) {
        yield jsonDecode(data.replaceFirst(startWith, ''));
      }
    }
  }

  StreamTransformer<Uint8List, String> _utf8DecoderTransformer() {
    return StreamTransformer<Uint8List, String>.fromHandlers(
      handleData: (Uint8List data, EventSink<String> sink) async {
        sink.add(utf8.decoder.convert(data));
      },
    );
  }
}
