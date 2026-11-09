import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:original_stock/core/app_theme.dart';
import 'package:original_stock/core/money.dart';
import 'package:original_stock/core/service_locator.dart';
import 'package:original_stock/core/user_repository.dart';
import 'package:original_stock/models/order_model.dart';
import 'package:original_stock/provider.dart';
import 'package:original_stock/screens/notifications_screen.dart';
import 'package:original_stock/widgets/circular_icon_button.dart';
import 'package:original_stock/widgets/pill_button.dart';
import 'package:original_stock/widgets/skeletons.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserProfileData _userData = const UserProfileData();
  bool _isLoading = true;
  int _ordersCount = 0;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final data = await UserRepository.instance.getUserProfile();
    int count = 0;
    try {
      final orders = await orderRepository.getOrders(data.phone);
      count = orders.length;
    } catch (_) {}
    if (mounted) {
      setState(() {
        _userData = data;
        _ordersCount = count;
        _isLoading = false;
      });
    }
  }

  void _openEditForm() {
    final nameCtrl = TextEditingController(text: _userData.name);
    final phoneCtrl = TextEditingController(text: _userData.phone);
    final addressCtrl = TextEditingController(text: _userData.address);
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.card)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 20.h,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24.h,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Edit Contact Info', style: AppText.titleMedium()),
                    CircularIconButton(
                      iconData: Icons.close_rounded,
                      size: 36.r,
                      onTap: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                Gap(16.h),
                Text(
                  'Full Name',
                  style: AppText.bodySmall(color: AppColors.text),
                ),
                Gap(6.h),
                TextFormField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(hintText: 'Enter your name'),
                  validator: (v) => (v == null || v.trim().length < 2)
                      ? 'Please enter your name'
                      : null,
                ),
                Gap(14.h),
                Text(
                  'Egyptian Mobile (WhatsApp)',
                  style: AppText.bodySmall(color: AppColors.text),
                ),
                Gap(6.h),
                TextFormField(
                  controller: phoneCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: '010XXXXXXXX, 011..., 012..., 015...',
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Please enter your phone number';
                    }
                    if (!UserRepository.isValidEgyptianPhone(v)) {
                      return 'Enter a valid Egyptian mobile number';
                    }
                    return null;
                  },
                ),
                Gap(14.h),
                Text(
                  'Delivery Address',
                  style: AppText.bodySmall(color: AppColors.text),
                ),
                Gap(6.h),
                TextFormField(
                  controller: addressCtrl,
                  decoration: const InputDecoration(
                    hintText: 'Street, Building, City',
                  ),
                ),
                Gap(24.h),
                PillButton(
                  label: 'Save Details',
                  onPressed: () async {
                    if (formKey.currentState?.validate() ?? false) {
                      final updated = _userData.copyWith(
                        name: nameCtrl.text.trim(),
                        phone: UserRepository.normalizeEgyptianPhone(
                          phoneCtrl.text.trim(),
                        ),
                        address: addressCtrl.text.trim(),
                      );
                      await UserRepository.instance.saveUserProfile(updated);
                      if (ctx.mounted) {
                        Navigator.pop(ctx);
                      }
                      if (mounted) {
                        _loadUser();
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showOrdersDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.card)),
      ),
      builder: (ctx) {
        return _OrdersSheet(
          phone: _userData.phone,
          onOrdersLoaded: (count) {
            if (mounted) {
              setState(() {
                _ordersCount = count;
              });
            }
          },
        );
      },
    );
  }

  void _showSupportDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.card)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Customer Support', style: AppText.titleMedium()),
              Gap(12.h),
              Text(
                'Our menswear advisors are available on WhatsApp Sunday to Thursday, 10 AM - 10 PM.',
                style: AppText.bodyMedium(color: AppColors.textSecondary),
              ),
              Gap(18.h),
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  border: Border.all(color: AppColors.hairline),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.chat_bubble_outline_rounded,
                      color: AppColors.primary,
                    ),
                    Gap(12.w),
                    Text(
                      'WhatsApp: +20 100 000 0000',
                      style: AppText.titleSmall(),
                    ),
                  ],
                ),
              ),
              Gap(20.h),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final wishlistCount = context.watch<ProviderProduct>().wishlistCount;

    final displayName =
        _userData.name.isNotEmpty ? _userData.name : 'Guest Shopper';
    final displayPhone =
        _userData.phone.isNotEmpty ? _userData.phone : 'No phone set (Tap edit)';
    final displayAddress = _userData.address.isNotEmpty
        ? _userData.address
        : 'No saved address';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(12.h),
                    Text(
                      'My Profile',
                      style: AppText.titleLarge(color: AppColors.text),
                    ),
                    Gap(20.h),

                    // Customer Details Card
                    Container(
                      padding: EdgeInsets.all(18.r),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.card),
                        border: Border.all(color: AppColors.hairline, width: 1),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 54.r,
                            width: 54.r,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryLight,
                            ),
                            child: Center(
                              child: Text(
                                displayName.isNotEmpty
                                    ? displayName[0].toUpperCase()
                                    : 'G',
                                style: TextStyle(
                                  fontFamily: AppText.fontFamily,
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                          Gap(14.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  displayName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppText.titleSmall(),
                                ),
                                Gap(2.h),
                                Text(
                                  displayPhone,
                                  style: AppText.caption(),
                                ),
                                Gap(2.h),
                                Text(
                                  displayAddress,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppText.caption(),
                                ),
                              ],
                            ),
                          ),
                          Gap(8.w),
                          // Edit pill button
                          GestureDetector(
                            onTap: _openEditForm,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(
                                  AppRadius.pill,
                                ),
                                border: Border.all(color: AppColors.hairline),
                              ),
                              child: Text(
                                'Edit',
                                style: TextStyle(
                                  fontFamily: AppText.fontFamily,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gap(18.h),

                    // Stat Badges
                    Row(
                      children: [
                        _buildStatCard(
                          'Orders',
                          '$_ordersCount',
                          () => _showOrdersDialog(),
                        ),
                        Gap(12.w),
                        _buildStatCard('Wishlist', '$wishlistCount', null),
                        Gap(12.w),
                        _buildStatCard(
                          'Support',
                          '24/7',
                          () => _showSupportDialog(),
                        ),
                      ],
                    ),
                    Gap(24.h),

                    // Menu Options
                    Text(
                      'Account & Preferences',
                      style: AppText.titleSmall(),
                    ),
                    Gap(12.h),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.card),
                        border: Border.all(color: AppColors.hairline, width: 1),
                      ),
                      child: Column(
                        children: [
                          _buildMenuItem(
                            icon: Icons.inventory_2_outlined,
                            title: 'My orders',
                            subtitle: 'Track active orders and delivery status',
                            onTap: _showOrdersDialog,
                          ),
                          const Divider(),
                          _buildMenuItem(
                            icon: Icons.location_on_outlined,
                            title: 'Saved addresses',
                            subtitle: displayAddress,
                            onTap: _openEditForm,
                          ),
                          const Divider(),
                          _buildMenuItem(
                            icon: Icons.notifications_none_rounded,
                            title: 'Notifications',
                            subtitle: 'Order tracking and sales alerts',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationsScreen(),
                                ),
                              );
                            },
                          ),
                          const Divider(),
                          _buildMenuItem(
                            icon: Icons.headset_mic_outlined,
                            title: 'Customer support',
                            subtitle: 'Direct WhatsApp assistance',
                            onTap: _showSupportDialog,
                          ),
                          const Divider(),
                          _buildMenuItem(
                            icon: Icons.info_outline_rounded,
                            title: 'About Original Stock',
                            subtitle: 'Egyptian premium menswear brand',
                            onTap: () {
                              showAboutDialog(
                                context: context,
                                applicationName: 'Original Stock',
                                applicationVersion: '1.0.0',
                                applicationIcon: Image.asset(
                                  'assets/images/logo.png',
                                  height: 40.r,
                                ),
                                children: [
                                  Text(
                                    'Original Stock is a curated Egyptian menswear label delivering soft luxury, timeless cuts, and effortless everyday tailoring.',
                                    style: AppText.bodyMedium(),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Gap(AppSpacing.navClearance), // Clearance for bottom nav
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildStatCard(String title, String count, VoidCallback? onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: AppColors.hairline, width: 1),
          ),
          child: Column(
            children: [
              Text(
                count,
                style: TextStyle(
                  fontFamily: AppText.fontFamily,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              Gap(4.h),
              Text(
                title,
                style: AppText.caption(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      type: MaterialType.transparency,
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        leading: Container(
          height: 38.r,
          width: 38.r,
          decoration: const BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20.r, color: AppColors.primary),
        ),
        title: Text(title, style: AppText.titleSmall(fontSize: 14.sp)),
        subtitle: Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppText.caption(),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          size: 22.r,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _OrdersSheet extends StatefulWidget {
  final String phone;
  final ValueChanged<int>? onOrdersLoaded;

  const _OrdersSheet({
    required this.phone,
    this.onOrdersLoaded,
  });

  @override
  State<_OrdersSheet> createState() => _OrdersSheetState();
}

class _OrdersSheetState extends State<_OrdersSheet> {
  List<OrderModel> _orders = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final orders = await orderRepository.getOrders(widget.phone);
      if (mounted) {
        setState(() {
          _orders = orders;
          _isLoading = false;
        });
        widget.onOrdersLoaded?.call(orders.length);
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Unable to load orders. Please try again.';
          _isLoading = false;
        });
      }
    }
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      padding: EdgeInsets.fromLTRB(
        20.w,
        20.h,
        20.w,
        MediaQuery.of(context).viewInsets.bottom + 24.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('My Orders', style: AppText.titleMedium()),
              CircularIconButton(
                iconData: Icons.close_rounded,
                size: 36.r,
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
          Gap(16.h),
          if (_isLoading)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const OrderTileSkeleton(),
                Gap(12.h),
                const OrderTileSkeleton(),
              ],
            )
          else if (_errorMessage != null)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 30.h),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.cloud_off_rounded,
                      size: 44.r,
                      color: AppColors.textSecondary,
                    ),
                    Gap(12.h),
                    Text(
                      'Failed to load orders',
                      style: AppText.titleSmall(),
                    ),
                    Gap(4.h),
                    Text(
                      _errorMessage!,
                      style: AppText.bodySmall(color: AppColors.textSecondary),
                    ),
                    Gap(16.h),
                    SizedBox(
                      width: 140.w,
                      child: PillButton(
                        label: 'Try Again',
                        height: 44.h,
                        onPressed: _fetchOrders,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (_orders.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 40.h),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 44.r,
                      color: AppColors.textSecondary,
                    ),
                    Gap(12.h),
                    Text(
                      'No orders yet',
                      style: AppText.titleSmall(),
                    ),
                    Gap(4.h),
                    Text(
                      'Your placed orders will appear here.',
                      style: AppText.bodySmall(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: _orders.length,
                separatorBuilder: (context, index) => Gap(12.h),
                itemBuilder: (context, index) {
                  final order = _orders[index];
                  return Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.card),
                      border: Border.all(color: AppColors.hairline),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 40.r,
                              width: 40.r,
                              decoration: const BoxDecoration(
                                color: AppColors.primaryLight,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.inventory_2_outlined,
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ),
                            Gap(12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    order.orderNumber,
                                    style: AppText.titleSmall(),
                                  ),
                                  Gap(2.h),
                                  Text(
                                    _formatDate(order.createdAt),
                                    style: AppText.caption(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(
                                  AppRadius.pill,
                                ),
                              ),
                              child: Text(
                                order.status,
                                style: TextStyle(
                                  fontFamily: AppText.fontFamily,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Gap(12.h),
                        const Divider(height: 1, color: AppColors.hairline),
                        Gap(10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${order.items.length} ${order.items.length == 1 ? 'item' : 'items'}',
                              style: AppText.bodySmall(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  'Total: ',
                                  style: AppText.bodySmall(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                Text(
                                  egp(order.total),
                                  style: TextStyle(
                                    fontFamily: AppText.fontFamily,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
