import 'package:test/test.dart';
import 'package:xtream_code_client/src/v2/core/parse_context.dart';
import 'package:xtream_code_client/src/v2/mapper/series_mapper.dart';

void main() {
  group('SeriesMapper TMDB IDs', () {
    test('integer and string IDs are parsed for list items and details', () {
      final itemContext = ParseContext();
      final item = SeriesMapper.itemFromMap(
        <String, dynamic>{'tmdb_id': 1399},
        itemContext,
        r'$.series[0]',
      );
      final detailsContext = ParseContext();
      final details = SeriesMapper.infoFromMap(
        <String, dynamic>{
          'seasons': <dynamic>[],
          'info': <String, dynamic>{'tmdb_id': '1399'},
          'episodes': <String, dynamic>{},
        },
        detailsContext,
        r'$.series',
      );

      expect(item.tmdbId, 1399);
      expect(details.info.tmdbId, 1399);
      expect(itemContext.warnings, isEmpty);
      expect(detailsContext.warnings, isEmpty);
    });

    test('camel-case alias is accepted', () {
      final context = ParseContext();
      final item = SeriesMapper.itemFromMap(
        <String, dynamic>{'tmdbId': '456'},
        context,
        r'$.series[0]',
      );

      expect(item.tmdbId, 456);
      expect(context.warnings, isEmpty);
    });

    test('tmdb alias from getSeries response is accepted', () {
      final context = ParseContext();
      final details = SeriesMapper.infoFromMap(
        <String, dynamic>{
          'seasons': <dynamic>[],
          'info': <String, dynamic>{'tmdb': '332679'},
          'episodes': <String, dynamic>{},
        },
        context,
        r'$.series',
      );

      expect(details.info.tmdbId, 332679);
      expect(context.warnings, isEmpty);
    });

    test('missing and invalid IDs remain null', () {
      final missingContext = ParseContext();
      final missing = SeriesMapper.itemFromMap(
        <String, dynamic>{},
        missingContext,
        r'$.series[0]',
      );
      final invalidContext = ParseContext();
      final invalid = SeriesMapper.itemFromMap(
        <String, dynamic>{'tmdb_id': 'not-an-id'},
        invalidContext,
        r'$.series[0]',
      );

      expect(missing.tmdbId, isNull);
      expect(missingContext.warnings, isEmpty);
      expect(invalid.tmdbId, isNull);
      expect(invalidContext.warnings, isNotEmpty);
    });
  });
}
