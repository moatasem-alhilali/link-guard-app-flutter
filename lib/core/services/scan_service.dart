import 'package:dio/dio.dart';
import '../config/app_config.dart';

class ApiException implements Exception {
  final String message;
  final bool isNetwork;

  const ApiException(this.message, {this.isNetwork = false});

  @override
  String toString() => message;
}

Dio _buildDio() {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onError: (error, handler) {
        if (error.type == DioExceptionType.connectionError ||
            error.type == DioExceptionType.receiveTimeout ||
            error.type == DioExceptionType.sendTimeout ||
            error.type == DioExceptionType.connectionTimeout) {
          handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              error: ApiException('error_network', isNetwork: true),
              type: error.type,
            ),
          );
        } else {
          handler.next(error);
        }
      },
    ),
  );

  return dio;
}

final _dio = _buildDio();

// ─────────────────────────────────────────────────────────
//  Google Safe Browsing
// ─────────────────────────────────────────────────────────

const _googleEndpoint =
    'https://safebrowsing.googleapis.com/v4/threatMatches:find';

// Key is injected at build time via --dart-define-from-file=config.json
// Never stored in source code or committed to git.
String get _googleApiKey => AppConfig.googleSafeBrowsingKey;

const _maliciousThreats = {'MALWARE', 'POTENTIALLY_HARMFUL_APPLICATION'};
const _suspiciousThreats = {'SOCIAL_ENGINEERING', 'UNWANTED_SOFTWARE'};

Future<Map<String, dynamic>> checkWithGoogle(String url) async {
  try {
    final response = await _dio.post<Map<String, dynamic>>(
      '$_googleEndpoint?key=$_googleApiKey',
      data: {
        'client': {'clientId': 'linkguard-mobile', 'clientVersion': '1.0.0'},
        'threatInfo': {
          'threatTypes': [
            'MALWARE',
            'SOCIAL_ENGINEERING',
            'UNWANTED_SOFTWARE',
            'POTENTIALLY_HARMFUL_APPLICATION',
          ],
          'platformTypes': ['ANY_PLATFORM'],
          'threatEntryTypes': ['URL'],
          'threatEntries': [
            {'url': url},
          ],
        },
      },
    );

    final data = response.data ?? {};
    final matches = (data['matches'] as List?)?.cast<Map>() ?? [];

    if (matches.isEmpty) {
      return {
        'verdict': 'SAFE',
        'provider': 'Google Safe Browsing',
        'reason_key': 'result_safe_desc',
        'score': '0',
      };
    }

    final threats = matches
        .map((m) => m['threatType']?.toString() ?? 'UNKNOWN')
        .toSet();

    final hasMalicious = threats.any(_maliciousThreats.contains);
    final hasSuspicious = threats.any(_suspiciousThreats.contains);

    return {
      'verdict': hasMalicious
          ? 'MALICIOUS'
          : (hasSuspicious ? 'SUSPICIOUS' : 'SUSPICIOUS'),
      'provider': 'Google Safe Browsing',
      'reason_key': hasMalicious
          ? 'result_malicious_desc'
          : 'result_suspicious_desc',
      'score': matches.length.toString(),
    };
  } on DioException catch (e) {
    final inner = e.error;
    if (inner is ApiException && inner.isNetwork) {
      throw ApiException('error_network', isNetwork: true);
    }
    throw ApiException('error_api');
  }
}

// ─────────────────────────────────────────────────────────
//  VirusTotal
// ─────────────────────────────────────────────────────────

const _vtBase = 'https://www.virustotal.com/api/v3';

// Key is injected at build time via --dart-define-from-file=config.json
String get _vtApiKey => AppConfig.virusTotalApiKey;

Future<Map<String, dynamic>> checkWithVirusTotal(String url) async {
  try {
    // Step 1 – Submit URL
    final submitResp = await _dio.post<Map<String, dynamic>>(
      '$_vtBase/urls',
      data: 'url=${Uri.encodeComponent(url)}',
      options: Options(
        headers: {
          'x-apikey': _vtApiKey,
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      ),
    );

    final analysisId = submitResp.data?['data']?['id'] as String?;
    if (analysisId == null) {
      throw ApiException('error_api');
    }

    // Step 2 – Poll for result (max 3 attempts)
    Map<String, dynamic>? attrs;
    for (int i = 0; i < 3; i++) {
      await Future.delayed(const Duration(seconds: 2));
      final analysisResp = await _dio.get<Map<String, dynamic>>(
        '$_vtBase/analyses/$analysisId',
        options: Options(headers: {'x-apikey': _vtApiKey}),
      );
      final status = analysisResp.data?['data']?['attributes']?['status'];
      if (status == 'completed') {
        attrs =
            analysisResp.data!['data']['attributes'] as Map<String, dynamic>;
        break;
      }
    }

    final stats = attrs?['stats'] as Map? ?? {};
    final malicious = (stats['malicious'] as num?)?.toInt() ?? 0;
    final suspicious = (stats['suspicious'] as num?)?.toInt() ?? 0;
    final harmless = (stats['harmless'] as num?)?.toInt() ?? 0;
    final undetected = (stats['undetected'] as num?)?.toInt() ?? 0;
    final total = malicious + suspicious + harmless + undetected;

    if (malicious > 0) {
      return {
        'verdict': 'MALICIOUS',
        'provider': 'VirusTotal',
        'reason_key': 'result_malicious_desc',
        'score': '$malicious/$total',
      };
    } else if (suspicious > 0) {
      return {
        'verdict': 'SUSPICIOUS',
        'provider': 'VirusTotal',
        'reason_key': 'result_suspicious_desc',
        'score': '$suspicious/$total',
      };
    }

    return {
      'verdict': 'SAFE',
      'provider': 'VirusTotal',
      'reason_key': 'result_safe_desc',
      'score': '0/$total',
    };
  } on DioException catch (e) {
    final inner = e.error;
    if (inner is ApiException && inner.isNetwork) {
      throw ApiException('error_network', isNetwork: true);
    }
    throw ApiException('error_api');
  }
}
