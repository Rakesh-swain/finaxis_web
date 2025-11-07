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

  // Sorting
  final RxInt sortColumnIndex = 0.obs;
  final RxBool sortAscending = true.obs;

  // Derived Loan Type (simulated)
  final Map<String, String> loanTypeByCif = {};
  static const List<String> loanTypes = [
    'Personal Loan', 'Home Loan', 'Auto Loan', 'Credit Card', 'Business Loan'
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

  void setRagFilter(String value) {
    ragFilter.value = value;
    applyFilters();
  }

  void setLoanTypeFilter(String value) {
    loanTypeFilter.value = value;
    applyFilters();
  }

  void setDateRange(DateTimeRange? range) {
    dateRange.value = range;
    applyFilters();
  }

  void clearFilters() {
    ragFilter.value = 'all';
    loanTypeFilter.value = 'all';
    dateRange.value = null;
    applyFilters();
  }

  void applyFilters() {
    Iterable<ApplicantModel> result = applicants;

    // RAG filter
    if (ragFilter.value != 'all') {
      result = result.where((a) => a.ragStatus.toLowerCase() == ragFilter.value);
    }

    // Loan Type filter
    if (loanTypeFilter.value != 'all') {
      result = result.where((a) => loanTypeByCif[a.cif] == loanTypeFilter.value);
    }

    // Date range filter (based on lastUpdated)
    final range = dateRange.value;
    if (range != null) {
      result = result.where((a) =>
          !a.lastUpdated.isBefore(range.start) && !a.lastUpdated.isAfter(range.end));
    }

    filtered.assignAll(result.toList());
    // Keep current sorting order
    final idx = sortColumnIndex.value;
    _sortByIndex(idx, sortAscending.value);
  }

  void sortBy<T>(Comparable Function(ApplicantModel a) getField, int columnIndex, bool ascending) {
    filtered.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending ? Comparable.compare(aValue, bValue) : Comparable.compare(bValue, aValue);
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
      case 6:
        sortBy<String>((a) => loanTypeByCif[a.cif] ?? '', idx, asc);
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
      selectedIndex: 2, // Applicants index
      pageTitle: 'Applicant Portfolio',
      headerActions: [
        _buildFilterButton(context, themeController),
        _buildViewToggleButton(context, themeController),
      ],
      child: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: _buildLoadingState(context, themeController),
          );
        }
        
        return _buildFloatingCardShelf(context, themeController);
      }),
    );
  }

  /// Build floating card shelf - vertical column of stacked applicant cards
  Widget _buildFloatingCardShelf(BuildContext context, ThemeController themeController) {
    return Container(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📊 Stats Row
            _buildStatsRow(context, themeController),
            
            const SizedBox(height: 32),
            
            // 🔍 Search & Filters
            _buildSearchAndFilters(context, themeController),
            
            const SizedBox(height: 24),
            
            // 📊 Futuristic Sortable Table
            Obx(() => SizedBox(
              height: 600,
              child: FuturisticTable(
                columns: [
                  const FuturisticTableColumn(
                    title: 'CIF',
                    icon: Icons.fingerprint_rounded,
                  ),
                  const FuturisticTableColumn(
                    title: 'Name',
                    icon: Icons.person_rounded,
                  ),
                  const FuturisticTableColumn(
                    title: 'Credit Score',
                    icon: Icons.star_rounded,
                  ),
                  const FuturisticTableColumn(
                    title: 'Risk Score',
                    icon: Icons.analytics_rounded,
                  ),
                  const FuturisticTableColumn(
                    title: 'Risk Status',
                    icon: Icons.security_rounded,
                  ),
                  const FuturisticTableColumn(
                    title: 'Bank',
                    icon: Icons.account_balance_rounded,
                  ),
                  const FuturisticTableColumn(
                    title: 'Loan Type',
                    icon: Icons.category_rounded,
                  ),
                  const FuturisticTableColumn(
                    title: 'Last Updated',
                    icon: Icons.schedule_rounded,
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
                          FuturisticTableCell(text: applicant.cif,),
                          FuturisticTableCell(text: applicant.name),
                          FuturisticTableCell(
                            text: applicant.creditScore.toString(),
                            widget: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                gradient: themeController.getPrimaryGradient(),
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
                            text: applicant.riskScore.toStringAsFixed(1),
                            widget: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.getRagColor(applicant.ragStatus).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppTheme.getRagColor(applicant.ragStatus),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                applicant.riskScore.toStringAsFixed(1),
                                style: TextStyle(
                                  color: AppTheme.getRagColor(applicant.ragStatus),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                          FuturisticTableCell(
                            text: applicant.ragStatus,
                            widget: Container(
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
                                    applicant.ragStatus.toUpperCase(),
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
                          FuturisticTableCell(text: applicant.bankName),
                          FuturisticTableCell(
                            text: controller.loanTypeByCif[applicant.cif] ?? 'Unknown',
                            widget: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                controller.loanTypeByCif[applicant.cif] ?? 'Unknown',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          FuturisticTableCell(
                            text: DateFormat('MMM dd, yy').format(applicant.lastUpdated),
                            widget: Text(
                              DateFormat('MMM dd, yy').format(applicant.lastUpdated),
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                                fontSize: 13,
                              ),
                            ),
                          ),
                          FuturisticTableCell(
                            text: 'Open',
                            widget: ElevatedButton.icon(
                              onPressed: () => controller.navigateToDetail(applicant.cif),
                              icon: const Icon(
                                Icons.auto_stories_rounded,
                                size: 16,
                              ),
                              label: const Text('Open'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: themeController
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
                onRowTap: (index) => controller.navigateToDetail(controller.filtered[index].cif),
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
            )),
          ],
        ),
      ),
    );
  }

  /// Build stats row with key metrics
  Widget _buildStatsRow(BuildContext context, ThemeController themeController) {
    return Obx(() {
      final total = controller.filtered.length;
      final greenCount = controller.filtered.where((a) => a.ragStatus.toLowerCase() == 'green').length;
      final amberCount = controller.filtered.where((a) => a.ragStatus.toLowerCase() == 'amber').length;
      final redCount = controller.filtered.where((a) => a.ragStatus.toLowerCase() == 'red').length;
      final avgCreditScore = controller.filtered.isEmpty 
          ? 0.0 
          : controller.filtered.map((a) => a.creditScore).reduce((a, b) => a + b) / controller.filtered.length;

      return Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total Applicants',
              total.toString(),
              Icons.people_rounded,
              themeController.getPrimaryGradient(),
              context,
              themeController,
              0,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              'Low Risk',
              greenCount.toString(),
              Icons.check_circle_rounded,
              LinearGradient(colors: [Colors.green.shade400, Colors.green.shade600]),
              context,
              themeController,
              1,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              'Medium Risk',
              amberCount.toString(),
              Icons.warning_rounded,
              LinearGradient(colors: [Colors.amber.shade400, Colors.amber.shade600]),
              context,
              themeController,
              2,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              'High Risk',
              redCount.toString(),
              Icons.error_rounded,
              LinearGradient(colors: [Colors.red.shade400, Colors.red.shade600]),
              context,
              themeController,
              3,
            ),
          ),
          const SizedBox(width: 16),
          
          // Expanded(
          //   child: _buildStatCard(
          //     'Avg Credit Score',
          //     avgCreditScore.toStringAsFixed(0),
          //     Icons.star_rounded,
          //     LinearGradient(colors: [Colors.purple.shade400, Colors.purple.shade600]),
          //     context,
          //     themeController,
          //     4,
          //   ),
          // ),
        ],
      );
    });
  }

  /// Build individual stat card
  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    LinearGradient gradient,
    BuildContext context,
    ThemeController themeController,
    int index,
  ) {
    return FuturisticCard(
      height: 130,
      isElevated: true,
      gradient: gradient,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 26),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate(delay: (index * 150).ms)
      .fadeIn(duration: 600.ms)
      .slideY(begin: 0.3, end: 0)
      .then()
      .shimmer(duration: 1500.ms, delay: 800.ms);
  }

  /// Build search and filters section
  Widget _buildSearchAndFilters(BuildContext context, ThemeController themeController) {
    return Row(
      children: [
        // 🔍 Search Bar
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
                  size: 24,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search by CIF, name, or bank...',
                      border: InputBorder.none,
                      hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                      ),
                    ),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(width: 16),
        
        // 🎛️ Filter Chips
        Expanded(
          flex: 3,
          child: Obx(() => Wrap(
            spacing: 12,
            children: [
              _buildFilterChip('All', 'all', controller.ragFilter.value, (v) => controller.setRagFilter(v), themeController),
              _buildFilterChip('Low Risk', 'green', controller.ragFilter.value, (v) => controller.setRagFilter(v), themeController, Colors.green),
              _buildFilterChip('Medium Risk', 'amber', controller.ragFilter.value, (v) => controller.setRagFilter(v), themeController, Colors.amber),
              _buildFilterChip('High Risk', 'red', controller.ragFilter.value, (v) => controller.setRagFilter(v), themeController, Colors.red),
            ],
          )),
        ),
      ],
    );
  }

  /// Build filter chip
  Widget _buildFilterChip(
    String label,
    String value,
    String selectedValue,
    Function(String) onTap,
    ThemeController themeController, [
    Color? color,
  ]) {
    final isSelected = selectedValue == value;
    final chipColor = color ?? themeController.getThemeData().primaryColor;
    
    return GestureDetector(
      onTap: () => onTap(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? chipColor.withOpacity(0.2) : Colors.transparent,
          border: Border.all(
            color: isSelected ? chipColor : chipColor.withOpacity(0.3),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? chipColor : Theme.of(Get.context!).textTheme.bodyMedium?.color?.withOpacity(0.8),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  /// Build floating applicant card with stacked depth effect
  Widget _buildFloatingApplicantCard(
    ApplicantModel applicant,
    int index,
    BuildContext context,
    ThemeController themeController,
  ) {
    final loanType = controller.loanTypeByCif[applicant.cif] ?? 'Unknown';
    
    return FuturisticCard(
      onTap: () => controller.navigateToDetail(applicant.cif),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🏷️ Header with RAG status and score
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.getRagColor(applicant.ragStatus).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.getRagColor(applicant.ragStatus),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  applicant.ragStatus.toUpperCase(),
                  style: TextStyle(
                    color: AppTheme.getRagColor(applicant.ragStatus),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  gradient: themeController.getPrimaryGradient(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  applicant.creditScore.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 🏦 CIF and Name
          Text(
            applicant.cif,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            applicant.name,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: 12),
          
          // 🏪 Bank and Loan Type
          Text(
            applicant.bankName,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: themeController.getThemeData().primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            loanType,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
          ),
          
          const Spacer(),
          
          // 📊 Risk Score and Last Updated
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Risk Score',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
                    ),
                  ),
                  Text(
                    applicant.riskScore.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.getRagColor(applicant.ragStatus),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Last Updated',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
                    ),
                  ),
                  Text(
                    DateFormat('dd MMM').format(applicant.lastUpdated),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 🔗 Open Button with Flip Handle
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => controller.navigateToDetail(applicant.cif),
              icon: const Icon(Icons.auto_stories_rounded, size: 18),
              label: const Text('Open Book'),
              style: ElevatedButton.styleFrom(
                backgroundColor: themeController.getThemeData().primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    ).animate(delay: (index * 100).ms)
      .fadeIn(duration: 600.ms)
      .slideY(begin: 0.5, end: 0)
      .scale();
  }

  /// Build loading state
  Widget _buildLoadingState(BuildContext context, ThemeController themeController) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: themeController.getPrimaryGradient(),
          ),
          child: const Icon(
            Icons.people_rounded,
            color: Colors.white,
            size: 40,
          ),
        ).animate()
          .scale(duration: 800.ms)
          .then()
          .shimmer(duration: 1500.ms, colors: [
            Colors.white.withOpacity(0.3),
            Colors.white.withOpacity(0.8),
            Colors.white.withOpacity(0.3),
          ]),
        const SizedBox(height: 24),
        Text(
          'Loading Applicant Portfolio...',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ).animate()
          .fadeIn(delay: 300.ms, duration: 600.ms),
      ],
    );
  }

  /// Build filter button
  Widget _buildFilterButton(BuildContext context, ThemeController themeController) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.amber.shade400, Colors.amber.shade600],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        onPressed: () {
          // Show advanced filters dialog
          _showAdvancedFilters(context, themeController);
        },
        icon: const Icon(Icons.filter_list_rounded, color: Colors.white),
        tooltip: 'Advanced Filters',
      ),
    );
  }

  /// Build view toggle button  
  Widget _buildViewToggleButton(BuildContext context, ThemeController themeController) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade400, Colors.green.shade600],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        onPressed: () {
          // Toggle between card and table view
        },
        icon: const Icon(Icons.view_module_rounded, color: Colors.white),
        tooltip: 'Toggle View',
      ),
    );
  }

  /// Show advanced filters dialog
  void _showAdvancedFilters(BuildContext context, ThemeController themeController) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Advanced Filters'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Loan type filter
              Obx(() => DropdownButtonFormField<String>(
                value: controller.loanTypeFilter.value,
                decoration: const InputDecoration(labelText: 'Loan Type'),
                items: [
                  const DropdownMenuItem(value: 'all', child: Text('All Types')),
                  ...ApplicantsController.loanTypes
                      .map((t) => DropdownMenuItem(value: t, child: Text(t))),
                ],
                onChanged: (v) => controller.setLoanTypeFilter(v ?? 'all'),
              )),
              
              const SizedBox(height: 16),
              
              // Date range
              Obx(() => ListTile(
                leading: const Icon(Icons.date_range),
                title: Text(
                  controller.dateRange.value == null
                      ? 'Select Date Range'
                      : '${DateFormat('dd MMM yyyy').format(controller.dateRange.value!.start)} - ${DateFormat('dd MMM yyyy').format(controller.dateRange.value!.end)}',
                ),
                onTap: () async {
                  final now = DateTime.now();
                  final picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(now.year - 5),
                    lastDate: DateTime(now.year + 1),
                  );
                  if (picked != null) {
                    controller.setDateRange(picked);
                  }
                },
              )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.clearFilters();
              Navigator.of(context).pop();
            },
            child: const Text('Clear All'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, ThemeController themeController) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Text('Finaxis',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(width: 24),
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppTheme.darkSurface
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search applicants...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Obx(() => _buildThemeDropdown(context, themeController)),
          const SizedBox(width: 8),
          const CircleAvatar(
            radius: 18,
            backgroundColor: Colors.transparent,
            child: Icon(Icons.person, color: AppTheme.textSecondaryLight),
          ),
        ],
      ),
    );
  }
  Widget _buildThemeDropdown(BuildContext context, ThemeController themeCtrl) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.2),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: themeCtrl.currentThemeName,
          isDense: true,
          icon: Icon(
            Icons.palette_outlined,
            size: 16,
            color: Theme.of(context).primaryColor,
          ),
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          items: ThemeController.availableThemes.map((theme) {
            return DropdownMenuItem(
              value: theme,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _getThemeIcon(theme),
                  const SizedBox(width: 6),
                  Text(theme),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) themeCtrl.switchTheme(value);
          },
        ),
      ),
    );
  }

  Icon _getThemeIcon(String theme) {
    switch (theme) {
      case 'Light':
        return const Icon(Icons.wb_sunny, size: 14, color: Colors.orange);
      case 'Dark':
        return const Icon(Icons.nightlight_round, size: 14, color: Colors.indigo);
      case 'Gold':
        return const Icon(Icons.star, size: 14, color: Colors.amber);
      case 'Emerald':
        return const Icon(Icons.eco, size: 14, color: Colors.green);
      case 'Royal':
        return const Icon(Icons.shield, size: 14, color: Colors.deepPurple);
      default:
        return const Icon(Icons.palette, size: 14);
    }
  }
  Widget _buildFilters(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          return Wrap(
            spacing: 16,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // RAG filter
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: controller.ragFilter.value,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('RAG: All')),
                    DropdownMenuItem(value: 'green', child: Text('RAG: Green')),
                    DropdownMenuItem(value: 'amber', child: Text('RAG: Amber')),
                    DropdownMenuItem(value: 'red', child: Text('RAG: Red')),
                  ],
                  onChanged: (v) => controller.setRagFilter(v ?? 'all'),
                ),
              ),

              // Loan type filter
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: controller.loanTypeFilter.value,
                  items: [
                    const DropdownMenuItem(value: 'all', child: Text('Loan Type: All')),
                    ...ApplicantsController.loanTypes
                        .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                        .toList(),
                  ],
                  onChanged: (v) => controller.setLoanTypeFilter(v ?? 'all'),
                ),
              ),

              // Date Range
              OutlinedButton.icon(
                onPressed: () async {
                  final now = DateTime.now();
                  final picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(now.year - 5),
                    lastDate: DateTime(now.year + 1),
                    currentDate: now,
                    helpText: 'Filter by Last Updated',
                    builder: (ctx, child) {
                      return Theme(
                        data: theme.copyWith(
                          colorScheme: theme.colorScheme.copyWith(
                            primary: theme.colorScheme.primary,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  controller.setDateRange(picked);
                },
                icon: const Icon(Icons.date_range_rounded),
                label: Text(
                  controller.dateRange.value == null
                      ? 'Date Range'
                      : '${DateFormat('dd MMM yyyy').format(controller.dateRange.value!.start)} - ${DateFormat('dd MMM yyyy').format(controller.dateRange.value!.end)}',
                ),
              ),

              // Clear
              TextButton.icon(
                onPressed: controller.clearFilters,
                icon: const Icon(Icons.clear_all_rounded),
                label: const Text('Clear'),
              ),

              // Count
              Chip(
                label: Text('Total: ${controller.filtered.length}'),
                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildTable(BuildContext context) {
    return Card(
      elevation: 0,
      child: Obx(() {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            sortColumnIndex: controller.sortColumnIndex.value,
            sortAscending: controller.sortAscending.value,
            columns: [
              DataColumn(
                label: const Text('CIF'),
                onSort: (i, asc) => controller.sortBy<String>((a) => a.cif, i, asc),
              ),
              DataColumn(
                label: const Text('Name'),
                onSort: (i, asc) => controller.sortBy<String>((a) => a.name, i, asc),
              ),
              DataColumn(
                numeric: true,
                label: const Text('Credit Score'),
                onSort: (i, asc) => controller.sortBy<int>((a) => a.creditScore, i, asc),
              ),
              DataColumn(
                numeric: true,
                label: const Text('Risk Score'),
                onSort: (i, asc) => controller.sortBy<double>((a) => a.riskScore, i, asc),
              ),
              DataColumn(
                label: const Text('RAG Status'),
                onSort: (i, asc) => controller.sortBy<String>((a) => a.ragStatus, i, asc),
              ),
              DataColumn(
                label: const Text('Bank'),
                onSort: (i, asc) => controller.sortBy<String>((a) => a.bankName, i, asc),
              ),
              DataColumn(
                label: const Text('Loan Type'),
                onSort: (i, asc) => controller.sortBy<String>((a) => controller.loanTypeByCif[a.cif] ?? '', i, asc),
              ),
              DataColumn(
                label: const Text('Last Updated'),
                onSort: (i, asc) => controller.sortBy<DateTime>((a) => a.lastUpdated, i, asc),
              ),
              const DataColumn(label: Text('Action')),
            ],
            rows: controller.filtered.map((a) {
              return DataRow(
                cells: [
                  DataCell(Text(a.cif)),
                  DataCell(Text(a.name)),
                  DataCell(Text(a.creditScore.toString())),
                  DataCell(Text(a.riskScore.toStringAsFixed(2))),
                  DataCell(
                    Chip(
                      label: Text(a.ragStatus.toUpperCase()),
                      backgroundColor: AppTheme.getRagColor(a.ragStatus),
                      labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  DataCell(Text(a.bankName)),
                  DataCell(Text(controller.loanTypeByCif[a.cif] ?? '-')),
                  DataCell(Text(DateFormat('dd MMM yyyy, HH:mm').format(a.lastUpdated.toLocal()))),
                  DataCell(
                    ElevatedButton(
                      onPressed: () => controller.navigateToDetail(a.cif),
                      child: const Text('View'),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        );
      }),
    );
  }
}