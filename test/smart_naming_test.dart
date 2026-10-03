import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:packet_pal/features/library/domain/smart_naming.dart';

void main() {
  setUpAll(() => initializeDateFormatting('en'));

  final namer = SmartNamer(
    labels: const NamingLabels(
      fallback: 'Document',
      kinds: {
        DocKind.bankStatement: 'Bank Statement',
        DocKind.payStub: 'Pay Stub',
        DocKind.passport: 'Passport',
        DocKind.utilityBill: 'Utility Bill',
        DocKind.invoice: 'Invoice',
      },
    ),
  );
  final scanned = DateTime(2026, 10, 3);

  test('names a bank statement with its month', () {
    const text =
        'FIRST NATIONAL BANK\nBank Statement\n'
        'Statement period: March 1, 2026 - March 31, 2026\nEnding balance \$1,204.10';
    expect(namer.suggest(text, scanned), 'Bank Statement - Mar 2026');
  });

  test('uses the scan date when the text has no date', () {
    expect(
      namer.suggest('Your payslip\nNet pay 2,300', scanned),
      'Pay Stub - Oct 2026',
    );
  });

  test('picks the most frequent month, latest on ties', () {
    expect(
      namer.detectMonth('Invoice 12 Jan 2026 due 12 Feb 2026 paid 14 Feb 2026'),
      DateTime(2026, 2),
    );
    expect(namer.detectMonth('01/05/2026 and 2026-07-09'), DateTime(2026, 7));
  });

  test('parses numeric dates month-first unless impossible', () {
    expect(namer.detectMonth('31/03/2026'), DateTime(2026, 3));
    expect(namer.detectMonth('04/15/2026'), DateTime(2026, 4));
    expect(namer.detectMonth('Due 09/2025'), DateTime(2025, 9));
  });

  test('falls back to the first real line, then to a dated placeholder', () {
    expect(
      namer.suggest('!!\nAcme Corp Lease Renewal\nmore', scanned),
      'Acme Corp Lease Renewal',
    );
    final empty = namer.suggest('', scanned);
    expect(empty, startsWith('Document - '));
    expect(empty, isNot(matches(RegExp(r'^Scan \d+'))));
  });

  test('never returns an empty or numbered scan title', () {
    for (final text in ['', '   ', '1234 5678', '#### ----']) {
      final title = namer.suggest(text, scanned);
      expect(title.trim(), isNotEmpty);
      expect(title, isNot(contains('Scan 47')));
    }
  });
}
