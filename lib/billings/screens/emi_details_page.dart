import 'package:finaxis_web/billings/models/emi_model.dart';
import 'package:finaxis_web/billings/screens/bill_settlement_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EMIDetailsPage extends StatefulWidget {
  final EMIApplication emiData;
  final VoidCallback onBack;

  const EMIDetailsPage({
    required this.emiData,
    required this.onBack,
  });

  @override
  State<EMIDetailsPage> createState() => _EMIDetailsPageState();
}

class _EMIDetailsPageState extends State<EMIDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _billIdController;
  late TextEditingController _billAmountController;
  late TextEditingController _customerNameController;
  late TextEditingController _customerCifController;
  late TextEditingController _mobileController;
  late TextEditingController _emailController;
  late TextEditingController _productController;
  String _selectedTenure = '12 Months';

  @override
  void initState() {
    super.initState();
    _billIdController = TextEditingController(text: widget.emiData.billId);
    _billAmountController = TextEditingController(
      text: widget.emiData.amount.toStringAsFixed(0),
    );
    _customerNameController = TextEditingController(text: widget.emiData.customerName);
    _customerCifController = TextEditingController(text: 'CIF-${widget.emiData.billId.split('-')[1]}');
    _mobileController = TextEditingController(text: '+971 50 123 4567');
    _emailController = TextEditingController(text: 'customer@example.com');
    _productController = TextEditingController(text: 'Samsung 65 inch TV');
  }

  @override
  void dispose() {
    _billIdController.dispose();
    _billAmountController.dispose();
    _customerNameController.dispose();
    _customerCifController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _productController.dispose();
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
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(isMobile),
                const SizedBox(height: 24),
                _buildForm(isMobile, isTablet),
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
          onPressed: widget.onBack,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 16),
        Text(
          'New EMI Application',
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 20 : 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildForm(bool isMobile, bool isTablet) {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        decoration: BoxDecoration(
          color: const Color(0xFF3D2461),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF5A4E7A),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoBanner(),
            const SizedBox(height: 24),
            _buildFieldsGrid(isMobile, isTablet),
            const SizedBox(height: 24),
            _buildActionButtons(isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF4A3F6B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF6B5FA3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Color(0xFF9D8FD9), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Enter bill details and customer information. System will automatically send OFFT consent link and validate DSR/FOIR eligibility.',
              style: TextStyle(
                color: const Color(0xFF9D8FD9),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldsGrid(bool isMobile, bool isTablet) {
    if (isMobile) {
      return Column(
        children: [
          _buildTextField(
            label: 'BILL ID / INVOICE',
            controller: _billIdController,
            hint: 'INV-00123',
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'BILL AMOUNT (AED)',
            controller: _billAmountController,
            hint: '1200',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'CUSTOMER NAME',
            controller: _customerNameController,
            hint: 'Ahmed Al Mansouri',
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'CUSTOMER ID / CIF',
            controller: _customerCifController,
            hint: 'CIF-011255',
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'MOBILE NUMBER',
            controller: _mobileController,
            hint: '+971 50 123 4567',
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'EMAIL',
            controller: _emailController,
            hint: 'customer@example.com',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'PRODUCT / ITEM',
            controller: _productController,
            hint: 'Samsung 65 inch TV',
          ),
          const SizedBox(height: 16),
          _buildTenureDropdown(),
        ],
      );
    }
    
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                label: 'BILL ID / INVOICE',
                controller: _billIdController,
                hint: 'INV-00123',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                label: 'BILL AMOUNT (AED)',
                controller: _billAmountController,
                hint: '1200',
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                label: 'CUSTOMER NAME',
                controller: _customerNameController,
                hint: 'Ahmed Al Mansouri',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                label: 'CUSTOMER ID / CIF',
                controller: _customerCifController,
                hint: 'CIF-011255',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                label: 'MOBILE NUMBER',
                controller: _mobileController,
                hint: '+971 50 123 4567',
                keyboardType: TextInputType.phone,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                label: 'EMAIL',
                controller: _emailController,
                hint: 'customer@example.com',
                keyboardType: TextInputType.emailAddress,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                label: 'PRODUCT / ITEM',
                controller: _productController,
                hint: 'Samsung 65 inch TV',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTenureDropdown(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF9D8FD9),
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFF7A6BA3),
              fontSize: 13,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(
                color: Color(0xFF5A4E7A),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(
                color: Color(0xFF5A4E7A),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(
                color: Color(0xFF7B68EE),
                width: 1.5,
              ),
            ),
            filled: true,
            fillColor: const Color(0xFF2D1B4E),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTenureDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'EMI TENURE (MONTHS)',
          style: TextStyle(
            color: Color(0xFF9D8FD9),
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFF5A4E7A),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: DropdownButton<String>(
            value: _selectedTenure,
            isExpanded: true,
            underline: const SizedBox(),
            dropdownColor: const Color(0xFF3D2461),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            items: [
              '6 Months',
              '12 Months',
              '18 Months',
              '24 Months',
              '36 Months',
            ].map((tenure) {
              return DropdownMenuItem<String>(
                value: tenure,
                child: Text(tenure),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedTenure = value);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(bool isMobile) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5B7FFF),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                vertical: isMobile ? 12 : 14,
                horizontal: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              elevation: 0,
            ),
            child: Text(
              'Create EMI & Send Consent',
              style: TextStyle(
                fontSize: isMobile ? 12 : 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            onPressed: _clearForm,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(
                color: Color(0xFF6B5FA3),
                width: 1,
              ),
              padding: EdgeInsets.symmetric(
                vertical: isMobile ? 12 : 14,
                horizontal: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Text(
              'Clear Form',
              style: TextStyle(
                fontSize: isMobile ? 12 : 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
       Get.to(BillSettlementPage(onBack: (){}));
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('EMI Application Submitted')),
      // );
    }
  }

  void _clearForm() {
    _formKey.currentState!.reset();
    setState(() {
      _billIdController.clear();
      _billAmountController.clear();
      _customerNameController.clear();
      _customerCifController.clear();
      _mobileController.clear();
      _emailController.clear();
      _productController.clear();
      _selectedTenure = '12 Months';
    });
  }
}

// Placeholder class - replace with your actual EMIApplication model
