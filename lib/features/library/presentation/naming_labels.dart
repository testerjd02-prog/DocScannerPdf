import '../../../core/l10n_x.dart';
import '../domain/smart_naming.dart';

SmartNamer smartNamerFor(AppLocalizations l10n) => SmartNamer(
  locale: l10n.localeName,
  labels: NamingLabels(
    fallback: l10n.kindFallback,
    kinds: {
      DocKind.bankStatement: l10n.kindBankStatement,
      DocKind.payStub: l10n.kindPayStub,
      DocKind.passport: l10n.kindPassport,
      DocKind.driverLicense: l10n.kindDriverLicense,
      DocKind.idCard: l10n.kindIdCard,
      DocKind.utilityBill: l10n.kindUtilityBill,
      DocKind.leaseAgreement: l10n.kindLeaseAgreement,
      DocKind.taxDocument: l10n.kindTaxDocument,
      DocKind.invoice: l10n.kindInvoice,
      DocKind.receipt: l10n.kindReceipt,
      DocKind.referenceLetter: l10n.kindReferenceLetter,
      DocKind.offerLetter: l10n.kindOfferLetter,
      DocKind.insurance: l10n.kindInsurance,
      DocKind.birthCertificate: l10n.kindBirthCertificate,
    },
  ),
);
