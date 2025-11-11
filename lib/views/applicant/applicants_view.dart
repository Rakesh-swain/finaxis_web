import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../controllers/theme_controller.dart';
import '../../models/applicant_model.dart';
import '../../services/applicant_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/futuristic_layout.dart';
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

  @override
  void onInit() {
    super.onInit();
    fetchApplicants();
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
      result =
          result.where((a) => a.ragStatus.toLowerCase() == ragFilter.value);
    }

    // Date range filter
    final range = dateRange.value;
    if (range != null) {
      result = result.where((a) =>
          !a.lastUpdated.isBefore(range.start) &&
          !a.lastUpdated.isAfter(range.end));
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
    Get.toNamed('/applicant/$cif');
  }
}

class ApplicantsView extends GetView<ApplicantsController> {
  const ApplicantsView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return FuturisticLayout(
      selectedIndex: 2,
      pageTitle: 'Applicant Portfolio',
      child: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: _buildLoadingState(context, themeController));
        }
        return _buildFloatingCardShelf(context, themeController);
      }),
    );
  }

  Widget _buildFloatingCardShelf(
    BuildContext context,
    ThemeController themeController,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatsRow(context, themeController),
          const SizedBox(height: 32),
          _buildSearchAndFilters(context, themeController),
          const SizedBox(height: 24),
          Obx(
              () => SizedBox(
                height: 600,
                child: FuturisticTable(
                  columns: [
                    const FuturisticTableColumn(
                      title: 'CIF',
                      // icon: Icons.fingerprint_rounded,
                    ),
                    const FuturisticTableColumn(
                      title: 'Name',
                      // icon: Icons.person_rounded,
                    ),
                    const FuturisticTableColumn(
                      title: 'Credit Score',
                      // icon: Icons.star_rounded,
                    ),
                    const FuturisticTableColumn(
                      title: 'Risk Score',
                      // icon: Icons.analytics_rounded,
                    ),
                    const FuturisticTableColumn(
                      title: 'Risk Status',
                      // icon: Icons.security_rounded,
                    ),
                    const FuturisticTableColumn(
                      title: 'Bank',
                      // icon: Icons.account_balance_rounded,
                    ),
                    // const FuturisticTableColumn(
                    //   title: 'Loan Type',
                    //   // icon: Icons.category_rounded,
                    // ),
                    const FuturisticTableColumn(
                      title: 'Last Updated',
                      // icon: Icons.schedule_rounded,
                    ),
                    const FuturisticTableColumn(
                      title: 'Action',
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

                                      child: Text(
                                        applicant.creditScore.toString() == '0'
                                            ? '_'
                                            : applicant.creditScore.toString(),
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
                                        applicant.creditScore.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                            ),
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
                                      style: const TextStyle(
                                        color: Colors.black,
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
                                        ).withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
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
                                          Text(
                                            applicant.ragStatus.toUpperCase() ==
                                                    "GREEN"
                                                ? "Low"
                                                : applicant.ragStatus
                                                          .toUpperCase() ==
                                                      "AMBER"
                                                ? "Medium"
                                                : "High",
                                            style: TextStyle(
                                              color: AppTheme.getRagColor(
                                                applicant.ragStatus,
                                              ),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                            FuturisticTableCell(
                              text: applicant.bankName.isEmpty
                                  ? ''
                                  : applicant.bankName,
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
                                        applicant.bankName.toString(),
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
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color
                                      ?.withOpacity(0.7),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            FuturisticTableCell(
                              text: applicant.mobile?.isEmpty ?? true
                                  ? 'Pending'
                                  : 'Open',
                              widget: ElevatedButton.icon(
                                onPressed: (applicant.mobile?.isEmpty ?? true)
                                    ? null // disable button if mobile is empty
                                    : () =>
                                          controller.navigateToDetail(
                                            applicant.cif,
                                          ),
                                icon: Icon(
                                  (applicant.mobile?.isEmpty ?? true)
                                      ? Icons.hourglass_empty_rounded
                                      : Icons.auto_stories_rounded,
                                  size: 16,
                                ),
                                label: Text(
                                  (applicant.mobile?.isEmpty ?? true)
                                      ? 'Pending'
                                      : 'Open',
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      (applicant.mobile?.isEmpty ?? true)
                                      ? Colors.grey
                                      : themeController
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
                          ],
                        ),
                      )
                      .toList(),
                  onRowTap: (index) => controller.navigateToDetail(
                    controller.filtered[index].cif,
                  ),
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
        Expanded(
          child: _buildStatCard('Total Applicants', total.toString(),
              Icons.people, themeController.getPrimaryGradient()),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard('Low Risk', greenCount.toString(),
              Icons.check_circle, const LinearGradient(colors: [Colors.green, Colors.teal])),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard('Medium Risk', amberCount.toString(),
              Icons.warning, const LinearGradient(colors: [Colors.amber, Colors.orange])),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard('High Risk', redCount.toString(),
              Icons.error, const LinearGradient(colors: [Colors.red, Colors.deepOrange])),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    LinearGradient gradient,
  ) {
    return FuturisticCard(
      height: 130,
      gradient: gradient,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 26),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
          Text(title,
              style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms)
        .slideY(begin: 0.3, end: 0);
  }

  Widget _buildSearchAndFilters(
      BuildContext context, ThemeController themeController) {
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
                Icon(Icons.search_rounded,
                    color: themeController.getThemeData().primaryColor),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    onChanged: controller.setSearchQuery,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search by CIF, Name or Bank'),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 3,
          child: Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Wrap(
                  spacing: 12,
                  children: [
                    _buildFilterChip('All', 'all'),
                    _buildFilterChip('Low', 'green', Colors.green),
                    _buildFilterChip('Medium', 'amber', Colors.amber),
                    _buildFilterChip('High', 'red', Colors.red),
                  ],
                ),
                // 📅 Date Filter
                Tooltip(
                  message: 'Filter by Date',
                  child: InkWell(
                    onTap: () async {
                      final now = DateTime.now();
                      final picked = await showDateRangePicker(
                        context: context,
                        initialDateRange: controller.dateRange.value ??
                            DateTimeRange(
                              start: now.subtract(const Duration(days: 30)),
                              end: now,
                            ),
                        firstDate: DateTime(now.year - 2),
                        lastDate: DateTime(now.year + 1),
                      );
                      if (picked != null) controller.setDateRange(picked);
                    },
                    onLongPress: controller.clearDateRange,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: themeController
                                .getThemeData()
                                .primaryColor
                                .withOpacity(0.3)),
                        color: controller.dateRange.value == null
                            ? Colors.transparent
                            : themeController
                                .getThemeData()
                                .primaryColor
                                .withOpacity(0.1),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            controller.dateRange.value == null
                                ? 'Date Range'
                                : '${DateFormat('MMM dd').format(controller.dateRange.value!.start)} - ${DateFormat('MMM dd').format(controller.dateRange.value!.end)}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          if (controller.dateRange.value != null) ...[
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: controller.clearDateRange,
                              child: const Icon(Icons.close, size: 16),
                            ),
                          ]
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
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
              width: 1.5),
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
      BuildContext context, ThemeController themeController) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
              themeController.getThemeData().primaryColor),
        ),
        const SizedBox(height: 16),
        const Text('Loading Applicant Portfolio...',
            style: TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
