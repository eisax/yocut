class Student {
  final bool valid;
  final String message;
  final StudentBody body;

  Student({required this.valid, required this.message, required this.body});

  factory Student.fromJson(Map<String, dynamic> json) => Student(
    valid: json['valid'] ?? false,
    message: json['message'] ?? '',
    body: StudentBody.fromJson(Map<String, dynamic>.from(json['body'] ?? {})),
  );

  Map<String, dynamic> toJson() {
    return {'valid': valid, 'message': message, 'body': body.toJson()};
  }
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
    registration: Registration.fromJson(
      Map<String, dynamic>.from(json['registration'] ?? {}),
    ),
    vle: VLE.fromJson(Map<String, dynamic>.from(json['vle'] ?? {})),
    accounts: Accounts.fromJson(Map<String, dynamic>.from(json['accounts'] ?? {})),
    bursary: Bursary.fromJson(Map<String, dynamic>.from(json['bursary'] ?? {})),
    bankRate: BankRate.fromJson(Map<String, dynamic>.from(json['bankRate'] ?? {})),
    notice: (json['notice'] as List<dynamic>?)
            ?.map((e) => e is Map<String, dynamic> ? Notice.fromJson(e) : Notice.fromJson({}))
            .toList() ?? [],

    profile: Profile.fromJson(Map<String, dynamic>.from(json['profile'] ?? {})),
  );

  Map<String, dynamic> toJson() {
    return {
      'registration': registration.toJson(),
      'vle': vle.toJson(),
      'accounts': accounts.toJson(),
      'bursary': bursary.toJson(),
      'bankRate': bankRate.toJson(),
      'notice': notice.map((e) => e.toJson()).toList(),
      'profile': profile.toJson(),
    };
  }
}

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
    period: Period.fromJson(Map<String, dynamic>.from(json['period'] ?? {})),
    program: Program.fromJson(Map<String, dynamic>.from(json['program'] ?? {})),
  modules: (json['modules'] as List<dynamic>?)
            ?.map((e) => e is Map<String, dynamic> ? Module.fromJson(e) : Module.fromJson({}))
            .toList() ?? [],


    isRegistered: json['is_registered'] ?? false,
    exemption: json['exemption'] ?? [],
  );

  Map<String, dynamic> toJson() {
    return {
      'period': period.toJson(),
      'program': program.toJson(),
      'modules': modules.map((e) => e.toJson()).toList(),
      'is_registered': isRegistered,
      'exemption': exemption,
    };
  }
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
    periodId: json['period_id'] ?? '',
    currentSession: json['current_session'] ?? '',
    startDate: json['start_date'] ?? '',
    endDate: json['end_date'] ?? '',
    periodName: json['period_name'] ?? '',
    period: json['period'] ?? '',
    active: json['active'] ?? '',
  );

  Map<String, dynamic> toJson() {
    return {
      'period_id': periodId,
      'current_session': currentSession,
      'start_date': startDate,
      'end_date': endDate,
      'period_name': periodName,
      'period': period,
      'active': active,
    };
  }
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
    attendanceTypeName: json['attendance_type_name'] ?? '',
    programmeName: json['programme_name'] ?? '',
    programmeCode: json['programme_code'] ?? '',
    facultyId: json['faculty_id'] ?? '',
    programmeId: json['programme_id'] ?? '',
    facultyName: json['faculty_name'] ?? '',
    facultyCode: json['faculty_code'] ?? '',
    level: json['level'] ?? '',
    completed: json['completed'] ?? false,
  );

  Map<String, dynamic> toJson() {
    return {
      'attendance_type_name': attendanceTypeName,
      'programme_name': programmeName,
      'programme_code': programmeCode,
      'faculty_id': facultyId,
      'programme_id': programmeId,
      'faculty_name': facultyName,
      'faculty_code': facultyCode,
      'level': level,
      'completed': completed,
    };
  }
}

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
    moduleName: json['module_name'] ?? '',
    moduleId: json['module_id'] ?? '',
    moduleCode: json['module_code'] ?? '',
    moduleUnitCode: json['module_unit_code'] ?? '',
    periodId: json['period_id'] ?? '',
    isEvaluable: json['is_evaluable'] ?? '',
    pastExamPapers:
        (json['past_exam_papers'] as List?)
            ?.map((e) => PastExamPaper.fromJson(e ?? {}))
            .toList() ??
        [],
    vleStatus: json['vle_status'] ?? false,
  );

  Map<String, dynamic> toJson() {
    return {
      'module_name': moduleName,
      'module_id': moduleId,
      'module_code': moduleCode,
      'module_unit_code': moduleUnitCode,
      'period_id': periodId,
      'is_evaluable': isEvaluable,
      'past_exam_papers': pastExamPapers.map((e) => e.toJson()).toList(),
      'vle_status': vleStatus,
    };
  }
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
    pastExamPaperId: json['past_exam_paper_id'] ?? '',
    year: json['year'] ?? '',
    description: json['description'] ?? '',
    documentSize: json['document_size'] ?? '',
    periodId: json['period_id'] ?? '',
    documentPath: json['document_path'] ?? '',
  );

  Map<String, dynamic> toJson() {
    return {
      'past_exam_paper_id': pastExamPaperId,
      'year': year,
      'description': description,
      'document_size': documentSize,
      'period_id': periodId,
      'document_path': documentPath,
    };
  }
}

