import 'package:intl/intl.dart';

/// Kinds of documents the namer can recognise from OCR text.
enum DocKind {
  bankStatement,
  payStub,
  passport,
  driverLicense,
  idCard,
  utilityBill,
  leaseAgreement,
  taxDocument,
  invoice,
  receipt,
  referenceLetter,
  offerLetter,
  insurance,
  birthCertificate,
}

/// Human-readable names for each [DocKind], supplied by the UI layer from the
/// localisation files so this class stays free of hard-coded strings.
class NamingLabels {
  const NamingLabels({required this.kinds, required this.fallback});

  final Map<DocKind, String> kinds;

  /// Used when nothing can be recognised at all, e.g. "Document".
  final String fallback;
}

/// Suggests a meaningful title from OCR text. Never produces "Scan 47".
class SmartNamer {
  SmartNamer({required this.labels, this.locale = 'en'});

  final NamingLabels labels;
  final String locale;

  static final Map<DocKind, List<RegExp>> _patterns = {
    DocKind.bankStatement: [
      RegExp(
        r'bank statement|statement of account|account statement|'
        r'checking account|savings account|statement period|ending balance',
        caseSensitive: false,
      ),
    ],
    DocKind.payStub: [
      RegExp(
        r'pay ?stub|payslip|pay slip|earnings statement|net pay|gross pay',
        caseSensitive: false,
      ),
    ],
    DocKind.passport: [RegExp(r'passport|p<[a-z]{3}', caseSensitive: false)],
    DocKind.driverLicense: [
      RegExp(r"driver'?s? licen[sc]e|driving licen[sc]e", caseSensitive: false),
    ],
    DocKind.idCard: [
      RegExp(
        r'identity card|identification card|national id|aadhaar|emirates id',
        caseSensitive: false,
      ),
    ],
    DocKind.utilityBill: [
      RegExp(
        r'utility bill|electric(ity)? bill|water bill|gas bill|'
        r'amount due.*(kwh|usage)|kwh',
        caseSensitive: false,
      ),
    ],
    DocKind.leaseAgreement: [
      RegExp(
        r'lease agreement|rental agreement|tenancy agreement|landlord',
        caseSensitive: false,
      ),
    ],
    DocKind.taxDocument: [
      RegExp(
        r'form w-?2|form 1099|tax return|form 16|income tax|1040',
        caseSensitive: false,
      ),
    ],
    DocKind.invoice: [RegExp(r'\binvoice\b', caseSensitive: false)],
    DocKind.receipt: [RegExp(r'\breceipt\b', caseSensitive: false)],
    DocKind.referenceLetter: [
      RegExp(
        r'letter of reference|reference letter|to whom it may concern',
        caseSensitive: false,
      ),
    ],
    DocKind.offerLetter: [
      RegExp(
        r'offer letter|offer of employment|employment agreement|'
        r'we are pleased to offer',
        caseSensitive: false,
      ),
    ],
    DocKind.insurance: [
      RegExp(
        r'insurance (policy|card|certificate)|policy number|premium',
        caseSensitive: false,
      ),
    ],
    DocKind.birthCertificate: [
      RegExp(r'birth certificate|certificate of birth', caseSensitive: false),
    ],
  };

  static const _months = <String, int>{
    'jan': 1,
    'january': 1,
    'feb': 2,
    'february': 2,
    'mar': 3,
    'march': 3,
    'apr': 4,
    'april': 4,
    'may': 5,
    'jun': 6,
    'june': 6,
    'jul': 7,
    'july': 7,
    'aug': 8,
    'august': 8,
    'sep': 9,
    'sept': 9,
    'september': 9,
    'oct': 10,
    'october': 10,
    'nov': 11,
    'november': 11,
    'dec': 12,
    'december': 12,
  };

  static const _monthWord =
      r'(jan(?:uary)?|feb(?:ruary)?|mar(?:ch)?|apr(?:il)?|may|june?|july?|'
      r'aug(?:ust)?|sept?(?:ember)?|oct(?:ober)?|nov(?:ember)?|dec(?:ember)?)';

