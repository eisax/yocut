// Main Model
class StudentData {
  final bool valid;
  final String message;
  final StudentBody body;

  StudentData({required this.valid, required this.message, required this.body});

  factory StudentData.fromJson(Map<String, dynamic> json) => StudentData(
    valid: json['valid'],
    message: json['message'],
    body: StudentBody.fromJson(json['body']),
  );
}

class StudentBody {
  final Registration registration;
  final VLE vle;
  final Accounts accounts;
  final Bursary bursary;
  final BankRate bankRate;
  final List<Notice> notice;
  final Profile profile;

  StudentBody({
    required this.registration,
    required this.vle,
    required this.accounts,
    required this.bursary,
    required this.bankRate,
    required this.notice,
    required this.profile,
  });

  factory StudentBody.fromJson(Map<String, dynamic> json) => StudentBody(
    registration: Registration.fromJson(json['registration']),
    vle: VLE.fromJson(json['vle']),
    accounts: Accounts.fromJson(json['accounts']),
    bursary: Bursary.fromJson(json['bursary']),
    bankRate: BankRate.fromJson(json['bankRate']),
    notice: (json['notice'] as List).map((e) => Notice.fromJson(e)).toList(),
    profile: Profile.fromJson(json['profile']),
  );
}

// Registration
class Registration {
  final Period period;
  final Program program;
  final List<Module> modules;
  final bool isRegistered;
  final List<dynamic> exemption;

  Registration({
    required this.period,
    required this.program,
    required this.modules,
    required this.isRegistered,
    required this.exemption,
  });

  factory Registration.fromJson(Map<String, dynamic> json) => Registration(
    period: Period.fromJson(json['period']),
    program: Program.fromJson(json['program']),
    modules: (json['modules'] as List).map((e) => Module.fromJson(e)).toList(),
    isRegistered: json['is_registered'],
    exemption: json['exemption'],
  );
}

class Period {
  final String periodId;
  final String currentSession;
  final String startDate;
  final String endDate;
  final String periodName;
  final String period;
  final String active;

  Period({
    required this.periodId,
    required this.currentSession,
    required this.startDate,
    required this.endDate,
    required this.periodName,
    required this.period,
    required this.active,
  });

  factory Period.fromJson(Map<String, dynamic> json) => Period(
    periodId: json['period_id'],
    currentSession: json['current_session'],
    startDate: json['start_date'],
    endDate: json['end_date'],
    periodName: json['period_name'],
    period: json['period'],
    active: json['active'],
  );
}

class Program {
  final String attendanceTypeName;
  final String programmeName;
  final String programmeCode;
  final String facultyId;
  final String programmeId;
  final String facultyName;
  final String facultyCode;
  final String level;
  final bool completed;

  Program({
    required this.attendanceTypeName,
    required this.programmeName,
    required this.programmeCode,
    required this.facultyId,
    required this.programmeId,
    required this.facultyName,
    required this.facultyCode,
    required this.level,
    required this.completed,
  });

  factory Program.fromJson(Map<String, dynamic> json) => Program(
    attendanceTypeName: json['attendance_type_name'],
    programmeName: json['programme_name'],
    programmeCode: json['programme_code'],
    facultyId: json['faculty_id'],
    programmeId: json['programme_id'],
    facultyName: json['faculty_name'],
    facultyCode: json['faculty_code'],
    level: json['level'],
    completed: json['completed'],
  );
}

// Module
class Module {
  final String moduleName;
  final String moduleId;
  final String moduleCode;
  final String moduleUnitCode;
  final String periodId;
  final String isEvaluable;
  final List<PastExamPaper> pastExamPapers;
  final bool vleStatus;

  Module({
    required this.moduleName,
    required this.moduleId,
    required this.moduleCode,
    required this.moduleUnitCode,
    required this.periodId,
    required this.isEvaluable,
    required this.pastExamPapers,
    required this.vleStatus,
  });

  factory Module.fromJson(Map<String, dynamic> json) => Module(
    moduleName: json['module_name'],
    moduleId: json['module_id'],
    moduleCode: json['module_code'],
    moduleUnitCode: json['module_unit_code'],
    periodId: json['period_id'],
    isEvaluable: json['is_evaluable'],
    pastExamPapers:
        (json['past_exam_papers'] as List)
            .map((e) => PastExamPaper.fromJson(e))
            .toList(),
    vleStatus: json['vle_status'],
  );
}

class PastExamPaper {
  final String pastExamPaperId;
  final String year;
  final String description;
  final String documentSize;
  final String periodId;
  final String documentPath;

