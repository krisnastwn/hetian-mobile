class Leave {
  final String id;
  final String employeeId;
  final String requestDate;
  final String startDate;
  final String endDate;
  final String reason;
  final String managerApproval;
  final String hrdApproval;

  Leave({
    required this.id,
    required this.employeeId,
    required this.requestDate,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.managerApproval,
    required this.hrdApproval,
  });
}
