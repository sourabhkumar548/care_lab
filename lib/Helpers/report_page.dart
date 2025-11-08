import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  late FleatherController _controller;
  final FocusNode _editorFocus = FocusNode();
  final FocusNode _keyboardFocus = FocusNode();
  List<dynamic>? savedJson;

  String data = "Sourabh Gupta";

  @override
  void initState() {
    super.initState();
    final deltaJson = [
      {"insert": "$data|Centered line|Right line"},
      {"insert": "\n"},
      {"insert": "Another left\tAnother center"},
      {"insert": "\n"},
    ];
    final doc = ParchmentDocument.fromJson(deltaJson);
    _controller = FleatherController(document: doc);

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FleatherToolbar.basic(hideHeadingStyle: true,
            controller: _controller,
            hideCodeBlock: true,
            hideInlineCode: true,
          ),



          Expanded(
            child: RawKeyboardListener(
              focusNode: _keyboardFocus,
              onKey: (RawKeyEvent event) {
                if (event is RawKeyDownEvent &&
                    event.logicalKey == LogicalKeyboardKey.tab) {
                  final selection = _controller.selection;

                  if (event.isShiftPressed) {
                    _applyIndent(increase: false,);
                  } else {
                    // Insert tab character
                    if (selection.isCollapsed) {
                      _controller.replaceText(
                        selection.baseOffset,
                        0,
                        '\t',
                      );

                      _controller.updateSelection(
                        TextSelection.collapsed(offset: selection.baseOffset + 1),
                      );

                    } else {
                      _controller.replaceText(
                        selection.baseOffset,
                        0,
                        '\t',
                      );

                      _controller.updateSelection(
                        TextSelection.collapsed(offset: selection.baseOffset + 1,),
                      );

                    }
                  }
                  return;
                }
              },
              child: Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Container(
                      width: 595,  // A4 width in points at 72 dpi
                      height: 842, // A4 height in points at 72 dpi
                      padding: const EdgeInsets.all(10), // page margins
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: FleatherEditor(
                        controller: _controller,
                        focusNode: _editorFocus,
                        padding: EdgeInsets.zero, // already handled by container padding
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _saveDocument,
                child: const Text("Save"),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: _printDocument,
                child: const Text("Print"),
              ),
            ],
          )
        ],
      ),
    );
  }



  void _applyIndent({required bool increase}) {
    final selection = _controller.selection;
    if (selection.isCollapsed) return;

    final currentIndent =
        _controller.getSelectionStyle().get(ParchmentAttribute.indent)?.value ?? 0;

    final newIndent =
    increase ? currentIndent + 1 : (currentIndent - 1).clamp(0, 10);

    if (newIndent == 0) {
      _controller.formatSelection(ParchmentAttribute.indent.unset);
    } else {
      _controller.formatSelection(ParchmentAttribute.indent.withValue(newIndent));
    }
  }

  void _saveDocument() {
    final delta = _controller.document.toDelta();
    final json = delta.toJson();
    setState(() {
      savedJson = json;
    });
    debugPrint("$json");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Document saved!")),
    );
  }

  Future<void> _printDocument() async {
    final delta = _controller.document.toDelta();
    final pdf = pw.Document();
    final ops = delta.toList();

    // Build paragraphs
    final List<Map<String, dynamic>> paragraphs = [];
    List<Map<String, dynamic>> currentSegments = [];

    for (int i = 0; i < ops.length; i++) {
      final op = ops[i];
      if (!(op.isInsert)) continue;

      if (op.data is String) {
        final text = op.data as String;
        final attrs = (op.attributes ?? {}) as Map<String, dynamic>;

        if (text == '\n') {
          final paraAttrs = Map<String, dynamic>.from(attrs);
          paragraphs.add({'segments': List.from(currentSegments), 'attrs': paraAttrs});
          currentSegments.clear();
          continue;
        }

        if (text.contains('\n')) {
          final parts = text.split('\n');
          for (int p = 0; p < parts.length; p++) {
            final part = parts[p];
            if (part.isNotEmpty) {
              currentSegments.add({'text': part, 'attrs': Map<String, dynamic>.from(attrs)});
            }
            if (p < parts.length - 1) {
              final paraAttrs = Map<String, dynamic>.from(attrs);
              paragraphs.add({'segments': List.from(currentSegments), 'attrs': paraAttrs});
              currentSegments.clear();
            }
          }
          continue;
        }

        currentSegments.add({'text': text, 'attrs': Map<String, dynamic>.from(attrs)});
      }
    }

    if (currentSegments.isNotEmpty) {
      paragraphs.add({'segments': List.from(currentSegments), 'attrs': <String, dynamic>{}});
      currentSegments.clear();
    }

    // Generate PDF
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          final widgets = <pw.Widget>[];

          for (final p in paragraphs) {
            final segs = (p['segments'] as List).cast<Map<String, dynamic>>();
            final pattrs = (p['attrs'] as Map<String, dynamic>);

            final text = segs.map((e) => e['text']?.toString() ?? '').join();

            // Special line with left|center|right
            if (text.contains('|')) {
              final parts = text.split('|').map((e) => e.trim()).toList();
              final leftText = parts.isNotEmpty ? parts[0] : "";
              final centerText = parts.length > 1 ? parts[1] : "";
              final rightText = parts.length > 2 ? parts[2] : "";

              widgets.add(
                pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 6),
                  child: pw.Row(
                    children: [
                      pw.Expanded(
                        child: pw.Text(leftText,
                            textAlign: pw.TextAlign.left,style: pw.TextStyle(fontSize: 18)),
                      ),
                      pw.Expanded(
                        child: pw.Text(centerText,
                            textAlign: pw.TextAlign.center,style: pw.TextStyle(fontSize: 18)),
                      ),
                      pw.Expanded(
                        child: pw.Text(rightText,
                            textAlign: pw.TextAlign.right,style: pw.TextStyle(fontSize: 18)),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              // Normal paragraph
              final List<pw.TextSpan> children = [];
              for (final seg in segs) {
                final segText = seg['text']?.toString() ?? '';
                final segAttrs = (seg['attrs'] as Map<String, dynamic>?) ?? {};
                children.add(
                  pw.TextSpan(
                    text: segText,
                    style: _textStyleFromAttrs(segAttrs),
                  ),
                );
              }

              widgets.add(
                pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 6),
                  child: pw.RichText(
                    text: pw.TextSpan(children: children),
                  ),
                ),
              );
            }
          }

          return widgets;
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat fmt) async => pdf.save());
  }


  pw.TextStyle _textStyleFromAttrs(Map<String, dynamic> attrs) {
    pw.TextStyle style = const pw.TextStyle(fontSize: 18);

    if (attrs.containsKey('b')) {
      style = style.merge(pw.TextStyle(fontWeight: pw.FontWeight.bold));
    }
    if (attrs.containsKey('i')) {
      style = style.merge(pw.TextStyle(fontStyle: pw.FontStyle.italic));
    }
    if (attrs.containsKey('u')) {
      style = style.merge(
          const pw.TextStyle(decoration: pw.TextDecoration.underline));
    }
    if (attrs.containsKey('heading')) {
      final level = attrs['heading'];
      if (level == 1) style = style.merge(pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold));
      if (level == 2) style = style.merge(pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold));
      if (level == 3) style = style.merge(pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold));
    }

    return style;
  }
}
