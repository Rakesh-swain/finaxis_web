import 'dart:ui';

import 'package:finaxis_web/billings/billing_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SidebarWidget extends StatelessWidget {
  final Function(String) onNavigate;
  final String currentPage;

  const SidebarWidget({
    required this.onNavigate,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: Color(0xFF1E293B).withOpacity(0.5),
        border: Border(
          right: BorderSide(color: AppTheme.borderLight, width: 1),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(28),
            child: _buildLogo(),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _navItem('Dashboard', 'dashboard'),
                    SizedBox(height: 4),
                    _navItem('Create Bill', 'create-bill'),
                    SizedBox(height: 4),
                    _navItem('Active Bills', 'active-bills'),
                    SizedBox(height: 4),
                    _navItem('Collections', 'collections'),
                    SizedBox(height: 4),
                    _navItem('Reports', 'reports'),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: _buildUserCard(),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return InkWell(
      onTap:(){
        Get.offAllNamed('/ai-chat');
      },
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '⚡',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FinBiller',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                'Bill Collections',
                style: TextStyle(
                  fontSize: 11,
                  color: AppTheme.textTertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _navItem(String label, String page) {
    bool isActive = currentPage == page;
    return InkWell(
      onTap: () => onNavigate(page),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? Color.fromRGBO(59, 130, 246, 0.3).withOpacity(0.3)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          // border: isActive
          //     ? Border(
          //         left: BorderSide(
          //           color: AppTheme.primaryPurple,
          //           width: 3,
          //         ),
          //       )
          //     : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: isActive ? AppTheme.textPrimary : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFF1E293B).withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text('M', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MERCHANT STORE',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                'POS Integration',
                style: TextStyle(
                  fontSize: 11,
                  color: AppTheme.textTertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
