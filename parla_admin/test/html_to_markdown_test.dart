import 'package:flutter_test/flutter_test.dart';
import 'package:parla_admin/markdown/html_to_markdown.dart';

// What Google Docs puts on the clipboard (shortened).
const _googleDocs = '''
<meta charset="utf-8"><b style="font-weight:normal;" id="docs-internal-guid-1a2b"><h1 dir="ltr" style="line-height:1.38;"><span style="font-size:20pt;font-family:Arial;font-weight:400;">Qışda dəri</span></h1>
<p dir="ltr"><span style="font-weight:400;">Soyuq hava dərini </span><span style="font-weight:700;">qurudur</span><span style="font-weight:400;">, isti duş da </span><span style="font-style:italic;font-weight:400;">daha çox</span><span>.</span></p>
<h2><span style="font-weight:400;">Nə etməli?</span></h2>
<ul style="margin-top:0;"><li dir="ltr"><p dir="ltr"><span>Ilıq su</span></p></li><li><p><span>Nəmləndirici</span></p><ul><li><p><span>Krem</span></p></li></ul></li></ul>
<ol><li><p><span>Birinci</span></p></li><li><p><span>İkinci</span></p></li></ol>
<p><a href="https://www.google.com/url?q=https://www.aad.org/dry-skin&amp;sa=D"><span>AAD</span></a><span> və </span><a href="javascript:alert(1)"><span>pis link</span></a></p>
<p><span><img src="https://lh3.googleusercontent.com/x.png" width="200"></span></p>
<p><span>​Görünməz boşluq</span></p>
</b>
''';

void main() {
  test('Google Docs HTML becomes clean Markdown', () {
    final md = htmlToMarkdown(_googleDocs);
    expect(md, contains('## Qışda dəri'));
    expect(
      md,
      contains('Soyuq hava dərini **qurudur**, isti duş da *daha çox*.'),
    );
    expect(md, contains('### Nə etməli?'));
    expect(md, contains('- Ilıq su\n- Nəmləndirici\n  - Krem'));
    expect(md, contains('1. Birinci\n2. İkinci'));
    expect(md, contains('[AAD](https://www.aad.org/dry-skin)'));
    // Unsafe links keep only their text; images are not taken over.
    expect(md, isNot(contains('javascript')));
    expect(md, contains('pis link'));
    expect(md, isNot(contains('googleusercontent')));
    expect(md, contains('Görünməz boşluq'));
    expect(md, isNot(contains('​')));
    // The Docs wrapper <b style="font-weight:normal"> does not make
    // everything bold.
    expect(md, isNot(startsWith('**')));
    expect(md, isNot(contains('\n\n\n')));
  });

  test('plain pasted text is tidied', () {
    expect(
      cleanMarkdown('● bir\r\n• iki\r\n\r\n\r\n\r\nson  '),
      '- bir\n- iki\n\nson',
    );
  });
}
