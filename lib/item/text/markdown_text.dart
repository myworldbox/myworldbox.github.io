import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;

// MarkdownTextWidget to display Markdown content
class MarkdownTextWidget extends StatelessWidget {
  final String markdown;
  final TextStyle? style;
  final bool richText;

  const MarkdownTextWidget({
    super.key,
    required this.markdown,
    this.style,
    this.richText = true,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = style ?? Theme.of(context).textTheme.bodyMedium ?? const TextStyle();
    final spans = _parseMarkdown(markdown, baseStyle);

    return richText
        ? RichText(text: TextSpan(children: spans))
        : Text(spans.map((span) => span.text ?? '').join(), style: baseStyle);
  }

  // Parse Markdown into TextSpans (or plain text implicitly)
  List<TextSpan> _parseMarkdown(String markdown, TextStyle baseStyle) {
    final document = md.Document();
    final nodes = document.parseLines(markdown.split('\n'));
    return nodes.expand((node) => _nodeToTextSpans(node, baseStyle)).toList();
  }

  // Map of Markdown tags to style modifiers
  static final _styleModifiers = {
    'p': (TextStyle s) => s, // No change, just adds newline
    'strong': (TextStyle s) => s.copyWith(fontWeight: FontWeight.bold),
    'em': (TextStyle s) => s.copyWith(fontStyle: FontStyle.italic),
    'h1': (TextStyle s) => s.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
    'h2': (TextStyle s) => s.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
  };

  // Convert Markdown nodes to TextSpans
  List<TextSpan> _nodeToTextSpans(md.Node node, TextStyle baseStyle) {
    if (node is md.Text) {
      return [TextSpan(text: node.text, style: baseStyle)];
    } else if (node is md.Element) {
      final modifier = _styleModifiers[node.tag] ?? (s) => s; // Default to no change
      final styled = modifier(baseStyle);
      final childrenSpans = node.children?.expand((child) => _nodeToTextSpans(child, styled)).toList() ?? [];
      return childrenSpans..addIf(node.tag == 'p' || node.tag.startsWith('h'), TextSpan(text: '\n', style: baseStyle));
    }
    return [];
  }
}

// Extension to add elements conditionally
extension ListExtensions<T> on List<T> {
  void addIf(bool condition, T element) {
    if (condition) add(element);
  }
}