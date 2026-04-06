import 'package:flutter/rendering.dart';
import 'package:xml/xml.dart';
import 'package:xtream_code_client/src/model/epg/epg.dart';

/// Parses EPG (Electronic Program Guide) data from XML format.
class EpgParser {
  /// Parses the given XML string and returns a [EPG] object.
  ///
  /// This method uses DOM parsing which loads the entire XML into memory.
  EPG parse(String xmlString, {bool includeChannels = false}) {
    final xmlStopwatch = Stopwatch()..start();
    final document = XmlDocument.parse(xmlString);
    xmlStopwatch.stop();
    debugPrint('EPG XML parsed in ${xmlStopwatch.elapsedMilliseconds} ms');

    final epgXml = document.rootElement;
    final fromXmlStopwatch = Stopwatch()..start();
    final epg = EPG.fromXmlElement(epgXml, includeChannels: includeChannels);
    fromXmlStopwatch.stop();
    debugPrint(
      'EPG fromXmlElement executed in ${fromXmlStopwatch.elapsedMilliseconds} ms',
    );
    return epg;
  }
}
