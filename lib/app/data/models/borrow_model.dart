class BorrowHistoryResponse {
  bool status;
  String message;
  BorrowHistoryData? data;

  BorrowHistoryResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory BorrowHistoryResponse.fromJson(Map<String, dynamic> json) {
    return BorrowHistoryResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? BorrowHistoryData.fromJson(json['data'])
          : null,
    );
  }
}

class BorrowHistoryData {
  BorrowUserInfo user;
  BorrowPagination borrowings;

  BorrowHistoryData({required this.user, required this.borrowings});

  factory BorrowHistoryData.fromJson(Map<String, dynamic> json) {
    return BorrowHistoryData(
      user: BorrowUserInfo.fromJson(json['user'] ?? {}),
      borrowings: BorrowPagination.fromJson(json['borrowings'] ?? {}),
    );
  }
}

class BorrowUserInfo {
  int id;
  String name;
  String email;
  String? nis;

  BorrowUserInfo({
    required this.id,
    required this.name,
    required this.email,
    this.nis,
  });

  factory BorrowUserInfo.fromJson(Map<String, dynamic> json) {
    return BorrowUserInfo(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      nis: json['nis'],
    );
  }
}

class BorrowPagination {
  List<BorrowData> data;
  int currentPage;
  int lastPage;
  int total;

  BorrowPagination({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  factory BorrowPagination.fromJson(Map<String, dynamic> json) {
    return BorrowPagination(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => BorrowData.fromJson(item))
              .toList() ??
          [],
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      total: json['total'] ?? 0,
    );
  }
}

class BorrowData {
  int id;
  int userId;
  String borrowCode;
  String borrowDate;
  String dueDate;
  String status;
  String? notes;
  List<BorrowBookData> books;

  BorrowData({
    required this.id,
    required this.userId,
    required this.borrowCode,
    required this.borrowDate,
    required this.dueDate,
    required this.status,
    this.notes,
    required this.books,
  });

  factory BorrowData.fromJson(Map<String, dynamic> json) {
    return BorrowData(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      borrowCode: json['borrow_code'] ?? '',
      borrowDate: json['borrow_date'] ?? '',
      dueDate: json['due_date'] ?? '',
      status: json['status'] ?? '',
      notes: json['notes'],
      books:
          (json['books'] as List<dynamic>?)
              ?.map((item) => BorrowBookData.fromJson(item))
              .toList() ??
          [],
    );
  }

  String get statusLabel {
    switch (status) {
      case 'pending':
        return 'Menunggu';
      case 'borrowed':
        return 'Dipinjam';
      case 'returned':
        return 'Dikembalikan';
      case 'overdue':
        return 'Terlambat';
      default:
        return status;
    }
  }
}

class BorrowBookData {
  int id;
  String title;
  String cover;
  int? pivotQuantity;

  BorrowBookData({
    required this.id,
    required this.title,
    required this.cover,
    this.pivotQuantity,
  });

  factory BorrowBookData.fromJson(Map<String, dynamic> json) {
    return BorrowBookData(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      cover: json['cover'] ?? '',
      pivotQuantity: json['pivot']?['quantity'],
    );
  }
}
