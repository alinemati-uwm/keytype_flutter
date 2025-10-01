import '../../ui_imports.dart';
import '../custom_button.dart';
import '../custom_text_widget.dart';
import '../bottom_sheet/custom_bottom_sheet.dart';

class CreditsErrorModal extends StatelessWidget {
  final double creditBalance;
  final double estimatedCost;
  final double requiredCredits;
  final double shortfall;
  final String currency;
  final String suggestion;
  final String detail;

  const CreditsErrorModal({
    super.key,
    required this.creditBalance,
    required this.estimatedCost,
    required this.requiredCredits,
    required this.shortfall,
    required this.currency,
    required this.suggestion,
    required this.detail,
  });

  static void show({
    required BuildContext context,
    required Map<String, dynamic> errorData,
  }) {
    print('[DEBUG] CreditsErrorModal.show called');
    print('[DEBUG] Context: $context');
    print('[DEBUG] Error data: $errorData');
    
    CustomBottomSheet.show(
      context: context,
      child: (scrollController) {
        print('[DEBUG] Building CreditsErrorModal widget');
        return CreditsErrorModal(
          creditBalance: (errorData['credit_balance'] as num?)?.toDouble() ?? 0.0,
          estimatedCost: (errorData['estimated_cost'] as num?)?.toDouble() ?? 0.0,
          requiredCredits: (errorData['required_credits'] as num?)?.toDouble() ?? 0.0,
          shortfall: (errorData['shortfall'] as num?)?.toDouble() ?? 0.0,
          currency: errorData['currency'] as String? ?? '\$',
          suggestion: errorData['suggestion'] as String? ?? 'Please add credits to your account.',
          detail: errorData['detail'] as String? ?? 'Insufficient credits.',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          Gap(20),
          _buildCreditInfo(),
          Gap(20),
          _buildActionButtons(),
          Gap(10),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFF6B6B),
                Color(0xFFFF8E53),
              ],
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Icon(
            Icons.account_balance_wallet_outlined,
            color: Colors.white,
            size: 30,
          ),
        ),
        Gap(16),
        Text(
          'Insufficient Credits',
          style: AppTextTheme.textStyleDMSanse20W700(),
          textAlign: TextAlign.center,
        ),
        Gap(8),
        Text(
          detail,
          style: AppTextTheme.textStyleDMSanse14W400(
            color: AppColors.white.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCreditInfo() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF667eea).withOpacity(0.1),
            Color(0xFF764ba2).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color(0xFF667eea).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildCreditRow(
            'Current Balance',
            '${creditBalance.toStringAsFixed(1)} credits',
            Icons.account_balance_wallet,
            creditBalance > 0 ? Color(0xFF4CAF50) : Color(0xFFFF6B6B),
          ),
          Gap(12),
          _buildCreditRow(
            'Required Credits',
            '${requiredCredits.toStringAsFixed(1)} credits',
            Icons.info_outline,
            Color(0xFF2196F3),
          ),
          Gap(12),
          _buildCreditRow(
            'Shortfall',
            '${shortfall.toStringAsFixed(1)} credits',
            Icons.trending_down,
            Color(0xFFFF6B6B),
          ),
          Gap(12),
          _buildCreditRow(
            'Estimated Cost',
            '$currency${estimatedCost.toStringAsFixed(2)}',
            Icons.attach_money,
            Color(0xFFFF9800),
          ),
        ],
      ),
    );
  }

  Widget _buildCreditRow(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 16,
          ),
        ),
        Gap(12),
        Expanded(
          child: Text(
            label,
            style: AppTextTheme.textStyleDMSanse14W400(
              color: AppColors.white.withOpacity(0.8),
            ),
          ),
        ),
        Text(
          value,
          style: AppTextTheme.textStyleDMSanse14W700(
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Suggestion text
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Color(0xFF4CAF50).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Color(0xFF4CAF50).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: Color(0xFF4CAF50),
                size: 16,
              ),
              Gap(8),
              Expanded(
                child: Text(
                  suggestion,
                  style: AppTextTheme.textStyleDMSanse12W400(
                    color: Color(0xFF4CAF50),
                  ),
                ),
              ),
            ],
          ),
        ),
        Gap(16),
        // Action buttons
        Row(
          children: [
            Expanded(
              child: CustomButton(
                color: AppColors.grey,
                withShadow: false,
                text: 'Later',
                onTap: () => Get.back(),
              ),
            ),
            Gap(12),
            Expanded(
              flex: 2,
              child: CustomButton(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF4CAF50),
                        Color(0xFF45A049),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_card,
                        color: Colors.white,
                        size: 18,
                      ),
                      Gap(8),
                      CustomTextWidget(
                        'Add Credits',
                        style: AppTextTheme.textStyleDMSanse14W700(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Get.back();
                  // Navigate to credits/payment screen
                  _navigateToCredits();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _navigateToCredits() {
    ToastDialogs.showErrorIconNotification(
      message: 'Credit purchase feature coming soon!',
    );
  }
}