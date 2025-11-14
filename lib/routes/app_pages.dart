import 'package:finaxis_web/views/consent/add_consent_page.dart';
import 'package:get/get.dart';
import '../bindings/login_binding.dart';
import '../bindings/dashboard_binding.dart';
import '../bindings/applicant_binding.dart';
import '../bindings/ai_chat_binding.dart';
import '../views/login/login_view.dart';
import '../views/dashboard/dashboard_view.dart';
import '../views/applicant/applicant_detail_view.dart';
import '../views/applicant/applicants_view.dart';
import '../views/consent/consent_view.dart';
import '../views/analytics/analytics_view.dart';
import '../views/audit/audit_log_view.dart';
import '../views/reports/reports_view.dart';
import '../views/settings/settings_view.dart';
import '../views/ai_chat/ai_chat_view.dart';

class AppPages {
  static const initial = '/login'; // AI Chat Hub is now the primary entry point

  static final routes = [
    // 🤖 AI Chat Hub - Primary Feature
    GetPage(
      name: '/ai-chat',
      page: () => const AiChatView(),
      binding: AiChatBinding(),
    ),
    GetPage(
      name: '/login',
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: '/dashboard',
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: '/applicants',
      page: () => const ApplicantsView(),
      binding: ApplicantsBinding(),
    ),
    GetPage(
      name: '/applicant/:cif',
      page: () => const ApplicantDetailView(),
      binding: ApplicantBinding(),
    ),
    GetPage(
      name: '/consent',
      page: () => const ConsentView(),
    ),
    GetPage(
      name: '/analytics',
      page: () => const AnalyticsView(),
    ),
    GetPage(
      name: '/audit-log',
      page: () => const AuditLogView(),
    ),
    GetPage(
      name: '/reports',
      page: () => const ReportsView(),
    ),
    GetPage(
      name: '/settings',
      page: () => const SettingsView(),
    ),
    GetPage(
      name: '/add-consent',
      page: () => const AddConsentPage(),
    ),
  ];
}
