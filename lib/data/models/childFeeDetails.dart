import 'package:yocut/data/models/classFeeType.dart';
import 'package:yocut/data/models/advanceFee.dart';
import 'package:yocut/data/models/classDetails.dart';
import 'package:yocut/data/models/installment.dart';
import 'package:yocut/data/models/paidFeeDetails.dart';
import 'package:yocut/data/models/sessionYear.dart';
import 'package:yocut/utils/labelKeys.dart';

class ChildFeeDetails {
  final int? id;
  final String? name;
  final String? dueDate;
  final double? dueCharges;
  final int? classId;
  final int? schoolId;
  final int? sessionYearId;
  final String? createdAt;
  final String? updatedAt;
  final double? minimumInstallmentAmount;
  final bool? includeFeeInstallments;
  final double? totalCompulsoryFees;
  final double? totalOptionalFees;
  final double? dueChargesAmount;
  final List<ClassFeeType>? compulsoryFees;
  final List<ClassFeeType>? optionalFees;
  final List<ClassFeeType>? fees;
  final List<PaidFeeDetails>? paidFees;
  final List<Installment>? installments;
  final SessionYear? sessionYear;
  final ClassDetails? classDetails;
  final bool? isOverdue;

  ChildFeeDetails({
    this.dueChargesAmount,
    this.isOverdue,
    this.id,
    this.name,
    this.dueDate,
    this.dueCharges,
    this.classId,
    this.schoolId,
    this.sessionYearId,
    this.createdAt,
    this.updatedAt,
    this.minimumInstallmentAmount,
    this.includeFeeInstallments,
    this.totalCompulsoryFees,
    this.totalOptionalFees,
    this.compulsoryFees,
    this.optionalFees,
    this.fees,
    this.paidFees,
    this.installments,
    this.classDetails,
    this.sessionYear,
  });

  ChildFeeDetails copyWith({
    int? id,
    double? dueChargesAmount,
    String? name,
    bool? isOverdue,
    String? dueDate,
    double? dueCharges,
    int? classId,
    int? schoolId,
    int? sessionYearId,
    String? createdAt,
    String? updatedAt,
    double? minimumInstallmentAmount,
    bool? includeFeeInstallments,
    double? totalCompulsoryFees,
    double? totalOptionalFees,
    List<ClassFeeType>? compulsoryFees,
    List<ClassFeeType>? optionalFees,
    List<ClassFeeType>? fees,
    List<PaidFeeDetails>? paidFees,
    List<Installment>? installments,
    SessionYear? sessionYear,
    ClassDetails? classDetails,
  }) {
    return ChildFeeDetails(
      isOverdue: isOverdue ?? this.isOverdue,
      dueChargesAmount: dueChargesAmount ?? this.dueChargesAmount,
      classDetails: classDetails ?? this.classDetails,
      sessionYear: sessionYear ?? this.sessionYear,
      id: id ?? this.id,
      name: name ?? this.name,
      dueDate: dueDate ?? this.dueDate,
      dueCharges: dueCharges ?? this.dueCharges,
      classId: classId ?? this.classId,
      schoolId: schoolId ?? this.schoolId,
      sessionYearId: sessionYearId ?? this.sessionYearId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      minimumInstallmentAmount:
          minimumInstallmentAmount ?? this.minimumInstallmentAmount,
      includeFeeInstallments:
          includeFeeInstallments ?? this.includeFeeInstallments,
      totalCompulsoryFees: totalCompulsoryFees ?? this.totalCompulsoryFees,
      totalOptionalFees: totalOptionalFees ?? this.totalOptionalFees,
      compulsoryFees: compulsoryFees ?? this.compulsoryFees,
      optionalFees: optionalFees ?? this.optionalFees,
      fees: fees ?? this.fees,
      paidFees: paidFees ?? this.paidFees,
      installments: installments ?? this.installments,
    );
  }

