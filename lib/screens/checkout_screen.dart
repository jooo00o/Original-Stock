import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:original_stock/core/app_theme.dart';
import 'package:original_stock/core/money.dart';
import 'package:original_stock/core/service_locator.dart';
import 'package:original_stock/core/user_repository.dart';
import 'package:original_stock/models/order_model.dart';
import 'package:original_stock/provider.dart';
import 'package:original_stock/screens/otp_verification_screen.dart';
import 'package:original_stock/widgets/circular_icon_button.dart';
import 'package:original_stock/widgets/pill_button.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedUserData();
  }

  Future<void> _loadSavedUserData() async {
    final user = await UserRepository.instance.getUserProfile();
    if (mounted) {
      setState(() {
        if (user.name.isNotEmpty && _nameController.text.isEmpty) {
          _nameController.text = user.name;
        }
        if (user.phone.isNotEmpty && _phoneController.text.isEmpty) {
          _phoneController.text = user.phone;
        }
        if (user.address.isNotEmpty && _addressController.text.isEmpty) {
          _addressController.text = user.address;
        }
        if (user.email.isNotEmpty && _emailController.text.isEmpty) {
          _emailController.text = user.email;
        }
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _onPlaceOrder(double totalAmount) async {
    if (_formKey.currentState?.validate() ?? false) {
      // Save info locally for pre-filling next time
      final normalizedPhone = UserRepository.normalizeEgyptianPhone(
        _phoneController.text.trim(),
      );

      final profile = UserProfileData(
        name: _nameController.text.trim(),
        phone: normalizedPhone,
        address: _addressController.text.trim(),
        email: _emailController.text.trim(),
      );

      await UserRepository.instance.saveUserProfile(profile);

      if (!mounted) return;

      final cartProvider = context.read<ProviderProduct>();
      final draft = OrderModel(
        id: '',
        orderNumber: '',
        items: cartProvider.cartItems
            .map((ci) => OrderItemModel(
                  productId: ci.product.id,
                  productName: ci.product.name,
                  productImage: ci.product.image,
                  size: ci.size,
                  color: ci.color,
                  quantity: ci.quantity,
                  unitPrice: ci.unitPrice,
                  totalPrice: ci.totalPrice,
                ))
            .toList(),
        subtotal: cartProvider.subtotal,
        delivery: cartProvider.deliveryCharge,
        total: totalAmount,
        customer: CustomerModel(
          name: profile.name,
          phone: profile.phone,
          address: profile.address,
          email: profile.email,
        ),
        createdAt: DateTime.now(),
      );

      // Trigger OTP request through OrderRepository
      try {
        await orderRepository.requestOtp(normalizedPhone);
      } catch (_) {}

      if (!mounted) return;

      // Navigate to OTP Verification screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpVerificationScreen(
            phoneNumber: normalizedPhone,
            totalAmount: totalAmount,
            draftOrder: draft,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<ProviderProduct>();
    final bool isCartEmpty = cartProvider.cartItems.isEmpty;

    // Checkout must always charge exactly what is in the cart
    final double subtotal = cartProvider.subtotal;
    final double delivery = cartProvider.deliveryCharge;
    final double totalPayment = cartProvider.totalPayment;
    final int itemCount = cartProvider.totalItemCount;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
                children: [
                  // Header
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 12.h,
                    ),
                    child: Row(
                      children: [
                        CircularIconButton(
                          iconData: Icons.arrow_back_ios_new_rounded,
                          onTap: () => Navigator.pop(context),
                        ),
                        const Spacer(),
                        Text(
                          'Checkout',
                          style: AppText.titleMedium(color: AppColors.text),
                        ),
                        const Spacer(),
                        SizedBox(width: 44.r),
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Gap(12.h),

                            // Contact & Shipping Information
                            Text(
                              'Shipping details',
                              style: AppText.titleSmall(color: AppColors.text),
                            ),
                            Gap(16.h),

                            // Full Name
                            _buildInputField(
                              controller: _nameController,
                              label: 'Full name',
                              hint: 'Enter your full name',
                              icon: Icons.person_outline_rounded,
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Please enter your name';
                                }
                                if (val.trim().length < 3) {
                                  return 'Name must be at least 3 characters';
                                }
                                return null;
                              },
                            ),
                            Gap(14.h),

                            // Egyptian Phone Number
                            _buildInputField(
                              controller: _phoneController,
                              label: 'Phone number (WhatsApp)',
                              hint: '010XXXXXXXX, 011..., 012..., 015...',
                              icon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Please enter your Egyptian phone number';
                                }
                                if (!UserRepository.isValidEgyptianPhone(val)) {
                                  return 'Enter a valid Egyptian mobile number (e.g. 01012345678)';
                                }
                                return null;
                              },
                            ),
                            Gap(14.h),

                            // Delivery Address
                            _buildInputField(
                              controller: _addressController,
                              label: 'Delivery address',
                              hint: 'Building, Street, Area, City',
                              icon: Icons.location_on_outlined,
                              maxLines: 2,
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Please enter your delivery address';
                                }
                                if (val.trim().length < 5) {
                                  return 'Please enter a complete address';
                                }
                                return null;
                              },
                            ),
                            Gap(14.h),

                            // Optional Email
                            _buildInputField(
                              controller: _emailController,
                              label: 'Email (optional)',
                              hint: 'name@example.com',
                              icon: Icons.mail_outline_rounded,
                              keyboardType: TextInputType.emailAddress,
                              validator: (val) {
                                if (val != null &&
                                    val.trim().isNotEmpty &&
                                    !val.contains('@')) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            Gap(24.h),

                            // Payment Method
                            Text(
                              'Payment method',
                              style: AppText.titleSmall(color: AppColors.text),
                            ),
                            Gap(12.h),
                            Container(
                              padding: EdgeInsets.all(16.r),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(
                                  AppRadius.card,
                                ),
                                border: Border.all(
                                  color: AppColors.primary,
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 40.r,
                                    width: 40.r,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.primaryLight,
                                    ),
                                    child: Icon(
                                      Icons.payments_outlined,
                                      color: AppColors.primary,
                                      size: 22.r,
                                    ),
                                  ),
                                  Gap(14.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Cash on delivery',
                                          style: AppText.titleSmall(
                                            color: AppColors.text,
                                            fontSize: 15.sp,
                                          ),
                                        ),
                                        Text(
                                          'Pay in cash upon receiving your order',
                                          style: AppText.caption(
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    color: AppColors.primary,
                                  ),
                                ],
                              ),
                            ),
                            Gap(24.h),

                            // Order Summary
                            Text(
                              'Order summary',
                              style: AppText.titleSmall(color: AppColors.text),
                            ),
                            Gap(12.h),
                            Container(
                              padding: EdgeInsets.all(18.r),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(
                                  AppRadius.card,
                                ),
                                border: Border.all(
                                  color: AppColors.hairline,
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  _summaryRow(
                                    'Total items',
                                    '$itemCount ${itemCount == 1 ? "item" : "items"}',
                                  ),
                                  Gap(10.h),
                                  _summaryRow('Subtotal', egp(subtotal)),
                                  Gap(10.h),
                                  _summaryRow(
                                    'Delivery',
                                    delivery == 0.0 ? 'Free' : egp(delivery),
                                    valueColor: AppColors.primary,
                                  ),
                                  Gap(12.h),
                                  const Divider(),
                                  Gap(12.h),
                                  _summaryRow(
                                    'Total payment',
                                    egp(totalPayment),
                                    isTotal: true,
                                  ),
                                ],
                              ),
                            ),
                            Gap(30.h),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Bottom Action Bar
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 14.h,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.background,
                      border: Border(
                        top: BorderSide(color: AppColors.hairline, width: 1),
                      ),
                    ),
                    child: PillButton(
                      label: isCartEmpty
                          ? 'Your cart is empty'
                          : 'Place order • ${egp(totalPayment)}',
                      onPressed: isCartEmpty
                          ? null
                          : () => _onPlaceOrder(totalPayment),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: AppText.fontFamily,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        Gap(6.h),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          style: TextStyle(
            fontFamily: AppText.fontFamily,
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(
              icon,
              size: 20.r,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _summaryRow(
    String title,
    String value, {
    bool isTotal = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: AppText.fontFamily,
            fontSize: isTotal ? 16.sp : 14.sp,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: isTotal ? AppColors.text : AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: AppText.fontFamily,
            fontSize: isTotal ? 17.sp : 14.sp,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
            color: valueColor ?? AppColors.text,
          ),
        ),
      ],
    );
  }
}
