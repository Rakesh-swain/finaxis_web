import 'package:finaxis_web/controllers/applicant_detail_controller.dart';
<<<<<<< HEAD
import 'package:finaxis_web/controllers/platform_controller.dart';
=======
>>>>>>> e6060cf36e158e2cc0ade1de5c3ea57ccd9cc827
import 'package:finaxis_web/views/dashboard/dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../controllers/theme_controller.dart';
import '../../models/applicant_model.dart';
import '../../services/applicant_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/futuristic_layout.dart' hide FuturisticCard;
import '../../widgets/futuristic_table.dart';

class ApplicantsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApplicantsController>(() => ApplicantsController());
    if (!Get.isRegistered<ThemeController>()) {
      Get.put<ThemeController>(ThemeController(), permanent: true);
    }
  }
}

class ApplicantsController extends GetxController {
  final ApplicantService _service = ApplicantService();

  final RxList<ApplicantModel> applicants = <ApplicantModel>[].obs;
  final RxList<ApplicantModel> filtered = <ApplicantModel>[].obs;
  final RxBool isLoading = false.obs;

  // Filters
  final RxString ragFilter = 'all'.obs;
  final RxString loanTypeFilter = 'all'.obs;
  final Rxn<DateTimeRange> dateRange = Rxn<DateTimeRange>();
  final RxString searchQuery = ''.obs; // new search field

  // Sorting
  final RxInt sortColumnIndex = 0.obs;
  final RxBool sortAscending = true.obs;

  final Map<String, String> loanTypeByCif = {};
  static const List<String> loanTypes = [
    'Personal Loan',
    'Home Loan',
    'Auto Loan',
    'Credit Card',
    'Business Loan',
  ];
  final selectedDateFilter = DateFilterType.month.obs;
  final fromDate = Rx<DateTime>(
    DateTime.now().subtract(const Duration(days: 30)),
  );
  final toDate = Rx<DateTime>(DateTime.now());
  @override
  void onInit() {
    super.onInit();
    setDateFilter(DateFilterType.month);
    fetchApplicants();
  }

  void setDateFilter(DateFilterType filterType) {
    selectedDateFilter.value = filterType;

    final now = DateTime.now();

    switch (filterType) {
      case DateFilterType.today:
        final today = DateTime(now.year, now.month, now.day);
        fromDate.value = today;
        toDate.value = today;
        break;

      case DateFilterType.week:
        final endDate = DateTime(now.year, now.month, now.day);
        final startDate = endDate.subtract(const Duration(days: 6));
        fromDate.value = startDate;
        toDate.value = endDate;
        break;

      case DateFilterType.month:
        final endDate = DateTime(now.year, now.month, now.day);
        final startDate = endDate.subtract(const Duration(days: 30));
        fromDate.value = startDate;
        toDate.value = endDate;
        break;

      case DateFilterType.calendar:
        if (fromDate.value.isAfter(toDate.value)) {
          final endDate = DateTime(now.year, now.month, now.day);
          final startDate = endDate.subtract(const Duration(days: 30));
          fromDate.value = startDate;
          toDate.value = endDate;
        }
        break;
    }

    fetchApplicants();
  }

  /// Set From Date
  void setFromDate(DateTime date) {
    fromDate.value = date;

    // Validation: Ensure from date is not after to date
    if (date.isAfter(toDate.value)) {
      toDate.value = date;
    }

    // Only apply restrictions for non-calendar filters
    if (selectedDateFilter.value == DateFilterType.week) {
      // Limit to 7 days
      if (toDate.value.difference(date).inDays > 7) {
        toDate.value = date.add(const Duration(days: 7));
      }
    } else if (selectedDateFilter.value == DateFilterType.month) {
      // Limit to 30 days
      if (toDate.value.difference(date).inDays > 30) {
        toDate.value = date.add(const Duration(days: 30));
      }
    }
    // For calendar mode, allow any range without restrictions
  }

  /// Set To Date - UPDATED
  void setToDate(DateTime date) {
    toDate.value = date;

    // Validation: Ensure to date is not before from date
    if (date.isBefore(fromDate.value)) {
      fromDate.value = date;
    }
    // Only apply restrictions for non-calendar filters
    if (selectedDateFilter.value == DateFilterType.week) {
      // Limit to 7 days
      if (date.difference(fromDate.value).inDays > 7) {
        fromDate.value = date.subtract(const Duration(days: 7));
      }
    } else if (selectedDateFilter.value == DateFilterType.month) {
      // Limit to 30 days
      if (date.difference(fromDate.value).inDays > 30) {
        fromDate.value = date.subtract(const Duration(days: 30));
      }
    }
  }

