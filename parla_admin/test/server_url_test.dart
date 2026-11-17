import 'package:flutter_test/flutter_test.dart';
import 'package:parla_admin/api/server_url.dart';

void main() {
  test('served under /admin/, the panel uses its own origin', () {
    expect(
      sameOriginServerUrl(Uri.parse('https://parla.anacan.az/admin/')),
      'https://parla.anacan.az/',
    );
    expect(
      sameOriginServerUrl(Uri.parse('https://parla.anacan.az/admin/content/4')),
      'https://parla.anacan.az/',
    );
  });

  test('a SERVER_URL define wins', () {
    expect(
      sameOriginServerUrl(
        Uri.parse('https://parla.anacan.az/admin/'),
        define: 'http://localhost:8080/',
      ),
      'http://localhost:8080/',
    );
  });

  test('elsewhere it leaves the choice to the caller', () {
    expect(sameOriginServerUrl(Uri.parse('http://localhost:5000/')), isNull);
    expect(
      sameOriginServerUrl(Uri.parse('https://x.test/administrator')),
      isNull,
    );
    expect(sameOriginServerUrl(Uri.parse('file:///admin/index.html')), isNull);
  });
}