  /// Recognises the kind of document, or null when nothing matches.
  /// The kind with the most keyword hits wins; ties go to the earlier enum
  /// value, which is ordered from most to least specific.
  DocKind? detectKind(String text) {
    DocKind? best;
    var bestScore = 0;
    for (final entry in _patterns.entries) {
      var score = 0;
      for (final re in entry.value) {
        score += re.allMatches(text).length;
      }
      if (score > bestScore) {
        best = entry.key;
        bestScore = score;
      }
    }
    return best;
  }

  /// The most plausible (year, month) mentioned in [text], or null.
  /// The most frequent month wins; ties go to the latest.
  DateTime? detectMonth(String text) {
    final found = <DateTime>[];

    for (final m in RegExp(
      '$_monthWord\\.?\\s+(?:\\d{1,2}(?:st|nd|rd|th)?,?\\s+)?((?:19|20)\\d{2})\\b',
      caseSensitive: false,
    ).allMatches(text)) {
      found.add(
        DateTime(int.parse(m.group(2)!), _months[m.group(1)!.toLowerCase()]!),
      );
    }
    for (final m in RegExp(
      '\\b\\d{1,2}(?:st|nd|rd|th)?\\s+$_monthWord\\.?,?\\s+((?:19|20)\\d{2})\\b',
      caseSensitive: false,
    ).allMatches(text)) {
      found.add(
        DateTime(int.parse(m.group(2)!), _months[m.group(1)!.toLowerCase()]!),
      );
    }
    for (final m in RegExp(
      r'\b((?:19|20)\d{2})-(\d{2})-(\d{2})\b',
    ).allMatches(text)) {
      final month = int.parse(m.group(2)!);
      if (month >= 1 && month <= 12) {
        found.add(DateTime(int.parse(m.group(1)!), month));
      }
    }
    for (final m in RegExp(
      r'\b(\d{1,2})[/.-](\d{1,2})[/.-]((?:19|20)\d{2})\b',
    ).allMatches(text)) {
      final a = int.parse(m.group(1)!);
      final b = int.parse(m.group(2)!);
      final year = int.parse(m.group(3)!);
      // Month-first unless that is impossible (e.g. 31/03/2026).
      final month = a <= 12 ? a : b;
      if (month >= 1 && month <= 12) found.add(DateTime(year, month));
    }
    for (final m in RegExp(
      r'\b(0?[1-9]|1[0-2])/((?:19|20)\d{2})\b',
    ).allMatches(text)) {
      found.add(DateTime(int.parse(m.group(2)!), int.parse(m.group(1)!)));
    }

    if (found.isEmpty) return null;
    final counts = <DateTime, int>{};
    for (final d in found) {
      counts[d] = (counts[d] ?? 0) + 1;
    }
    final ordered = counts.entries.toList()
      ..sort((a, b) {
        final byCount = b.value.compareTo(a.value);
        return byCount != 0 ? byCount : b.key.compareTo(a.key);
      });
    return ordered.first.key;
  }

  /// First line that looks like a real heading rather than OCR noise.
  String? _headline(String text) {
    for (final raw in text.split('\n')) {
      final line = raw.trim().replaceAll(RegExp(r'\s+'), ' ');
      if (line.length < 4) continue;
      final letters = RegExp(r'\p{L}', unicode: true).allMatches(line).length;
      if (letters / line.length < 0.6) continue;
      return line.length > 40 ? '${line.substring(0, 40).trim()}…' : line;
    }
    return null;
  }

  String _formatMonth(DateTime d) => DateFormat('MMM yyyy', locale).format(d);

  /// Suggests a title. [scannedAt] is used when the text holds no date.
  String suggest(String ocrText, DateTime scannedAt) {
    final kind = detectKind(ocrText);
    final month = detectMonth(ocrText);
    final label = kind != null ? labels.kinds[kind] : null;

    if (label != null) {
      return '$label - ${_formatMonth(month ?? scannedAt)}';
    }
    final headline = _headline(ocrText);
    if (headline != null) {
      return month != null ? '$headline - ${_formatMonth(month)}' : headline;
    }
    return '${labels.fallback} - '
        '${DateFormat.yMMMd(locale).format(scannedAt)}';
  }
}
