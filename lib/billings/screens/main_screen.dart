import 'package:finaxis_web/billings/billing_theme.dart';
import 'package:finaxis_web/billings/models/emi_model.dart';
import 'package:finaxis_web/billings/screens/active_emis_page.dart';
import 'package:finaxis_web/billings/screens/collections_page.dart';
import 'package:finaxis_web/billings/screens/create_emi_page.dart';
import 'package:finaxis_web/billings/screens/dashboard_page.dart';
import 'package:finaxis_web/billings/screens/emi_details_page.dart';
import 'package:finaxis_web/billings/screens/reports_page.dart';
import 'package:finaxis_web/billings/widgets/sidebar_widgets.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String currentPage = 'dashboard';
  EMIApplication? selectedEMI;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: Row(
          children: [
            SidebarWidget(
              onNavigate: (page) {
                setState(() {
                  currentPage = page;
                  selectedEMI = null;
                });
              },
              currentPage: currentPage,
            ),
            Expanded(
              child: Column(
                children: [
                  _buildTopBar(),
                  Expanded(
                    child: _getPageContent(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    final titles = {
      'dashboard': 'Dashboard',
      'create-bill': 'Create Bill',
      'active-bills': 'Active Bills',
      'collections': 'Collections',
      'reports': 'Reports & Analytics',
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 28, vertical: 18),
      decoration: BoxDecoration(
        color: Color(0xFF1E293B).withOpacity(0.4),
        border: Border(
          bottom: BorderSide(color: AppTheme.borderLight, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            selectedEMI != null 
              ? 'EMI Details - ${selectedEMI!.billId}'
              : (titles[currentPage] ?? 'Dashboard'),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          // if (currentPage != 'create-emi' && selectedEMI == null)
          //   ElevatedButton(
          //     onPressed: () {
          //       setState(() => currentPage = 'create-emi');
          //     },
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: AppTheme.primaryBlue,
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(8),
          //       ),
          //       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          //       elevation: 0,
          //     ),
          //     child: Text(
          //       '+ New EMI',
          //       style: TextStyle(
          //         fontSize: 13,
          //         fontWeight: FontWeight.w600,
          //         color: AppTheme.textPrimary,
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }

  Widget _getPageContent() {
    // If EMI is selected, show details page
    if (selectedEMI != null) {
      return EMIDetailsPage(
        emiData: selectedEMI!,
        onBack: () {
          setState(() => selectedEMI = null);
        },
      );
    }

    switch (currentPage) {
      case 'dashboard':
        return DashboardPage(
        );
      case 'create-bill':
        return CreateEMIPage(onBack: () {
          setState(() => currentPage = 'dashboard');
        });
      case 'active-bills':
        return ActiveEMIsPage(
         
        );
      case 'collections':
        return CollectionsPage();
      case 'reports':
        return ReportsPage();
      default:
        return DashboardPage();
    }
  }
}
