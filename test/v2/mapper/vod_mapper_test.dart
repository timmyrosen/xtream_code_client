import 'package:test/test.dart';
import 'package:xtream_code_client/src/v2/core/parse_context.dart';
import 'package:xtream_code_client/src/v2/mapper/vod_mapper.dart';

void main() {
  group('VodMapper TMDB IDs', () {
    test('tmdb string from getVods response is parsed', () {
      final context = ParseContext();
      final item = VodMapper.itemFromMap(
        <String, dynamic>{'tmdb': '1101644'},
        context,
        r'$.vods[0]',
      );

      expect(item.tmdbId, 1101644);
      expect(context.warnings, isEmpty);
    });

    test('canonical and camel-case aliases are accepted', () {
      final canonical = VodMapper.itemFromMap(
        <String, dynamic>{'tmdb_id': 550},
        ParseContext(),
        r'$.vods[0]',
      );
      final camelCase = VodMapper.itemFromMap(
        <String, dynamic>{'tmdbId': '551'},
        ParseContext(),
        r'$.vods[1]',
      );

      expect(canonical.tmdbId, 550);
      expect(camelCase.tmdbId, 551);
    });

    test('missing and invalid IDs remain null', () {
      final missingContext = ParseContext();
      final missing = VodMapper.itemFromMap(
        <String, dynamic>{},
        missingContext,
        r'$.vods[0]',
      );
      final invalidContext = ParseContext();
      final invalid = VodMapper.itemFromMap(
        <String, dynamic>{'tmdb': 'not-an-id'},
        invalidContext,
        r'$.vods[1]',
      );

      expect(missing.tmdbId, isNull);
      expect(missingContext.warnings, isEmpty);
      expect(invalid.tmdbId, isNull);
      expect(invalidContext.warnings, isNotEmpty);
    });
  });
}
