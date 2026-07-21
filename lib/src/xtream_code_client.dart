import 'package:http/http.dart';
import 'package:xtream_code_client/src/http/http_client_factory.dart'
    as http_factory;
import 'package:xtream_code_client/src/xtream_client.dart';

/// Legacy singleton wrapper. Prefer constructing `XtreamClient` directly.
@Deprecated('Use XtreamClient from src/v2/client/xtream_client.dart')
class XtreamCode {
  XtreamCode._();

  /// Returns the initialized singleton instance.
  ///
  /// Call [initialize] first.
  static XtreamCode get instance {
    assert(
      _instance._initialized,
      '''
      You must initialize the XtreamCode instance before calling
      XtreamCode.instance
      ''',
    );
    return _instance;
  }

  /// Initializes the legacy singleton and creates [client].
  ///
  /// Deprecated migration path:
  /// prefer constructing `XtreamClient` directly.
  static Future<XtreamCode> initialize({
    required String url,
    required String username,
    required String password,
    required String port,
    String path = 'player_api.php',
    Map<String, String>? parameters,
    Client? httpClient,
    bool? debug,
  }) async {
    assert(
      !_instance._initialized,
      'This instance is already initialized',
    );

    _instance
      .._init(
        url,
        port,
        username,
        password,
        httpClient,
        path,
        parameters,
      )
      .._debugEnable = debug ?? false
      .._log('***** XtreamCode init completed $_instance');

    return _instance;
  }

  static final XtreamCode _instance = XtreamCode._();

  bool _initialized = false;
  bool _debugEnable = false;

  /// The legacy client delegate.
  late XtreamCodeClient client;

  late Client? _httpClient;

  /// Disposes the underlying HTTP client and resets singleton state.
  Future<void> dispose() async {
    _httpClient?.close();
    _httpClient = null;
    _initialized = false;
  }

  void _init(
    String url,
    String port,
    String username,
    String password,
    Client? httpClient,
    String path,
    Map<String, String>? parameters,
  ) {
    _httpClient = httpClient ?? http_factory.httpClient();
    client = XtreamCodeClient(
      _createBaseUrl(url, path, port, username, password, parameters),
      _createStreamUrl(url, port, username, password),
      _createMovieUrl(url, port, username, password),
      _createSeriesUrl(url, port, username, password),
      _httpClient!,
    );
    _initialized = true;
  }

  void _log(String msg, [StackTrace? stackTrace]) {
    if (_debugEnable) {
      // ignore: avoid_print
      print(msg);
      if (stackTrace != null) {
        // ignore: avoid_print
        print(stackTrace);
      }
    }
  }

  String _createBaseUrl(
    String url,
    String path,
    String port,
    String username,
    String password,
    Map<String, String>? parameters,
  ) {
    var uri = '$url:$port/$path?username=$username&password=$password';

    if (parameters != null && parameters.isNotEmpty) {
      final queryParameters = parameters.entries
          .where((e) => e.key.isNotEmpty && e.value.isNotEmpty)
          .where((e) => e.key != 'username' && e.key != 'password')
          .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
          .join('&');
      uri += '&$queryParameters';
    }
    assert(
      Uri.parse(uri).isAbsolute,
      '''
      The provided combination of url, port, username and password is not a
      valid uri
      ''',
    );
    return uri;
  }

  String _createStreamUrl(
    String url,
    String? port,
    String username,
    String password,
  ) {
    final portPart = (port != null && port.isNotEmpty) ? ':$port' : '';
    final uri = '$url$portPart/live/$username/$password';
    assert(
      Uri.parse(uri).isAbsolute,
      '''
      The provided combination of url, port, username and password is not a
      valid uri
      ''',
    );
    return uri;
  }

  String _createMovieUrl(
    String url,
    String? port,
    String username,
    String password,
  ) {
    final portPart = (port != null && port.isNotEmpty) ? ':$port' : '';
    final uri = '$url$portPart/movie/$username/$password';
    assert(
      Uri.parse(uri).isAbsolute,
      '''
      The provided combination of url, port, username and password is not a
      valid uri
      ''',
    );
    return uri;
  }

  String _createSeriesUrl(
    String url,
    String? port,
    String username,
    String password,
  ) {
    final portPart = (port != null && port.isNotEmpty) ? ':$port' : '';
    final uri = '$url$portPart/series/$username/$password';
    assert(
      Uri.parse(uri).isAbsolute,
      '''
      The provided combination of url, port, username and password is not a
      valid uri
      ''',
    );
    return uri;
  }
}