  PastExamPaper({
    required this.pastExamPaperId,
    required this.year,
    required this.description,
    required this.documentSize,
    required this.periodId,
    required this.documentPath,
  });

  factory PastExamPaper.fromJson(Map<String, dynamic> json) => PastExamPaper(
    pastExamPaperId: json['past_exam_paper_id'],
    year: json['year'],
    description: json['description'],
    documentSize: json['document_size'],
    periodId: json['period_id'],
    documentPath: json['document_path'],
  );
}

// VLE
class VLE {
  final bool status;
  final int classesReady;

  VLE({required this.status, required this.classesReady});

  factory VLE.fromJson(Map<String, dynamic> json) =>
      VLE(status: json['status'], classesReady: json['classes_ready']);
}

// Accounts
class Accounts {
  final bool wifi;
  final bool studentIdCard;
  final bool canteen;
  final dynamic accomodation;

  Accounts({
    required this.wifi,
    required this.studentIdCard,
    required this.canteen,
    this.accomodation,
  });

  factory Accounts.fromJson(Map<String, dynamic> json) => Accounts(
    wifi: json['wifi'],
    studentIdCard: json['student_id_card'],
    canteen: json['canteen'],
    accomodation: json['accomodation'],
  );
}

// Bursary
class Bursary {
  final String pastelAccount;
  final List<Statement> statements;

  Bursary({required this.pastelAccount, required this.statements});

  factory Bursary.fromJson(Map<String, dynamic> json) => Bursary(
    pastelAccount: json['pastel_account'],
    statements:
        (json['statements'] as List).map((e) => Statement.fromJson(e)).toList(),
  );
}

class Statement {
  final String debit;
  final String credit;
  final String transactionDate;
  final String transactionDescription;
  final String referenceNumber;

  Statement({
    required this.debit,
    required this.credit,
    required this.transactionDate,
    required this.transactionDescription,
    required this.referenceNumber,
  });

  factory Statement.fromJson(Map<String, dynamic> json) => Statement(
    debit: json['debit'],
    credit: json['credit'],
    transactionDate: json['transaction_date'],
    transactionDescription: json['transaction_description'],
    referenceNumber: json['reference_number'],
  );
}

// Bank Rate
class BankRate {
  final String rate;

  BankRate({required this.rate});

  factory BankRate.fromJson(Map<String, dynamic> json) =>
      BankRate(rate: json['rate']);
}

// Notice
class Notice {
  final String title;
  final String body;
  final String date;
  final String link;
  final int certificationId;

  Notice({
    required this.title,
    required this.body,
    required this.date,
    required this.link,
    required this.certificationId,
  });

  factory Notice.fromJson(Map<String, dynamic> json) => Notice(
    title: json['title'],
    body: json['body'],
    date: json['date'],
    link: json['link'],
    certificationId: json['certification_id'],
  );
}

// Profile
class Profile {
  final String firstName;
  final String surname;
  final String nationality;
  final String nationalId;
  final String placeOfBirth;
  final String citizenship;
  final String permanantAddress;
  final String passportNumber;
  final String emailAddress;
  final String phoneNumbers;
  final String contactAddress;
  final String permanentHomeAddress;
  final String dateOfBirth;
  final String maritalStatus;
  final String religion;
  final String title;
  final String sex;
  final String studentId;
  final String radioFrequencyId;

  Profile({
    required this.firstName,
    required this.surname,
    required this.nationality,
    required this.nationalId,
    required this.placeOfBirth,
    required this.citizenship,
    required this.permanantAddress,
    required this.passportNumber,
    required this.emailAddress,
    required this.phoneNumbers,
    required this.contactAddress,
    required this.permanentHomeAddress,
    required this.dateOfBirth,
    required this.maritalStatus,
    required this.religion,
    required this.title,
    required this.sex,
    required this.studentId,
    required this.radioFrequencyId,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    firstName: json['first_name'],
    surname: json['surname'],
    nationality: json['nationality'],
    nationalId: json['national_id'],
    placeOfBirth: json['place_of_birth'],
    citizenship: json['citizenship'],
    permanantAddress: json['permanant_address'],
    passportNumber: json['passport_number'],
    emailAddress: json['email_address'],
    phoneNumbers: json['phone_numbers'],
    contactAddress: json['contact_address'],
    permanentHomeAddress: json['permanent_home_address'],
    dateOfBirth: json['date_of_birth'],
    maritalStatus: json['marital_status'],
    religion: json['religion'],
    title: json['title'],
    sex: json['sex'],
    studentId: json['student_id'],
    radioFrequencyId: json['radio_frequency_id'],
  );
}
