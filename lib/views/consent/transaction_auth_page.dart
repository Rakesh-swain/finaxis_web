import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:html' as html;

class TransactionAuthPage extends StatefulWidget {
  const TransactionAuthPage({Key? key}) : super(key: key);

  @override
  State<TransactionAuthPage> createState() => _TransactionAuthPageState();
}

class _TransactionAuthPageState extends State<TransactionAuthPage> {
  String? selectedBank;
  bool isLoading = false;

  final Map<String, Map<String, String>> banks = {
    'fab': {'name': 'First Abu Dhabi Bank'},
    'adib': {'name': 'Abu Dhabi Islamic Bank'},
    'enbd': {'name': 'Emirates NBD'},
    'uae': {'name': 'United Arab Bank'},
    'ajman': {'name': 'Ajman Bank'},
    'dib': {'name': 'Dubai Islamic Bank'},
    'cbd': {'name': 'Commercial Bank of Dubai'},
    'fib': {'name': 'First Islamic Bank of Dubai'},
  };

  Future<void> _callSingleApi() async {
    if (selectedBank == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a bank'),
          backgroundColor: Colors.red.shade600,
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
     final url = Uri.parse(
    "https://sandbox-finaxis.bancify.me/finaxis/payment-consent/v1/sip",
  );


      final payload = {
     "organisationId": "233bcd1d-4216-4b3c-a362-9e4a9282bba7",  
     "baseConsentId": "sam",
     "drAccountNo": "10000109010105",
     "crAccountNo": "10000109010101",
     "crBankCode": "10000109010101",
     "drAccountName": "Spectrum",
     "crAccountName": "bankicy",
     "drCurrencyCode": "AED",
     "naration": "Apple Phone purchase",
     "paymentPurposeCode": "ACM",
      "amount": "110.00"
  };

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "x-clientId": "testClient",
        },
        body: jsonEncode(payload),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Request timeout'),
      );

      print('Response: ${response.body}');

if (response.statusCode == 200) {
  final responseData = jsonDecode(response.body);
  final consentUrl = responseData['moreInfo']['data'] as String?;

  if (consentUrl != null && consentUrl.isNotEmpty) {
    html.window.open(consentUrl, "_blank");   // 🔥 opens URL in new tab

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const TransactionAuthPage()),
      );
    }
  }
} else {
  throw Exception('Login failed: ${response.body}');
}
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red.shade600,
          ),
        );
      }
      print('Error: $e');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Main Content Card
                Card(
                  elevation: 6,
                  shadowColor: Colors.blue.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [
                          Colors.white,
                          Colors.blue.shade50,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Header
                        SizedBox(height: 20),
                        Text(
                          'Personal Loan',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: Colors.blue.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.blue.shade200,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            'Bancify - Consent Pending',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 25),
            
                        // Content Section - Align Left
                        SizedBox(
                          width: double.infinity,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
            
                              // Personal Details Header
                              Text(
                                'Personal Details',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.blue.shade900,
                                ),
                              ),
                              const SizedBox(height: 12),
            
                              // Personal Details Section
                              _buildDetailRow('Name', 'Mohamed Al Harthi'),
                              const SizedBox(height: 12),
                              _buildDetailRow('Loan Amount', 'AED 150,000'),
                              const SizedBox(height: 12),
                              _buildDetailRow('Tenure', '12 months'),
                              const SizedBox(height: 14),
            
                              // Bancify Line
                              Text(
                                'Initiated by Bancify Technologies',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              const SizedBox(height: 25),
            
                              // Bank Selection Header
                              Text(
                                'Bank Selection',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.blue.shade900,
                                ),
                              ),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                value: null,
                                decoration: InputDecoration(
                                  hintText: 'Select Bank',
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 14,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Colors.blue.shade200,
                                      width: 1.5,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Colors.blue.shade200,
                                      width: 1.5,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Colors.blue.shade600,
                                      width: 2,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.blue.shade50,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.account_balance,
                                    color: Colors.blue.shade600,
                                    size: 18,
                                  ),
                                ),
                                items: [
                                  ...banks.entries.map((entry) {
                                    return DropdownMenuItem(
                                      value: entry.key,
                                      child: Text(
                                        entry.value['name']!,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    );
                                  }).toList(),
                                ],
                                onChanged: (value) {
                                  setState(() => selectedBank = value);
                                },
                                isExpanded: true,
                                dropdownColor: Colors.white,
                              ),
            
                              // Bank Details - Only Name
                              if (selectedBank != null) ...[
                                const SizedBox(height: 12),
                                Container(
                                    width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    border: Border.all(
                                      color: Colors.blue.shade200,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        banks[selectedBank]!['name']!,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: Colors.blue.shade900,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Consent valid till 12 months',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              SizedBox(height: 30),
                              // Submit Button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: isLoading ? null : _callSingleApi,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade600,
                                    disabledBackgroundColor: Colors.grey.shade400,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 5,
                                    shadowColor: Colors.blue.withOpacity(0.4),
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                          height: 18,
                                          width: 18,
                                          child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                            strokeWidth: 2.5,
                                          ),
                                        )
                                      : const Text(
                                          'Authorize',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                              SizedBox(height: 20)
                      ],
                    ),
                  ),
                
              ],
            ),
                    ),
                  
              )]),
          ))));
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.blue.shade900,
          ),
        ),
      ],
    );
  }
}