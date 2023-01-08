import 'package:flutter/material.dart';
import 'package:flutter_prism/flutter_prism.dart';
import 'package:google_fonts/google_fonts.dart';

/// A widget which renders code with syntax highlighting and selecting.
class CodeRender extends StatefulWidget {
  const CodeRender({
    super.key,
    required this.code,
  });

  final String code;

  @override
  State<CodeRender> createState() => _CodeRenderState();
}

class _CodeRenderState extends State<CodeRender> {
  late TextSpan _textSpan;
  late int _lines;

  final Prism prism = Prism(
    style: const PrismStyle.dark(
      className: TextStyle(color: Color(0xffe5c07b)),
      keyword: TextStyle(color: Color(0xffc678dd)),
      function: TextStyle(color: Color(0xff61afef)),
      number: TextStyle(color: Color(0xffd19a66)),
      punctuation: TextStyle(color: Color(0xffabb2bf)),
    ),
  );

  @override
  void initState() {
    _updateCode();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CodeRender oldWidget) {
    if (oldWidget.code != widget.code) _updateCode();
    super.didUpdateWidget(oldWidget);
  }

  void _updateCode() {
    _textSpan = TextSpan(
      children: prism.render(widget.code, 'dart'),
    );
    _lines = '\n'.allMatches(widget.code).length + 1;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        fontFamily: GoogleFonts.robotoMono().fontFamily,
        fontSize: 16,
        color: const Color(0xffabb2bf),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            List<String>.generate(
              _lines,
              (int index) => '${index + 1}',
            ).join('\n'),
            style: const TextStyle(
              color: Color(0xffabb2bf),
            ),
          ),
          const SizedBox(width: 20),
          SelectableText.rich(_textSpan)
        ],
      ),
    );
  }
}
