import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import '../data/media_store.dart';
import '../data/timeline_store.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/health_ui.dart';

String csvCell(String v) {
  final needs = v.contains(',') || v.contains('"') || v.contains('\n') || v.contains('\r');
  final e = v.replaceAll('"', '""');
  return needs ? '"$e"' : e;
}

String csvRow(List<String> cells) => cells.map(csvCell).join(',');

String _isoDate(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

String exportStamp() => _isoDate(DateTime.now());

/// File names of the media attached to an event's record.
List<String> attachmentNames(TimelineEvent e) {
  if (e.linkKey.isEmpty) return const [];
  return [
    for (final i in MediaStore.instance.items(e.dog))
      if (i.links.any((l) => l.key == e.linkKey)) i.name,
  ];
}

/// One row per original event. Blank means not available / not applicable.
Uint8List eventsCsv(List<TimelineEvent> events) {
  final b = StringBuffer('﻿');
  b.writeln(csvRow(['Dog', 'Category', 'Type', 'Title', 'Original Date', 'Time', 'Details', 'Notes', 'Attachments']));
  for (final e in events) {
    b.writeln(csvRow([
      e.dog,
      e.category,
      e.typeLabel,
      e.title,
      _isoDate(e.at),
      e.hasTime ? TimelineStore.timeLabel(e) : '',
      e.detail,
      e.notes,
      attachmentNames(e).join('; '),
    ]));
  }
  return Uint8List.fromList(utf8.encode(b.toString()));
}

Future<Uint8List> eventsPdf(String heading, String scope, List<TimelineEvent> events) async {
  final doc = pw.Document();
  doc.addPage(pw.MultiPage(
    build: (ctx) => [
      pw.Text(heading, style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
      pw.SizedBox(height: 4),
      pw.Text(scope, style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey700)),
      pw.SizedBox(height: 14),
      for (final e in events)
        pw.Container(
          margin: const pw.EdgeInsets.only(bottom: 10),
          child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text(e.title, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
            pw.Text('${e.typeLabel} · ${e.dog} · ${fmtDate(e.at)}${e.hasTime ? ' · ${fmtTime(e.at)}' : ''}',
                style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
            if (e.detail.isNotEmpty) pw.Text(e.detail, style: const pw.TextStyle(fontSize: 10)),
            if (e.notes.isNotEmpty) pw.Text(e.notes, style: const pw.TextStyle(fontSize: 10)),
            if (attachmentNames(e).isNotEmpty)
              pw.Text('Attachments: ${attachmentNames(e).join(', ')}', style: const pw.TextStyle(fontSize: 9)),
          ]),
        ),
    ],
  ));
  return doc.save();
}

/// Simple table PDF (used by Statistics and Compare).
Future<Uint8List> tablePdf(String heading, List<String> subtitleLines, List<List<String>> rows) async {
  final doc = pw.Document();
  doc.addPage(pw.MultiPage(
    build: (ctx) => [
      pw.Text(heading, style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
      pw.SizedBox(height: 4),
      for (final l in subtitleLines) pw.Text(l, style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey700)),
      pw.SizedBox(height: 14),
      pw.TableHelper.fromTextArray(data: rows, cellStyle: const pw.TextStyle(fontSize: 10)),
    ],
  ));
  return doc.save();
}

Uint8List tableCsv(List<List<String>> rows) =>
    Uint8List.fromList(utf8.encode('﻿${rows.map(csvRow).join('\n')}\n'));

/// Builds the file with a "Preparing Your Export" state, then offers Save File
/// and Share File. "File Saved" is only shown after the platform confirms.
Future<void> runExport(
  BuildContext context, {
  required String fileName,
  required bool pdf,
  required Future<Uint8List> Function() build,
  String preparing = 'Preparing your export...',
}) async {
  var cancelled = false;
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.cardsCarbon,
      title: Text('Preparing Your Export', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 17)),
      content: Row(children: [
        SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryForestGreen)),
        const SizedBox(width: 14),
        Expanded(child: Text(preparing, style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13.5))),
      ]),
      actions: [
        TextButton(
          onPressed: () {
            cancelled = true;
            Navigator.pop(ctx);
          },
          child: const Text('Cancel Export'),
        ),
      ],
    ),
  );
  Uint8List bytes;
  try {
    bytes = await build();
  } catch (_) {
    if (context.mounted && !cancelled) {
      Navigator.of(context, rootNavigator: true).pop();
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.cardsCarbon,
          title: Text('Couldn’t Create Export', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 17)),
          content: Text('Please try again. Your selected events and export settings have been kept.',
              style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13.5)),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
        ),
      );
    }
    return;
  }
  if (!context.mounted) return;
  if (cancelled) return;
  Navigator.of(context, rootNavigator: true).pop();
  await showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.cardsCarbon,
      title: Text('Export Ready', style: TextStyle(color: AppColors.primaryTextOffWhite, fontSize: 17)),
      content: Text(fileName, style: TextStyle(color: AppColors.secondaryTextStoneGrey, fontSize: 13.5)),
      actions: [
        TextButton(
          onPressed: () async {
            final r = await FilePicker.saveFile(fileName: fileName, bytes: bytes);
            if (r != null && ctx.mounted) {
              AppSnackbar.show(ctx, message: 'File saved', type: SnackbarType.success);
            }
          },
          child: const Text('Save File'),
        ),
        TextButton(
          onPressed: () async {
            try {
              await SharePlus.instance.share(ShareParams(
                files: [XFile.fromData(bytes, name: fileName, mimeType: pdf ? 'application/pdf' : 'text/csv')],
                fileNameOverrides: [fileName],
              ));
            } catch (_) {
              if (ctx.mounted) AppSnackbar.show(ctx, message: 'Couldn’t open sharing.', type: SnackbarType.error);
            }
          },
          child: const Text('Share File'),
        ),
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Done')),
      ],
    ),
  );
}
