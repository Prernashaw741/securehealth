import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:securehealth/constants/colors.dart';
import 'package:securehealth/utils/animations.dart';
import 'package:securehealth/utils/ui_helpers.dart';

class PrescriptionDetailsPage extends StatelessWidget {
  final Map<String, dynamic> extractedData;
  
  const PrescriptionDetailsPage({
    super.key,
    required this.extractedData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SecureHealthColors.neutralGrey10,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Prescription Details',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: SecureHealthColors.neutralDark,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: SecureHealthColors.neutralDark),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Success Message
            FadeInAnimation(
              duration: const Duration(milliseconds: 600),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green.shade600,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Prescription extracted successfully!',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.green.shade800,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Doctor Information
            _buildSection(
              context,
              'Doctor Information',
              Icons.medical_information,
              _buildDoctorInfo(),
              0,
            ),
            
            const SizedBox(height: 16),
            
            // Patient Information
            _buildSection(
              context,
              'Patient Information',
              Icons.person,
              _buildPatientInfo(),
              1,
            ),
            
            const SizedBox(height: 16),
            
            // Medications
            _buildSection(
              context,
              'Medications',
              Icons.medication,
              _buildMedicationsList(),
              2,
            ),
            
            const SizedBox(height: 16),
            
            // Tests
            if (extractedData['tests'] != null && (extractedData['tests'] as List).isNotEmpty)
              _buildSection(
                context,
                'Recommended Tests',
                Icons.science,
                _buildTestsList(),
                3,
              ),
            
            const SizedBox(height: 16),
            
            // General Instructions
            if (extractedData['general_instructions'] != null && extractedData['general_instructions'].toString().isNotEmpty)
              _buildSection(
                context,
                'General Instructions',
                Icons.info,
                _buildInstructions(),
                4,
              ),
            
            const SizedBox(height: 32),
            
            // Action Buttons
            FadeInAnimation(
              duration: const Duration(milliseconds: 600),
              delay: Duration(milliseconds: 800),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('Done'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SecureHealthColors.coolOrange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Implement save functionality
                      },
                      icon: const Icon(Icons.save),
                      label: const Text('Save to Documents'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: SecureHealthColors.coolOrange,
                        side: BorderSide(color: SecureHealthColors.coolOrange),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    IconData icon,
    Widget content,
    int index,
  ) {
    return StaggeredItemAnimation(
      index: index,
      baseDelay: const Duration(milliseconds: 200),
      child: Container(
        decoration: UIHelpers.cardDecoration(
          color: Colors.white,
          boxShadow: UIHelpers.elevationShadow(1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: SecureHealthColors.coolOrange.withOpacity(0.05),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: SecureHealthColors.coolOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: SecureHealthColors.coolOrange,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: SecureHealthColors.neutralDark,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: content,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorInfo() {
    final doctorInfo = extractedData['doctor_information'] as Map<String, dynamic>?;
    
    if (doctorInfo == null) {
      return const Text('No doctor information available');
    }

    return Column(
      children: [
        _buildInfoRow('Name', doctorInfo['name']),
        _buildInfoRow('Specialization', doctorInfo['specialization']),
        _buildInfoRow('Registration Number', doctorInfo['registration_number']),
        _buildInfoRow('Clinic', doctorInfo['clinic_name']),
        _buildInfoRow('Address', doctorInfo['address']),
        _buildInfoRow('Phone', doctorInfo['phone']),
      ],
    );
  }

  Widget _buildPatientInfo() {
    final patientInfo = extractedData['patient_information'] as Map<String, dynamic>?;
    
    if (patientInfo == null) {
      return const Text('No patient information available');
    }

    return Column(
      children: [
        _buildInfoRow('Name', patientInfo['name']),
        _buildInfoRow('Age', patientInfo['age']),
        _buildInfoRow('Gender', patientInfo['gender']),
      ],
    );
  }

  Widget _buildMedicationsList() {
    final medications = extractedData['medications'] as List<dynamic>?;
    
    if (medications == null || medications.isEmpty) {
      return const Text('No medications prescribed');
    }

    return Column(
      children: medications.asMap().entries.map((entry) {
        final index = entry.key;
        final medication = entry.value as Map<String, dynamic>;
        
        return Container(
          margin: EdgeInsets.only(bottom: index < medications.length - 1 ? 12 : 0),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: SecureHealthColors.neutralGrey10,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: SecureHealthColors.neutralGrey4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                medication['medicine_name'] ?? 'Unknown Medication',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: SecureHealthColors.neutralDark,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildMedInfoChip('Dosage', medication['dosage']),
                  const SizedBox(width: 8),
                  _buildMedInfoChip('Frequency', medication['frequency']),
                ],
              ),
              const SizedBox(height: 8),
              _buildMedInfoChip('Duration', medication['duration']),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTestsList() {
    final tests = extractedData['tests'] as List<dynamic>?;
    
    if (tests == null || tests.isEmpty) {
      return const Text('No tests recommended');
    }

    return Column(
      children: tests.asMap().entries.map((entry) {
        final index = entry.key;
        final test = entry.value.toString();
        
        return Container(
          margin: EdgeInsets.only(bottom: index < tests.length - 1 ? 8 : 0),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: SecureHealthColors.coolBlue.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: SecureHealthColors.coolBlue.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.science,
                color: SecureHealthColors.coolBlue,
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  test,
                  style: const TextStyle(
                    color: SecureHealthColors.neutralDark,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInstructions() {
    final instructions = extractedData['general_instructions']?.toString() ?? '';
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: SecureHealthColors.darkPurple.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: SecureHealthColors.darkPurple.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info,
            color: SecureHealthColors.darkPurple,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              instructions,
              style: const TextStyle(
                color: SecureHealthColors.neutralDark,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: SecureHealthColors.neutralMedium,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'Not specified',
              style: const TextStyle(
                color: SecureHealthColors.neutralDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedInfoChip(String label, String? value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: SecureHealthColors.neutralGrey4),
      ),
      child: Text(
        '$label: ${value ?? 'N/A'}',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: SecureHealthColors.neutralDark,
        ),
      ),
    );
  }
}