  ChildFeeDetails.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        isOverdue = json['is_overdue'] as bool?,
        dueChargesAmount =
            double.parse((json['due_charges_amount'] ?? 0).toString()),
        name = json['name'] as String?,
        dueDate = json['due_date'] as String?,
        dueCharges = double.parse((json['due_charges'] ?? 0).toString()),
        classId = json['class_id'] as int?,
        schoolId = json['school_id'] as int?,
        sessionYearId = json['session_year_id'] as int?,
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        minimumInstallmentAmount =
            double.parse((json['minimum_installment_amount'] ?? 0).toString()),
        includeFeeInstallments = json['include_fee_installments'] as bool?,
        totalCompulsoryFees =
            double.parse((json['total_compulsory_fees'] ?? 0).toString()),
        compulsoryFees = ((json['compulsory_fees'] ?? []) as List)
            .map((e) => ClassFeeType.fromJson(Map.from(e ?? {})))
            .toList(),
        optionalFees = ((json['optional_fees'] ?? []) as List)
            .map((e) => ClassFeeType.fromJson(Map.from(e ?? {})))
            .toList(),
        fees = ((json['fees_class_type'] ?? []) as List)
            .map((e) => ClassFeeType.fromJson(Map.from(e ?? {})))
            .toList(),
        paidFees = ((json['fees_paid'] ?? []) as List)
            .map((e) => PaidFeeDetails.fromJson(Map.from(e ?? {})))
            .toList(),
        installments = ((json['installments'] ?? []) as List)
            .map((e) => Installment.fromJson(Map.from(e ?? {})))
            .toList(),
        sessionYear =
            SessionYear.fromJson(Map.from(json['session_year'] ?? {})),
        classDetails = ClassDetails.fromJson(Map.from(json['class'] ?? {})),
        totalOptionalFees =
            double.parse((json['total_optional_fees'] ?? 0).toString());

  Map<String, dynamic> toJson() => {
        'id': id,
        'is_overdue': isOverdue,
        'name': name,
        'due_date': dueDate,
        'due_charges': dueCharges,
        'class_id': classId,
        'school_id': schoolId,
        'session_year_id': sessionYearId,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'minimum_installment_amount': minimumInstallmentAmount,
        'include_fee_installments': includeFeeInstallments,
        'total_compulsory_fees': totalCompulsoryFees,
        'total_optional_fees': totalOptionalFees,
        'compulsory_fees': compulsoryFees?.map((e) => e.toJson()).toList(),
        'optional_fees': optionalFees?.map((e) => e.toJson()).toList(),
        'fees_class_type': fees?.map((e) => e.toJson()).toList(),
        'fees_paid': paidFees?.map((e) => e.toJson()).toList(),
        'installments': installments?.map((e) => e.toJson()).toList(),
        'class': classDetails?.toJson(),
        'session_year': sessionYear?.toJson(),
        'due_charges_amount': dueChargesAmount
      };

  String getFeePaymentStatus() {
    if (paidFees?.isEmpty ?? true) {
      return pendingKey;
    }
    return paidFees!.first.isFullyPaid == 1 ? paidKey : partiallyPaidKey;
  }

  bool isGivenOptionalFeePaid({required int optionalFeeId}) {
    if ((paidFees ?? []).isEmpty) {
      return false;
    }

    return paidFees!.first.optionalPaidFees!
        .where((element) => element.id == optionalFeeId)
        .toList()
        .isNotEmpty;
  }

  bool isFeeOverDue() {
    return isOverdue ?? false;
  }

  double getTotalCompulsoryAmountWithDue() {
    return (dueChargesAmount ?? 0.0) + (totalCompulsoryFees ?? 0.0);
  }

  double remainingFeeAmountToPay() {
    if (paidFees!.isEmpty) {
      return totalCompulsoryFees ?? 0.0;
    } else {
      double totalPaidAmount = 0.0;
      for (var compulsoryPaidAmount
          in (paidFees!.first.compulsoryPaidFees ?? [])) {
        totalPaidAmount =
            totalPaidAmount + (compulsoryPaidAmount.amount ?? 0.0);
      }
      //
      return (totalCompulsoryFees ?? 0.0) - totalPaidAmount;
    }
  }

  bool didUserPaidPreviousCompulsoryFeeInInstallment() {
    //If user has paid any amount using installment
    return (installments ?? []).isNotEmpty
        ? installments!.where((element) => (element.isPaid ?? false)).isNotEmpty
        : false;
  }

  bool hasPaidCompulsoryFullyOrUsingInstallment() {
    //If user has paid any amount
    return !((paidFees ?? [])
        .where((element) => (element.compulsoryPaidFees ?? []).isNotEmpty)
        .isNotEmpty);
  }

  bool isCompulsoryFeeFullyPaid() {
    //If user has paid any amount using installment
    return (paidFees?.isNotEmpty ?? false)
        ? (paidFees!
            .where((element) => element.isFullyPaid == 1)
            .toList()
            .isNotEmpty)
        : false;
  }