class VLE {
  final bool status;
  final int classesReady;

  VLE({required this.status, required this.classesReady});

  factory VLE.fromJson(Map<String, dynamic> json) => VLE(
    status: json['status'] ?? false,
    classesReady: json['classes_ready'] ?? 0,
  );

  Map<String, dynamic> toJson() {
    return {'status': status, 'classes_ready': classesReady};
  }
}

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
    wifi: json['wifi'] ?? false,
    studentIdCard: json['student_id_card'] ?? false,
    canteen: json['canteen'] ?? false,
    accomodation: json['accomodation'], // Assuming accomodation can be nullable
  );

  Map<String, dynamic> toJson() {
    return {
      'wifi': wifi,
      'student_id_card': studentIdCard,
      'canteen': canteen,
      'accomodation': accomodation,
    };
  }
}

class Bursary {
  final String pastelAccount;
  final List<Statement> statements;

  Bursary({required this.pastelAccount, required this.statements});

  factory Bursary.fromJson(Map<String, dynamic> json) => Bursary(
    pastelAccount: json['pastel_account'] ?? '',
  statements: (json['statements'] as List<dynamic>?)
            ?.map((e) => e is Map<String, dynamic> ? Statement.fromJson(e) : Statement.fromJson({}))
            .toList() ?? [],

  );

  Map<String, dynamic> toJson() {
    return {
      'pastel_account': pastelAccount,
      'statements': statements.map((e) => e.toJson()).toList(),
    };
  }
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
    debit: json['debit'] ?? '',
    credit: json['credit'] ?? '',
    transactionDate: json['transaction_date'] ?? '',
    transactionDescription: json['transaction_description'] ?? '',
    referenceNumber: json['reference_number'] ?? '',
  );

  Map<String, dynamic> toJson() {
    return {
      'debit': debit,
      'credit': credit,
      'transaction_date': transactionDate,
      'transaction_description': transactionDescription,
      'reference_number': referenceNumber,
    };
  }
}

class BankRate {
  final String rate;

  BankRate({required this.rate});

  factory BankRate.fromJson(Map<String, dynamic> json) =>
      BankRate(rate: json['rate'] ?? '');

  Map<String, dynamic> toJson() {
    return {'rate': rate};
  }
}

class Notice {
  final String title;
  final String date;
  final String description;

  Notice({required this.title, required this.date, required this.description});

  factory Notice.fromJson(Map<String, dynamic> json) => Notice(
    title: json['title'] ?? '',
    date: json['date'] ?? '',
    description: json['description'] ?? '',
  );

  Map<String, dynamic> toJson() {
    return {'title': title, 'date': date, 'description': description};
  }
}

class Profile {
  final String name;
  final String idNumber;
  final String gender;
  final String courseOfStudy;
  final String yearOfStudy;

  Profile({
    required this.name,
    required this.idNumber,
    required this.gender,
    required this.courseOfStudy,
    required this.yearOfStudy,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    name: json['name'] ?? '',
    idNumber: json['id_number'] ?? '',
    gender: json['gender'] ?? '',
    courseOfStudy: json['course_of_study'] ?? '',
    yearOfStudy: json['year_of_study'] ?? '',
  );

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id_number': idNumber,
      'gender': gender,
      'course_of_study': courseOfStudy,
      'year_of_study': yearOfStudy,
    };
  }
}
