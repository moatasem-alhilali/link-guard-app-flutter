class UrlValidationResult {
  final bool isValid;
  final String? normalizedUrl;
  final String? errorKey; // Translation key

  const UrlValidationResult._({
    required this.isValid,
    this.normalizedUrl,
    this.errorKey,
  });

  factory UrlValidationResult.valid(String url) =>
      UrlValidationResult._(isValid: true, normalizedUrl: url);

  factory UrlValidationResult.invalid(String errorKey) =>
      UrlValidationResult._(isValid: false, errorKey: errorKey);
}

class UrlValidator {
  static const int _maxUrlLength = 2048;

  static UrlValidationResult validate(String rawUrl) {
    final candidate = rawUrl.trim();

    if (candidate.isEmpty) {
      return UrlValidationResult.invalid('error_empty');
    }

    if (candidate.length > _maxUrlLength) {
      return UrlValidationResult.invalid('error_too_long');
    }

    Uri parsed;
    try {
      parsed = Uri.parse(candidate);
    } catch (_) {
      return UrlValidationResult.invalid('error_invalid_url');
    }

    if (!parsed.hasScheme ||
        (parsed.scheme != 'http' && parsed.scheme != 'https')) {
      return UrlValidationResult.invalid('error_invalid_url');
    }

    if (!parsed.hasAuthority || parsed.host.isEmpty) {
      return UrlValidationResult.invalid('error_invalid_url');
    }

    final host = parsed.host.toLowerCase();

    // Block localhost
    if (host == 'localhost' || host.endsWith('.localhost')) {
      return UrlValidationResult.invalid('error_localhost');
    }

    // Block loopback IPs
    if (host == '127.0.0.1' || host == '::1') {
      return UrlValidationResult.invalid('error_localhost');
    }

    // Block private IP ranges
    if (_isPrivateIp(host)) {
      return UrlValidationResult.invalid('error_private_ip');
    }

    // Normalize: lowercase host, remove fragment, remove default ports
    final normalized = Uri(
      scheme: parsed.scheme,
      host: host,
      port: _isDefaultPort(parsed.scheme, parsed.port) ? null : parsed.port,
      path: parsed.path,
      query: parsed.hasQuery ? parsed.query : null,
    ).toString();

    return UrlValidationResult.valid(normalized);
  }

  static bool _isDefaultPort(String scheme, int port) {
    if (port == 0) return true;
    return (scheme == 'http' && port == 80) ||
        (scheme == 'https' && port == 443);
  }

  static bool _isPrivateIp(String host) {
    // 10.x.x.x
    if (RegExp(r'^10\.\d+\.\d+\.\d+$').hasMatch(host)) return true;
    // 192.168.x.x
    if (RegExp(r'^192\.168\.\d+\.\d+$').hasMatch(host)) return true;
    // 172.16.x.x - 172.31.x.x
    final match = RegExp(r'^172\.(\d+)\.\d+\.\d+$').firstMatch(host);
    if (match != null) {
      final second = int.tryParse(match.group(1)!);
      if (second != null && second >= 16 && second <= 31) return true;
    }
    // 169.254.x.x (link-local)
    if (RegExp(r'^169\.254\.\d+\.\d+$').hasMatch(host)) return true;
    return false;
  }
}
