import 'package:flutter/material.dart';
import 'dart:async';

import 'package:get/get.dart';

class BillSettlementPage extends StatefulWidget {
  final VoidCallback onBack;

  const BillSettlementPage({
    required this.onBack,
  });

  @override
  State<BillSettlementPage> createState() => _BillSettlementPageState();
}

class _BillSettlementPageState extends State<BillSettlementPage> {
  String? selectedBank;
  int currentPage = 0;
  int countdownSeconds = 30;
  bool paymentProcessing = false;
  String? transactionReference;
  late Timer? countdownTimer;

  final billId = 'BT234562892';
  final amount = 'AED 2,500.00';
  final fees = 'AED 25.00';
  final total = 'AED 2,525.00';

  final banks = [
    'Abu Dhabi Islamic Bank (ADIB)',
    'First Abu Dhabi Bank (FAB)',
    'Emirates NBD (ENBD)',
    'Abu Dhabi Commercial Bank (ADCB)',
    'Commercial Bank of Dubai (CBD)',
    'Dubai Islamic Bank (DIB)',
    'National Bank of Abu Dhabi (NBAD)',
    'RAK Bank',
    'Mera Bank',
  ];

  @override
  void initState() {
    super.initState();
    countdownTimer = null;
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width < 1000;

    return Scaffold(
      backgroundColor: const Color(0xFF2D1B4E),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16.0 : (isTablet ? 24.0 : 32.0),
            vertical: isMobile ? 16.0 : 24.0,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(isMobile),
                const SizedBox(height: 48),
                _buildProgressBar(),
                const SizedBox(height: 48),
                if (currentPage == 0)
                  _buildBankSelectionPage(isMobile, isTablet)
                else
                  _buildPaymentPage(isMobile, isTablet),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: (){
            Get.back();
          },
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'OFTF Bill Settlement',
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 20 : 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Secure payment processing',
              style: TextStyle(
                color: Color(0xFF9D8FD9),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Center(
      child: Column(
        children: [
          SizedBox(
            width: 280,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 28,
                  left: 28,
                  right: 28,
                  child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                      color: currentPage >= 1
                          ? const Color(0xFF7B68EE)
                          : Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: currentPage >= 0
                                ? const Color(0xFF7B68EE)
                                : const Color(0xFF5A4E7A),
                            border: Border.all(
                              color: currentPage >= 0
                                  ? const Color(0xFF7B68EE)
                                  : const Color(0xFF5A4E7A),
                              width: 2,
                            ),
                            boxShadow: currentPage >= 0
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFF7B68EE)
                                          .withOpacity(0.4),
                                      blurRadius: 12,
                                      spreadRadius: 0,
                                    )
                                  ]
                                : [],
                          ),
                          child: Center(
                            child: Text(
                              '1',
                              style: TextStyle(
                                color: currentPage >= 0
                                    ? Colors.white
                                    : const Color(0xFF9D8FD9),
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Select Bank',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: currentPage >= 0
                                ? const Color(0xFF7B68EE)
                                : const Color(0xFF9D8FD9),
                            fontSize: 12,
                            fontWeight: currentPage >= 0
                                ? FontWeight.w600
                                : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: currentPage >= 1
                                ? const Color(0xFF7B68EE)
                                : const Color(0xFF5A4E7A),
                            border: Border.all(
                              color: currentPage >= 1
                                  ? const Color(0xFF7B68EE)
                                  : const Color(0xFF5A4E7A),
                              width: 2,
                            ),
                            boxShadow: currentPage >= 1
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFF7B68EE)
                                          .withOpacity(0.4),
                                      blurRadius: 12,
                                      spreadRadius: 0,
                                    )
                                  ]
                                : [],
                          ),
                          child: Center(
                            child: Text(
                              '2',
                              style: TextStyle(
                                color: currentPage >= 1
                                    ? Colors.white
                                    : const Color(0xFF9D8FD9),
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Payment',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: currentPage >= 1
                                ? const Color(0xFF7B68EE)
                                : const Color(0xFF9D8FD9),
                            fontSize: 12,
                            fontWeight: currentPage >= 1
                                ? FontWeight.w600
                                : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankSelectionPage(bool isMobile, bool isTablet) {
    return Column(
      children: [
        _buildCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'SELECT BANK',
                style: TextStyle(
                  color: Color(0xFF7B68EE),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Choose Your Bank',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              _buildBankDropdown(),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _buildCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ORDER SUMMARY',
                style: TextStyle(
                  color: Color(0xFF7B68EE),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 20),
              _buildSummaryContainer(),
            ],
          ),
        ),
        const SizedBox(height: 32),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildBankDropdown() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF5A4E7A),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: selectedBank,
        isExpanded: true,
        underline: const SizedBox(),
        dropdownColor: const Color(0xFF3D2461),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hint: const Text(
          'Select a bank...',
          style: TextStyle(
            color: Color(0xFF7A6BA3),
            fontSize: 14,
          ),
        ),
        items: banks.map((bank) {
          return DropdownMenuItem<String>(
            value: bank,
            child: Text(bank),
          );
        }).toList(),
        onChanged: (value) {
          setState(() => selectedBank = value);
        },
      ),
    );
  }

  Widget _buildSummaryContainer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF4A3F6B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF5A4E7A),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildSummaryRow('Bill ID', billId),
          const SizedBox(height: 14),
          _buildSummaryRow('Amount', amount),
          const SizedBox(height: 14),
          _buildSummaryRow('Processing Fee', fees),
          const SizedBox(height: 14),
          Divider(color: const Color(0xFF5A4E7A).withOpacity(0.5)),
          const SizedBox(height: 14),
          _buildSummaryRow('Total Amount', total, isBold: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF9D8FD9),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isBold ? const Color(0xFF7B68EE) : Colors.white,
            fontSize: isBold ? 14 : 13,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF3D2461),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF5A4E7A),
          width: 1,
        ),
      ),
      child: child,
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _clearSelection,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(
                color: Color(0xFF6B5FA3),
                width: 1,
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 28),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Clear',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: selectedBank != null ? _goToPayment : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: selectedBank != null
                  ? const Color(0xFF7B68EE)
                  : const Color(0xFF5A4E7A),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 28),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: selectedBank != null ? 2 : 0,
            ),
            child: const Text(
              'Continue',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentPage(bool isMobile, bool isTablet) {
    return Column(
      children: [
        if (isMobile)
          Column(
            children: [
              _buildPaymentDetailsCard(),
              const SizedBox(height: 28),
              _buildPaymentQRSection(),
              const SizedBox(height: 24),
              _buildPaymentLinkSection(),
              const SizedBox(height: 24),
              _buildAutoRedirectSection(),
            ],
          )
        else if (isTablet)
          Column(
            children: [
              _buildPaymentDetailsCard(),
              const SizedBox(height: 28),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildPaymentQRSection(),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _buildPaymentLinkSection(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildAutoRedirectSection(),
            ],
          )
        else
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: _buildPaymentDetailsCard(),
                  ),
                  const SizedBox(width: 28),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        _buildPaymentQRSection(),
                        const SizedBox(height: 24),
                        _buildPaymentLinkSection(),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              _buildAutoRedirectSection(),
            ],
          ),
        const SizedBox(height: 32),
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton.icon(
            onPressed: _goBack,
            icon: const Icon(Icons.arrow_back),
            label: const Text('Back'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(
                color: Color(0xFF6B5FA3),
                width: 1,
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentDetailsCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PAYMENT DETAILS',
            style: TextStyle(
              color: Color(0xFF7B68EE),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            selectedBank ?? 'No bank selected',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF5A4E7A).withOpacity(0.3),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: const Color(0xFF7B68EE),
                width: 1,
              ),
            ),
            child: const Text(
              'Ready to Process',
              style: TextStyle(
                color: Color(0xFF7B68EE),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'ORDER SUMMARY',
            style: TextStyle(
              color: Color(0xFF9D8FD9),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryContainer(),
        ],
      ),
    );
  }

  Widget _buildPaymentQRSection() {
    if (paymentProcessing) {
      return _buildBankPortalSection();
    }
    if (transactionReference != null) {
      return _buildPaymentSuccessSection();
    }

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'SCAN TO PAY',
            style: TextStyle(
              color: Color(0xFF7B68EE),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFF7B68EE),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xFF2D1B4E),
            ),
            child: const Center(
              child: Text(
                '📱',
                style: TextStyle(fontSize: 56),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Scan with your mobile device to complete payment',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF9D8FD9),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentLinkSection() {
    if (paymentProcessing) {
      return const SizedBox();
    }
    if (transactionReference != null) {
      return const SizedBox();
    }

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PAYMENT LINK',
            style: TextStyle(
              color: Color(0xFF7B68EE),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2D1B4E),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: const Color(0xFF5A4E7A),
                width: 1,
              ),
            ),
            child: const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                'https://oftf.uae/pay/auth/xyz123abc456...',
                style: TextStyle(
                  color: Color(0xFF7B68EE),
                  fontSize: 11,
                  fontFamily: 'Courier',
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _copyLink,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF7B68EE),
                side: const BorderSide(
                  color: Color(0xFF6B5FA3),
                  width: 1,
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                'Copy Link',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAutoRedirectSection() {
    if (paymentProcessing) {
      return const SizedBox();
    }
    if (transactionReference != null) {
      return const SizedBox();
    }

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'AUTO REDIRECT',
            style: TextStyle(
              color: Color(0xFF9D8FD9),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '$countdownSeconds',
            style: const TextStyle(
              color: Color(0xFF7B68EE),
              fontSize: 48,
              fontWeight: FontWeight.w700,
              fontFamily: 'Courier',
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Redirecting to bank in $countdownSeconds seconds',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF9D8FD9),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _proceedToBank,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7B68EE),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
              ),
              child: const Text(
                'Proceed Now',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankPortalSection() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            '🔒',
            style: TextStyle(fontSize: 48),
          ),
          const SizedBox(height: 20),
          const Text(
            'Bank Portal',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'You will be redirected to your bank\'s secure portal',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF9D8FD9),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _simulatePayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7B68EE),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
              ),
              child: const Text(
                'Complete Payment',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSuccessSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF3D2461),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF00b300),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            '✓',
            style: TextStyle(
              fontSize: 56,
              color: Color(0xFF00b300),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Payment Successful',
            style: TextStyle(
              color: Color(0xFF00b300),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Your transaction has been processed successfully',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF9D8FD9),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF2D1B4E),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: const Color(0xFF5A4E7A),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                const Text(
                  'Reference:',
                  style: TextStyle(
                    color: Color(0xFF9D8FD9),
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  transactionReference ?? '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF7B68EE),
                    fontSize: 12,
                    fontFamily: 'Courier',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _returnToDashboard,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(
                  color: Color(0xFF6B5FA3),
                  width: 1,
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Return to Dashboard',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _goToPayment() {
    setState(() => currentPage = 1);
    _startCountdown();
  }

  void _startCountdown() {
    countdownTimer?.cancel();
    setState(() => countdownSeconds = 30);
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (countdownSeconds > 0) {
          countdownSeconds--;
        } else {
          timer.cancel();
          _proceedToBank();
        }
      });
    });
  }

  void _goBack() {
    setState(() {
      currentPage = 0;
      paymentProcessing = false;
      transactionReference = null;
      countdownSeconds = 30;
    });
    countdownTimer?.cancel();
  }

  void _clearSelection() {
    setState(() => selectedBank = null);
  }

  void _copyLink() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment link copied to clipboard!')),
    );
  }

  void _proceedToBank() {
    countdownTimer?.cancel();
    setState(() => paymentProcessing = true);
  }

  void _simulatePayment() {
    countdownTimer?.cancel();
    setState(() {
      transactionReference =
          'TXN-${DateTime.now().toString().split(' ')[0]}-${DateTime.now().millisecond}';
      paymentProcessing = false;
    });
  }

  void _returnToDashboard() {
    Get.back();
    Get.back();
    // _goBack();
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text('Returning to dashboard...')),
    // );
  }
}