  Future<void> fetchApplicants() async {
    try {
      isLoading.value = true;
      final data = await _service.fetchApplicants();
      applicants.assignAll(data);
      _augmentLoanTypes();
      applyFilters();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load applicants: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _augmentLoanTypes() {
    for (var i = 0; i < applicants.length; i++) {
      final a = applicants[i];
      loanTypeByCif[a.cif] = loanTypes[i % loanTypes.length];
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query.trim().toLowerCase();
    applyFilters();
  }

  void setRagFilter(String value) {
    ragFilter.value = value;
    applyFilters();
  }

  void setDateRange(DateTimeRange? range) {
    dateRange.value = range;
    applyFilters();
  }

  void clearDateRange() {
    dateRange.value = null;
    applyFilters();
  }

  void clearFilters() {
    ragFilter.value = 'all';
    loanTypeFilter.value = 'all';
    dateRange.value = null;
    searchQuery.value = '';
    applyFilters();
  }

  void applyFilters() {
    Iterable<ApplicantModel> result = applicants;

    // 🔍 Search filter
    if (searchQuery.value.isNotEmpty) {
      result = result.where((a) {
        final query = searchQuery.value;
        return a.cif.toLowerCase().contains(query) ||
            a.name.toLowerCase().contains(query) ||
            a.bankName.toLowerCase().contains(query);
      });
    }

    // RAG filter
    if (ragFilter.value != 'all') {
      result = result.where(
        (a) => a.ragStatus.toLowerCase() == ragFilter.value,
      );
    }

    // Date range filter
    final range = dateRange.value;
    if (range != null) {
      result = result.where(
        (a) =>
            !a.lastUpdated.isBefore(range.start) &&
            !a.lastUpdated.isAfter(range.end),
      );
    }

    filtered.assignAll(result.toList());

    // Maintain sorting
    _sortByIndex(sortColumnIndex.value, sortAscending.value);
  }

  void sortBy<T>(
    Comparable Function(ApplicantModel a) getField,
    int columnIndex,
    bool ascending,
  ) {
    filtered.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    sortColumnIndex.value = columnIndex;
    sortAscending.value = ascending;
  }

  void _sortByIndex(int idx, bool asc) {
    switch (idx) {
      case 0:
        sortBy<String>((a) => a.cif, idx, asc);
        break;
      case 1:
        sortBy<String>((a) => a.name, idx, asc);
        break;
      case 2:
        sortBy<int>((a) => a.creditScore, idx, asc);
        break;
      case 3:
        sortBy<double>((a) => a.riskScore, idx, asc);
        break;
      case 4:
        sortBy<String>((a) => a.ragStatus, idx, asc);
        break;
      case 5:
        sortBy<String>((a) => a.bankName, idx, asc);
        break;
      case 7:
        sortBy<DateTime>((a) => a.lastUpdated, idx, asc);
        break;
      default:
        break;
    }
  }

  void navigateToDetail(String cif) {
<<<<<<< HEAD
    //  Get.toNamed('/assessment/:caseId');
=======
>>>>>>> e6060cf36e158e2cc0ade1de5c3ea57ccd9cc827
    // Check if we're already on detail page
    if (Get.currentRoute.contains('/applicant/')) {
      // We're already on detail page, just switch applicant
      final detailController = Get.find<ApplicantDetailController>();
      detailController.switchToApplicant(cif);
    } else {
      // Navigate to detail page with CIF
      Get.toNamed('/applicant/$cif');
    }
  }
}

class ApplicantsView extends GetView<ApplicantsController> {
  const ApplicantsView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final platformController = Get.find<PlatformController>();
    return FuturisticLayout(
      selectedIndex: 3,
      pageTitle: 'Applicant Portfolio',
      headerActions: [_buildDateFilterSection(context, themeController)],
      child: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: _buildLoadingState(context, themeController));
        }
        return _buildFloatingCardShelf(
          context,
          themeController,
          platformController,
        );
      }),
    );
  }

  Widget _buildDateFilterSection(
    BuildContext context,
    ThemeController themeController,
  ) {
    return Obx(() {
      final selectedFilter = controller.selectedDateFilter.value;
      final fromDate = controller.fromDate.value;
      final toDate = controller.toDate.value;

      return Container(
        // padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          // color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Filter buttons row
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ToggleButtons(
                  isSelected: [
                    selectedFilter == DateFilterType.today,
                    selectedFilter == DateFilterType.week,
                    selectedFilter == DateFilterType.month,
                    selectedFilter == DateFilterType.calendar,
                  ],
                  onPressed: (index) {
                    final filterType = DateFilterType.values[index];
                    controller.setDateFilter(filterType);

                    if (filterType == DateFilterType.calendar) {
                      _showCalendarPicker(context);
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  selectedColor: Colors.white,
                  fillColor: themeController.getThemeData().primaryColor,
                  color: themeController.getThemeData().primaryColor,
                  constraints: const BoxConstraints(
                    minHeight: 36.0,
                    minWidth: 70.0,
                  ),
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('Today'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('Week'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('Month'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('Calendar'),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 🔹 Compact From-To Row (aligned to right)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildDatePickerCard(
                  context,
                  themeController,
                  'From',
                  fromDate,
                  isEnabled: selectedFilter != DateFilterType.today,
                  onTap: selectedFilter != DateFilterType.today
                      ? () => _showDatePicker(context, true)
                      : null,
                  small: true, // custom flag for smaller size
                ),
                const SizedBox(width: 10),
                Icon(
                  Icons.arrow_forward,
                  color: themeController.getThemeData().primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 10),
                _buildDatePickerCard(
                  context,
                  themeController,
                  'To',
                  toDate,
                  isEnabled: selectedFilter != DateFilterType.today,
                  onTap: selectedFilter != DateFilterType.today
                      ? () => _showDatePicker(context, false)
                      : null,
                  small: true,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  /// Build Date Picker Card
  Widget _buildDatePickerCard(
    BuildContext context,
    ThemeController themeController,
    String label,
    DateTime date, {
    bool isEnabled = true,
    VoidCallback? onTap,
    bool small = false, // new flag
  }) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: small ? 6 : 12,
          horizontal: small ? 10 : 16,
        ),
        decoration: BoxDecoration(
          color: isEnabled ? Theme.of(context).cardColor : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: themeController.getThemeData().primaryColor.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_today,
              size: small ? 14 : 18,
              color: themeController.getThemeData().primaryColor,
            ),
            const SizedBox(width: 6),
            Text(
              '${label}: ${DateFormat('dd MMM').format(date)}',
              style: textTheme.bodyMedium?.copyWith(
                fontSize: small ? 13 : 15,
                color: isEnabled
                    ? themeController.getThemeData().primaryColor
                    : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show Date Picker
  Future<void> _showDatePicker(BuildContext context, bool isFromDate) async {
    final selectedFilter = controller.selectedDateFilter.value;
    final currentDate = isFromDate
        ? controller.fromDate.value
        : controller.toDate.value;

    DateTime? firstDate;
    DateTime? lastDate;

    // Set constraints based on filter type
    if (selectedFilter == DateFilterType.week) {
      // For week, limit to 7 days range
      if (isFromDate) {
        firstDate = DateTime(2020);
        lastDate = controller.toDate.value.subtract(const Duration(days: 1));
      } else {
        firstDate = controller.fromDate.value.add(const Duration(days: 1));
        lastDate = controller.fromDate.value.add(const Duration(days: 7));
      }
    } else {
      firstDate = DateTime(2020);
      lastDate = DateTime.now().add(const Duration(days: 365));
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Get.find<ThemeController>().getThemeData().primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      if (isFromDate) {
        controller.setFromDate(picked);

        // Auto-adjust toDate for week filter
        if (selectedFilter == DateFilterType.week) {
          final newToDate = picked.add(const Duration(days: 6));
          if (newToDate.isAfter(DateTime.now())) {
            controller.setToDate(DateTime.now());
          } else {
            controller.setToDate(newToDate);
          }
        }
      } else {
        controller.setToDate(picked);
      }

      controller.fetchApplicants();
    }
  }

  /// Show Calendar Range Picker
  Future<void> _showCalendarPicker(BuildContext context) async {
    final theme = Get.find<ThemeController>().getThemeData();

    // Use Flutter's built-in date range picker wrapped in a Dialog
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(
        start: controller.fromDate.value,
        end: controller.toDate.value,
      ),
      builder: (context, child) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 450, maxHeight: 600),
            child: Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: theme.primaryColor,
                  onPrimary: Colors.white,
                  onSurface: theme.textTheme.bodyLarge?.color ?? Colors.black,
                ),
                dialogTheme: DialogThemeData(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              child: child!,
            ),
          ),
        );
      },
    );

    // Update dates if user selected a range
    if (picked != null) {
      controller.setFromDate(picked.start);
      controller.setToDate(picked.end);
      controller.fetchApplicants();
    }
  }

  Widget _buildFloatingCardShelf(
    BuildContext context,
    ThemeController themeController,
    PlatformController platformController,
  ) {
    final platform = platformController.currentPlatform.value;
    final isLending = platform == PlatformType.lending;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatsRow(context, themeController),
          const SizedBox(height: 32),
          _buildSearchAndFilters(context, themeController),
          const SizedBox(height: 24),
          Obx(
<<<<<<< HEAD
            () => SizedBox(
              height: 600,
              child: FuturisticTable(
                columns: [
                  const FuturisticTableColumn(
                    title: 'Application No.',
                    // icon: Icons.fingerprint_rounded,
                  ),
                  const FuturisticTableColumn(
                    title: 'Name',
                    // icon: Icons.person_rounded,
                  ),
                  // const FuturisticTableColumn(
                  //   title: 'AECB Score',
                  //   // icon: Icons.star_rounded,
                  // ),
                  const FuturisticTableColumn(
                    title: 'Finaxis Credit Score',
                    // icon: Icons.analytics_rounded,
                  ),
                  const FuturisticTableColumn(
                    title: 'Risk Status',
                    // icon: Icons.security_rounded,
                  ),
                  const FuturisticTableColumn(
                    title: 'Loan Amount',
                    // icon: Icons.account_balance_rounded,
                  ),
                  // const FuturisticTableColumn(
                  //   title: 'Loan Type',
                  //   // icon: Icons.category_rounded,
                  // ),
                  const FuturisticTableColumn(
                    title: 'DateTime',
                    // icon: Icons.schedule_rounded,
                  ),
                  const FuturisticTableColumn(title: 'Status', sortable: false),
                ],
                rows: controller.filtered
                    .map(
                      (applicant) => FuturisticTableRow(
                        cells: [
                          FuturisticTableCell(text: applicant.cif),
                          FuturisticTableCell(text: applicant.name),
                          // FuturisticTableCell(
                          //   text: applicant.creditScore.toString() == '0'
                          //       ? ''
                          //       : applicant.creditScore.toString(),
                          //   widget: applicant.creditScore.toString() == '0'
                          //       ? Container(
                          //           padding: const EdgeInsets.symmetric(
                          //             horizontal: 8,
                          //             vertical: 4,
                          //           ),
=======
              () => SizedBox(
                height: 600,
                child: FuturisticTable(
                  columns: [
                    const FuturisticTableColumn(
                      title: 'Application No.',
                      // icon: Icons.fingerprint_rounded,
                    ),
                    const FuturisticTableColumn(
                      title: 'Name',
                      // icon: Icons.person_rounded,
                    ),
                    const FuturisticTableColumn(
                      title: 'AECB Score',
                      // icon: Icons.star_rounded,
                    ),
                    const FuturisticTableColumn(
                      title: 'Finaxis Credit Score',
                      // icon: Icons.analytics_rounded,
                    ),
                    const FuturisticTableColumn(
                      title: 'Risk Status',
                      // icon: Icons.security_rounded,
                    ),
                    const FuturisticTableColumn(
                      title: 'Loan Amount',
                      // icon: Icons.account_balance_rounded,
                    ),
                    // const FuturisticTableColumn(
                    //   title: 'Loan Type',
                    //   // icon: Icons.category_rounded,
                    // ),
                    // const FuturisticTableColumn(
                    //   title: 'Last Updated',
                    //   // icon: Icons.schedule_rounded,
                    // ),
                    const FuturisticTableColumn(
                      title: 'Status',
                      sortable: false,
                    ),
                  ],
                  rows: controller.filtered
                      .map(
                        (applicant) => FuturisticTableRow(
                          cells: [
                            FuturisticTableCell(text: applicant.cif),
                            FuturisticTableCell(text: applicant.name),
                            FuturisticTableCell(
                              text: applicant.creditScore.toString() == '0'
                                  ? ''
                                  : applicant.creditScore.toString(),
                              widget: applicant.creditScore.toString() == '0'
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
>>>>>>> e6060cf36e158e2cc0ade1de5c3ea57ccd9cc827

                          //           child: Text(
                          //             applicant.creditScore.toString() == '0'
                          //                 ? '_'
                          //                 : applicant.creditScore.toString(),
                          //             style:  TextStyle(
                          //               color: isLending
                          //                 ? const Color(0xFF1E3A8A)
                          //                 : const Color(0xFFFFFFFF),
                          //               fontWeight: FontWeight.w600,
                          //               fontSize: 13,
                          //             ),
                          //           ),
                          //         )
                          //       : Container(
                          //           padding: const EdgeInsets.symmetric(
                          //             horizontal: 8,
                          //             vertical: 4,
                          //           ),
                          //           decoration: BoxDecoration(
                          //             gradient: themeController
                          //                 .getPrimaryGradient(),
                          //             borderRadius: BorderRadius.circular(8),
                          //           ),
                          //           child: Text(
                          //             applicant.creditScore.toString(),
                          //             style: const TextStyle(
                          //               color: Colors.white,
                          //               fontWeight: FontWeight.w600,
                          //               fontSize: 13,
                          //             ),
                          //           ),
                          //         ),
                          // ),
                          FuturisticTableCell(
                            text: applicant.riskScore.toString() == '0'
                                ? ''
                                : applicant.riskScore.toString(),
                            widget: applicant.riskScore.toString() == '0'
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),

                                    child: Text(
                                      applicant.riskScore.toString() == '0'
                                          ? '_'
                                          : applicant.riskScore.toString(),
                                      style: TextStyle(
                                        color: isLending
                                            ? const Color(0xFF1E3A8A)
                                            : const Color(0xFFFFFFFF),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  )
                                : Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: themeController
                                          .getPrimaryGradient(),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      applicant.riskScore.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                          ),
                          // FuturisticTableCell(
                          //   text: applicant.riskScore.toStringAsFixed(1),
                          //   widget: Container(
                          //     padding: const EdgeInsets.symmetric(
                          //       horizontal: 8,
                          //       vertical: 4,
                          //     ),
                          //     decoration: BoxDecoration(
                          //       color: AppTheme.getRagColor(
                          //         applicant.ragStatus,
                          //       ).withOpacity(0.2),
                          //       borderRadius: BorderRadius.circular(8),
                          //       border: Border.all(
                          //         color: AppTheme.getRagColor(
                          //           applicant.ragStatus,
                          //         ),
                          //         width: 1,
                          //       ),
                          //     ),
                          //     child: Text(
                          //       applicant.riskScore.toStringAsFixed(1),
                          //       style: TextStyle(
                          //         color: AppTheme.getRagColor(
                          //           applicant.ragStatus,
                          //         ),
                          //         fontWeight: FontWeight.w600,
                          //         fontSize: 13,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          FuturisticTableCell(
                            text: applicant.ragStatus.isEmpty
                                ? ''
                                : applicant.ragStatus,
                            widget: applicant.ragStatus.isEmpty
                                ? Text(
                                    applicant.ragStatus.isEmpty
                                        ? '_'
                                        : applicant.ragStatus,
                                    style: TextStyle(
                                      color: isLending
                                          ? const Color(0xFF1E3A8A)
                                          : const Color(0xFFFFFFFF),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  )
                                : Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.getRagColor(
                                        applicant.ragStatus,
                                      ),
                                      // borderRadius: BorderRadius.circular(50),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppTheme.getRagColor(
                                          applicant.ragStatus,
<<<<<<< HEAD
                                        ),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: AppTheme.getRagColor(
                                              applicant.ragStatus,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        // Text(
                                        //   applicant.ragStatus.toUpperCase() ==
                                        //           "GREEN"
                                        //       ? "Low"
                                        //       : applicant.ragStatus
                                        //                 .toUpperCase() ==
                                        //             "AMBER"
                                        //       ? "Medium"
                                        //       : "High",
                                        //   style: TextStyle(
                                        //     color: AppTheme.getRagColor(
                                        //       applicant.ragStatus,
                                        //     ),
                                        //     fontWeight: FontWeight.w700,
                                        //     fontSize: 11,
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                          ),
                          FuturisticTableCell(
                            text: applicant.bankName.isEmpty ? '' : '5,00,000',
                            widget: applicant.creditScore.toString() == '0'
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),

                                    child: Text(
                                      applicant.bankName.toString() == ''
                                          ? '_'
                                          : applicant.bankName.toString(),
                                      style: TextStyle(
                                        color: isLending
                                            ? const Color(0xFF1E3A8A)
                                            : const Color(0xFFFFFFFF),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  )
                                : Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: themeController
                                          .getPrimaryGradient(),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '150,000.00',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                          ),
                          // FuturisticTableCell(
                          //   text:
                          //       controller.loanTypeByCif[applicant.cif] ??
                          //       'Unknown',
                          //   widget: Container(
                          //     padding: const EdgeInsets.symmetric(
                          //       horizontal: 8,
                          //       vertical: 4,
                          //     ),
                          //     decoration: BoxDecoration(
                          //       color: Theme.of(
                          //         context,
                          //       ).primaryColor.withOpacity(0.1),
                          //       borderRadius: BorderRadius.circular(8),
                          //       border: Border.all(
                          //         color: Theme.of(
                          //           context,
                          //         ).primaryColor.withOpacity(0.3),
                          //         width: 1,
                          //       ),
                          //     ),
                          //     child: Text(
                          //       controller.loanTypeByCif[applicant.cif] ??
                          //           'Unknown',
                          //       style: TextStyle(
                          //         color: Theme.of(context).primaryColor,
                          //         fontWeight: FontWeight.w500,
                          //         fontSize: 12,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          FuturisticTableCell(
                            text: DateFormat(
                              'MMM dd, yy',
                            ).format(applicant.lastUpdated),
                            widget: Text(
                              DateFormat(
                                'MMM dd, yy',
                              ).format(applicant.lastUpdated),
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                                fontSize: 13,
                              ),
                            ),
                          ),
                         FuturisticTableCell(
                            text: applicant.status,
                            widget: SizedBox(
                              width: 105, 
                              child: ElevatedButton.icon(
                                onPressed: () =>
                                    () => controller.navigateToDetail(
                                      applicant.cif,
                                    ),
=======
                                        ),
                                        // borderRadius: BorderRadius.circular(50),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppTheme.getRagColor(
                                            applicant.ragStatus,
                                          ),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              color: AppTheme.getRagColor(
                                                applicant.ragStatus,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          // Text(
                                          //   applicant.ragStatus.toUpperCase() ==
                                          //           "GREEN"
                                          //       ? "Low"
                                          //       : applicant.ragStatus
                                          //                 .toUpperCase() ==
                                          //             "AMBER"
                                          //       ? "Medium"
                                          //       : "High",
                                          //   style: TextStyle(
                                          //     color: AppTheme.getRagColor(
                                          //       applicant.ragStatus,
                                          //     ),
                                          //     fontWeight: FontWeight.w700,
                                          //     fontSize: 11,
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                            ),
                            FuturisticTableCell(
                              text: applicant.bankName.isEmpty
                                  ? ''
                                  : '5,00,000',
                              widget: applicant.creditScore.toString() == '0'
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),

                                      child: Text(
                                        applicant.bankName.toString() == ''
                                            ? '_'
                                            : applicant.bankName.toString(),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: themeController
                                            .getPrimaryGradient(),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '5,00,000',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                            ),
                            // FuturisticTableCell(
                            //   text:
                            //       controller.loanTypeByCif[applicant.cif] ??
                            //       'Unknown',
                            //   widget: Container(
                            //     padding: const EdgeInsets.symmetric(
                            //       horizontal: 8,
                            //       vertical: 4,
                            //     ),
                            //     decoration: BoxDecoration(
                            //       color: Theme.of(
                            //         context,
                            //       ).primaryColor.withOpacity(0.1),
                            //       borderRadius: BorderRadius.circular(8),
                            //       border: Border.all(
                            //         color: Theme.of(
                            //           context,
                            //         ).primaryColor.withOpacity(0.3),
                            //         width: 1,
                            //       ),
                            //     ),
                            //     child: Text(
                            //       controller.loanTypeByCif[applicant.cif] ??
                            //           'Unknown',
                            //       style: TextStyle(
                            //         color: Theme.of(context).primaryColor,
                            //         fontWeight: FontWeight.w500,
                            //         fontSize: 12,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // FuturisticTableCell(
                            //   text: DateFormat(
                            //     'MMM dd, yy',
                            //   ).format(applicant.lastUpdated),
                            //   widget: Text(
                            //     DateFormat(
                            //       'MMM dd, yy',
                            //     ).format(applicant.lastUpdated),
                            //     style: TextStyle(
                            //       color: Theme.of(context)
                            //           .textTheme
                            //           .bodyMedium
                            //           ?.color
                            //           ?.withOpacity(0.7),
                            //       fontSize: 13,
                            //     ),
                            //   ),
                            // ),
                            FuturisticTableCell(
                              text: applicant.mobile?.isEmpty ?? true
                                  ? 'Pending'
                                  : 'Approved',
                              widget: ElevatedButton.icon(
                                onPressed: (applicant.mobile?.isEmpty ?? true)
                                    ? null // disable button if mobile is empty
                                    : () =>
                                          controller.navigateToDetail(
                                            applicant.cif,
                                          ),
>>>>>>> e6060cf36e158e2cc0ade1de5c3ea57ccd9cc827
                                icon: Icon(
                                  applicant.status == "Approved"
                                      ? Icons.check_box
                                      : applicant.status == "Pending"
                                      ? Icons.hourglass_empty_rounded
<<<<<<< HEAD
                                      : applicant.status == "New"?Icons.new_label:Icons.cancel,
                                  size: 16,
                                ),
                                label: Text(applicant.status),
=======
                                      : Icons.check_box,
                                  size: 16,
                                ),
                                label: Text(
                                  (applicant.mobile?.isEmpty ?? true)
                                      ? 'Pending'
                                      : 'Approved',
                                ),
>>>>>>> e6060cf36e158e2cc0ade1de5c3ea57ccd9cc827
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: applicant.status == "Pending"
                                      ? Colors.grey
                                      : applicant.status == "Rejected"?Colors.red:themeController
                                            .getThemeData()
                                            .primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  textStyle: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
                onRowTap: (index) =>
                    controller.navigateToDetail(controller.filtered[index].cif),
                isLoading: controller.isLoading.value,
                emptyMessage: 'No applicants found',
                sortColumnIndex: controller.sortColumnIndex.value,
                sortAscending: controller.sortAscending.value,
                onSort: (columnIndex, ascending) {
                  controller.sortColumnIndex.value = columnIndex;
                  controller.sortAscending.value = ascending;
                  controller._sortByIndex(columnIndex, ascending);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, ThemeController themeController) {
    final platformController = Get.find<PlatformController>();
    final total = controller.filtered.length;
    final greenCount = controller.filtered
        .where((a) => a.ragStatus.toLowerCase() == 'green')
        .length;
    final amberCount = controller.filtered
        .where((a) => a.ragStatus.toLowerCase() == 'amber')
        .length;
    final redCount = controller.filtered
        .where((a) => a.ragStatus.toLowerCase() == 'red')
        .length;

    return Row(
      children: [
        platformController.isBilling
            ? Expanded(
                child: _buildStatCardWithInfo(
                  'Total EMIs',
                  '8',
                  Icons.people,
                  themeController.getPrimaryGradient(),
                  'Count of all EMI transactions currently in the system.',
                ),
              )
            : Expanded(
                child: _buildStatCardWithInfo(
                  'Total Applicants',
                  total.toString(),
                  Icons.people,
                  themeController.getPrimaryGradient(),
                  'Count of all applicants currently in the system.',
                ),
              ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCardWithInfo(
            'Low Risk',
            greenCount.toString(),
            Icons.check_circle,
            const LinearGradient(colors: [Colors.green, Colors.teal]),
            'Applicants with strong financial health; consent is automatically triggered.',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCardWithInfo(
            'Medium Risk',
            amberCount.toString(),
            Icons.warning,
            const LinearGradient(colors: [Colors.amber, Colors.orange]),
            'Applicants requiring manual review; consent must be sent manually.',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCardWithInfo(
            'High Risk',
            redCount.toString(),
            Icons.error,
            const LinearGradient(colors: [Colors.red, Colors.deepOrange]),
            'Applicants with weak credit or high DSR; the system auto-rejects their requests.',
          ),
        ),
      ],
    );
  }

  Widget _buildStatCardWithInfo(
    String title,
    String value,
    IconData icon,
    LinearGradient gradient,
    String infoText,
  ) {
    return _buildStatCard(
      title,
      value,
      icon,
      gradient,
      infoText,
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    LinearGradient gradient,
    String infoText,
  ) {
    return FuturisticCard(
      height: 130,
      gradient: gradient,
      child: Stack(
        children: [
          // Main content - centered
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 26),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Info icon in top-right with tooltip only on hover
          Positioned(
            top: 8,
            right: 8,
            child: Tooltip(
              message: infoText,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(top: 12),
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(4),
                  child: const Icon(
                    Icons.info_outlined,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildSearchAndFilters(
    BuildContext context,
    ThemeController themeController,
  ) {
    return Row(
      children: [
        // 🔍 Search bar
        Expanded(
          flex: 2,
          child: FuturisticCard(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Icon(
                  Icons.search_rounded,
                  color: themeController.getThemeData().primaryColor,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    onChanged: controller.setSearchQuery,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search by CIF, Name or Bank',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(flex: 2, child: Container()),
        // Expanded(
        //   flex: 3,
        //   child: Obx(() {
        //     return Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Wrap(
        //           spacing: 12,
        //           children: [
        //             _buildFilterChip('All', 'all'),
        //             _buildFilterChip('Low', 'green', Colors.green),
        //             _buildFilterChip('Medium', 'amber', Colors.amber),
        //             _buildFilterChip('High', 'red', Colors.red),
        //           ],
        //         ),
        //         // 📅 Date Filter
        //         Tooltip(
        //           message: 'Filter by Date',
        //           child: InkWell(
        //             onTap: () async {
        //               final now = DateTime.now();
        //               final picked = await showDateRangePicker(
        //                 context: context,
        //                 initialDateRange: controller.dateRange.value ??
        //                     DateTimeRange(
        //                       start: now.subtract(const Duration(days: 30)),
        //                       end: now,
        //                     ),
        //                 firstDate: DateTime(now.year - 2),
        //                 lastDate: DateTime(now.year + 1),
        //               );
        //               if (picked != null) controller.setDateRange(picked);
        //             },
        //             onLongPress: controller.clearDateRange,
        //             borderRadius: BorderRadius.circular(20),
        //             child: Container(
        //               padding: const EdgeInsets.symmetric(
        //                   horizontal: 16, vertical: 8),
        //               decoration: BoxDecoration(
        //                 borderRadius: BorderRadius.circular(20),
        //                 border: Border.all(
        //                     color: themeController
        //                         .getThemeData()
        //                         .primaryColor
        //                         .withOpacity(0.3)),
        //                 color: controller.dateRange.value == null
        //                     ? Colors.transparent
        //                     : themeController
        //                         .getThemeData()
        //                         .primaryColor
        //                         .withOpacity(0.1),
        //               ),
        //               child: Row(
        //                 children: [
        //                   const Icon(Icons.calendar_today, size: 16),
        //                   const SizedBox(width: 6),
        //                   Text(
        //                     controller.dateRange.value == null
        //                         ? 'Date Range'
        //                         : '${DateFormat('MMM dd').format(controller.dateRange.value!.start)} - ${DateFormat('MMM dd').format(controller.dateRange.value!.end)}',
        //                     style: const TextStyle(fontWeight: FontWeight.w600),
        //                   ),
        //                   if (controller.dateRange.value != null) ...[
        //                     const SizedBox(width: 6),
        //                     GestureDetector(
        //                       onTap: controller.clearDateRange,
        //                       child: const Icon(Icons.close, size: 16),
        //                     ),
        //                   ]
        //                 ],
        //               ),
        //             ),
        //           ),
        //         ),
        //       ],
        //     );
        //   }),
        // ),
      ],
    );
  }

  Widget _buildFilterChip(String label, String value, [Color? color]) {
    final themeController = Get.find<ThemeController>();
    final selected = controller.ragFilter.value == value;
    final chipColor = color ?? themeController.getThemeData().primaryColor;
    return GestureDetector(
      onTap: () => controller.setRagFilter(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? chipColor.withOpacity(0.2) : Colors.transparent,
          border: Border.all(
            color: selected ? chipColor : chipColor.withOpacity(0.3),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? chipColor : Colors.black87,
            fontWeight: selected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(
    BuildContext context,
    ThemeController themeController,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            themeController.getThemeData().primaryColor,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Loading Applicant Portfolio...',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
