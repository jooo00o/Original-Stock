import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:original_stock/core/app_motion.dart';
import 'package:original_stock/core/app_theme.dart';
import 'package:original_stock/core/service_locator.dart';
import 'package:original_stock/models/order_model.dart';
import 'package:original_stock/provider.dart';
import 'package:original_stock/screens/order_confirmed.dart';
import 'package:original_stock/widgets/circular_icon_button.dart';
import 'package:original_stock/widgets/pill_button.dart';
import 'package:provider/provider.dart';

/// Screen to verify OTP code sent to user's WhatsApp before confirming order.
class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final double totalAmount;
  final OrderModel? draftOrder;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.totalAmount,
    this.draftOrder,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  Timer? _timer;
  int _secondsRemaining = 60;
  String? _errorMessage;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    // Auto focus for immediate entry
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  void _startResendTimer() {
    _timer?.cancel();
    setState(() {
      _secondsRemaining = 60;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String get _maskedPhone {
    final clean = widget.phoneNumber.trim();
    if (clean.length >= 4) {
      final last4 = clean.substring(clean.length - 4);
      return last4;
    }
    return clean;
  }

  Future<void> _resendOtp() async {
    try {
      await orderRepository.requestOtp(widget.phoneNumber);
    } catch (_) {}

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('A new 6-digit code has been sent to your WhatsApp.'),
        duration: Duration(seconds: 2),
      ),
    );
    _startResendTimer();
  }

  Future<void> _verifyOtp() async {
    if (_isVerifying) return;

    final code = _otpController.text.trim();
    if (code.length != 6) {
      setState(() {
        _errorMessage = 'Please enter all 6 digits.';
      });
      return;
    }

    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    try {
      // Verify OTP through OrderRepository
      final isVerified = await orderRepository.verifyOtp(
        widget.phoneNumber,
        code,
      );

      if (!isVerified) {
        throw Exception('Invalid OTP code');
      }

      final orderToPlace =
          widget.draftOrder ??
          OrderModel(
            id: '',
            orderNumber: '',
            items: const [],
            subtotal: widget.totalAmount,
            delivery: 0.0,
            total: widget.totalAmount,
            customer: CustomerModel(
              name: 'Guest Customer',
              phone: widget.phoneNumber,
              address: 'Cairo, Egypt',
            ),
            createdAt: DateTime.now(),
          );

      // Place confirmed order through OrderRepository
      final placedOrder = await orderRepository.placeOrder(orderToPlace);

      if (!mounted) return;

      // Clear cart upon successful order placement
      context.read<ProviderProduct>().clearCart();

      Navigator.pushReplacement(
        context,
        fadeScaleRoute(
          OrderConfirmed(
            total: placedOrder.total,
            orderNumber: placedOrder.orderNumber,
          ),
        ),
      );
    } catch (_) {
      if (mounted) {
        setState(() {
          _isVerifying = false;
          _errorMessage = 'Verification failed. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final code = _otpController.text;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(12.h),
              // Top navigation row
              Row(
                children: [
                  CircularIconButton(
                    iconData: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  Text(
                    'Verification',
                    style: AppText.titleMedium(color: AppColors.text),
                  ),
                  const Spacer(),
                  SizedBox(width: 44.r), // Balance spacing
                ],
              ),
              Gap(32.h),

              // Title and subtitle
              Text(
                'Verify your WhatsApp',
                style: AppText.titleLarge(
                  color: AppColors.text,
                  fontSize: 26.sp,
                ),
              ),
              Gap(10.h),
              RichText(
                text: TextSpan(
                  style: AppText.bodyMedium(color: AppColors.textSecondary),
                  children: [
                    const TextSpan(
                      text: 'We sent a code to your WhatsApp number ending in ',
                    ),
                    TextSpan(
                      text: _maskedPhone,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                    const TextSpan(text: '. Enter the 6-digit code below:'),
                  ],
                ),
              ),
              Gap(36.h),

              // Hidden textfield with visible 6 styled boxes
              Stack(
                alignment: Alignment.center,
                children: [
                  Opacity(
                    opacity: 0,
                    child: TextField(
                      controller: _otpController,
                      focusNode: _focusNode,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      onChanged: (val) {
                        setState(() {
                          _errorMessage = null;
                        });
                        if (val.length == 6) {
                          _verifyOtp();
                        }
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      final hasChar = index < code.length;
                      final isFocusedBox =
                          index == code.length || (index == 5 && hasChar);

                      return GestureDetector(
                        onTap: () => _focusNode.requestFocus(),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          height: 56.h,
                          width: 48.w,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(
                              AppRadius.input,
                            ),
                            border: Border.all(
                              color: isFocusedBox
                                  ? AppColors.primary
                                  : AppColors.hairline,
                              width: isFocusedBox ? 1.5 : 1.0,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            hasChar ? code[index] : '',
                            style: TextStyle(
                              fontFamily: AppText.fontFamily,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.text,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),

              if (_errorMessage != null) ...[
                Gap(12.h),
                Center(
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(
                      fontFamily: AppText.fontFamily,
                      fontSize: 13.sp,
                      color: AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],

              Gap(32.h),

              // 60-second timer and Resend button
              Center(
                child: _secondsRemaining > 0
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            size: 18.r,
                            color: AppColors.textSecondary,
                          ),
                          Gap(6.w),
                          Text(
                            'Resend code in 00:${_secondsRemaining.toString().padLeft(2, '0')}',
                            style: AppText.bodyMedium(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      )
                    : TextButton(
                        onPressed: _resendOtp,
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary,
                        ),
                        child: Text(
                          'Resend Code via WhatsApp',
                          style: TextStyle(
                            fontFamily: AppText.fontFamily,
                            fontWeight: FontWeight.w700,
                            fontSize: 15.sp,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
              ),

              Gap(40.h),

              // Confirm button (purple pill, height 54)
              PillButton(
                label: 'Confirm',
                isLoading: _isVerifying,
                onPressed: _verifyOtp,
              ),
              Gap(20.h),
            ],
          ),
        ),
      ),
    );
  }
}
