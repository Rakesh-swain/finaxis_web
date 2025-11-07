import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/theme_controller.dart';
import '../../models/applicant_model.dart';
import '../../services/applicant_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/animated_sidebar.dart';
import '../../widgets/responsive_layout.dart';

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
    final gradient = themeController.getBackgroundGradient();
    return Scaffold(
      body: Row(
        children: [
          AnimatedSidebar(
            selectedIndex: 1,
            onItemSelected: (index) {
              switch (index) {
                case 0:
                  Get.offNamed('/dashboard');
                  break;
                case 1:
                  Get.offNamed('/consent');
                  break;
                case 2:
                  break;
                
              }
            },
          ),
          Expanded(
            child: Column(
              children: [
                _buildTopBar(context, themeController),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return Container(
                      decoration: BoxDecoration(
                        gradient: gradient,
                      ),
                      child: SingleChildScrollView(
                        padding: Responsive.getPadding(context),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Applicants',
                                style: Theme.of(context).textTheme.displayMedium!),
                            SizedBox(height: Responsive.getSpacing(context)),
                            _buildFilters(context),
                            SizedBox(height: Responsive.getSpacing(context)),
                            _buildTable(context),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
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