import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:xtream_code_client/xtream_code_client.dart';

class MockHttpClient extends Mock implements Client {}

void main() {
  group('XtreamCodeClient stream URLs', () {
    late XtreamCodeClient client;

    setUp(() {
      client = XtreamCodeClient(
        'http://example.com/player_api.php?username=user&password=pass',
        'http://example.com/user/pass',
        'http://example.com/live/user/pass',
        'http://example.com/movie/user/pass',
        'http://example.com/series/user/pass',
        MockHttpClient(),
        'player_api.php',
      );
    });

    test('generates live streams under the /live route', () {
      final url = client.streamUrl(606227, ['ts']);

      expect(url, 'http://example.com/live/user/pass/606227.ts');
    });
  });
}