  List<Installment> dueInstallments() {
    return (installments ?? [])
        .where((element) =>
            !(element.isCurrent ?? false) &&
            !(element.isPaid ?? false) &&
            (element.dueChargeAmount != 0.0))
        .toList();
  }

  bool hasAnyDueInstallment() {
    return dueInstallments().isNotEmpty;
  }

  double getOutstandingInstallmentAmount() {
    if (hasAnyDueInstallment()) {
      double outstandingAmount = 0.0;
      for (var installment in dueInstallments()) {
        outstandingAmount = (installment.dueChargeAmount ?? 0.0) +
            (installment.minimumAmount ?? 0.0);
      }
      return outstandingAmount;
    }
    return 0.0;
  }

  bool hasOptionalFees() {
    return (optionalFees ?? []).isNotEmpty;
  }

  bool hasAnyUnpaidOptionlFee() {
    return (optionalFees ?? [])
        .where((e) => (e.isPaid ?? false) == false)
        .toList()
        .isNotEmpty;
  }

  List<Installment> paidInstallments() {
    return (installments ?? []).where((e) => (e.isPaid ?? false)).toList();
  }

  double remainingInstallmentAmount() {
    final totalAmount = totalCompulsoryFees ?? 0.0;
    double paidAmount = 0.0;

    for (var installment in paidInstallments()) {
      paidAmount = (installment.minimumAmount ?? 0.0) + paidAmount;
    }

    return totalAmount - paidAmount;
  }

  Installment currentInstallment() {
    final index = (installments ?? [])
        .indexWhere((element) => (element.isCurrent ?? false));
    if (index != -1) {
      return installments![index];
    }
    return Installment.fromJson({});
  }

  double maximumAdvanceInstallmentAmount() {
    ///
    double paidInstallmentAmount = 0.0;

    for (var installment in paidInstallments()) {
      paidInstallmentAmount =
          (installment.minimumAmount ?? 0.0) + paidInstallmentAmount;
    }

    double outstandingAmount = 0.0;
    for (var installment in dueInstallments()) {
      outstandingAmount = (installment.minimumAmount ?? 0.0);
    }

    final currentInstallmentAmount = (currentInstallment().isPaid ?? false)
        ? 0.0
        : currentInstallment().minimumAmount ?? 0.0;

    final totalFeeAmount = totalCompulsoryFees ?? 0.0;

    return totalFeeAmount -
        paidInstallmentAmount -
        currentInstallmentAmount -
        outstandingAmount;
  }

  String optionalPaidDate({required int optionalFeeId}) {
    final optionalFeeIndex = ((paidFees ?? []).first.optionalPaidFees ?? [])
        .indexWhere((element) => element.feesClassId == optionalFeeId);
    if (optionalFeeIndex == -1) {
      return "";
    }
    return paidFees!.first.optionalPaidFees![optionalFeeIndex].date ?? "";
  }

  String installmentPaidDate({required int installmentId}) {
    final installmentIndex = (paidFees ?? []).isEmpty
        ? -1
        : (paidFees!.first.compulsoryPaidFees ?? [])
            .indexWhere((element) => element.installmentId == installmentId);
    if (installmentIndex == -1) {
      return "";
    }
    return paidFees!.first.compulsoryPaidFees![installmentIndex].date ?? "";
  }

  List<AdvanceFee> installmentAdvancePaidAmount({required int installmentId}) {
    final installmentIndex = (paidFees ?? []).isEmpty
        ? -1
        : (paidFees!.first.compulsoryPaidFees ?? [])
            .indexWhere((element) => element.installmentId == installmentId);
    if (installmentIndex == -1) {
      return [];
    }
    return paidFees!.first.compulsoryPaidFees![installmentIndex].advanceFees ??
        [];
  }

  bool hasUserPaidFullFeeWithoutInstallment() {
    return isCompulsoryFeeFullyPaid() &&
        !didUserPaidPreviousCompulsoryFeeInInstallment();
  }

  String fullCompulsoryFeePaidDate() {
    return (paidFees ?? []).isEmpty
        ? ""
        : (paidFees!.first.compulsoryPaidFees ?? []).isEmpty
            ? ""
            : (paidFees!.first.compulsoryPaidFees!.first.date ?? '');
  }
}
