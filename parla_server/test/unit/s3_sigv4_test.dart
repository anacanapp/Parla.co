import 'dart:convert';

import 'package:parla_server/src/media/s3_media_store.dart';
import 'package:test/test.dart';

// The examples from the AWS documentation "Signature Calculations for the
// Authorization Header: Transferring Payload in a Single Chunk".
const _creds = AwsCredentials(
  'AKIAIOSFODNN7EXAMPLE',
  'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY',
);
final _now = DateTime.utc(2013, 5, 24);

void main() {
  test('GET object matches the AWS example', () {
    final headers = SigV4('us-east-1').sign(
      method: 'GET',
      path: '/test.txt',
      headers: {'host': 'examplebucket.s3.amazonaws.com', 'range': 'bytes=0-9'},
      payloadHash: SigV4.hashHex(const []),
      credentials: _creds,
      now: _now,
    );
    expect(
      headers['authorization'],
      'AWS4-HMAC-SHA256 Credential=AKIAIOSFODNN7EXAMPLE/20130524/us-east-1/'
      's3/aws4_request, SignedHeaders=host;range;x-amz-content-sha256;'
      'x-amz-date, Signature=f0e8bdb87c964420e857bd35b5d6ed310bd44f0170aba4'
      '8dd91039c6036bdb41',
    );
  });

  test('PUT object matches the AWS example', () {
    final headers = SigV4('us-east-1').sign(
      method: 'PUT',
      path: r'/test$file.text',
      headers: {
        'host': 'examplebucket.s3.amazonaws.com',
        'date': 'Fri, 24 May 2013 00:00:00 GMT',
        'x-amz-storage-class': 'REDUCED_REDUNDANCY',
      },
      payloadHash: SigV4.hashHex(utf8.encode('Welcome to Amazon S3.')),
      credentials: _creds,
      now: _now,
    );
    expect(
      headers['authorization'],
      endsWith(
        'Signature=98ad721746da40c64f1a55b78f14c238d841ea1380cd77a1b5971af0'
        'ece108bd',
      ),
    );
  });

  test('a session token is signed too', () {
    final headers = SigV4('eu-central-1').sign(
      method: 'DELETE',
      path: '/public/a.jpg',
      headers: {'host': 'b.s3.eu-central-1.amazonaws.com'},
      payloadHash: SigV4.hashHex(const []),
      credentials: const AwsCredentials('id', 'secret', sessionToken: 'tok'),
      now: _now,
    );
    expect(headers['x-amz-security-token'], 'tok');
    expect(headers['authorization'], contains('x-amz-security-token'));
  });
}
