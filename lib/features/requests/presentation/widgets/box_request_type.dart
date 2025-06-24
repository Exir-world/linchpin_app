import 'package:flutter/material.dart';
import 'package:linchpin_app/core/common/text_widgets.dart';
import 'package:linchpin_app/features/requests/domain/entity/request_types_entity.dart';
import 'package:linchpin_app/features/requests/presentation/request_detail_screen.dart';
import 'package:linchpin_app/features/requests/presentation/widgets/clock_box.dart';
import 'package:linchpin_app/gen/assets.gen.dart';

class BoxRequestType extends StatefulWidget {
  final List<RequestTypesEntity> state;

  const BoxRequestType({
    required this.state,
    super.key,
  });

  @override
  State<BoxRequestType> createState() => _BoxRequestTypeState();
  static ValueNotifier<String?> selectedItemNotifire = ValueNotifier(null);
}

class _BoxRequestTypeState extends State<BoxRequestType> {
  String getTypeLabel(String type) {
    final typeLabels = {
      'SICK_LEAVE': 'مرخصی استعلاجی',
      'HOURLY_LEAVE': 'مرخصی ساعتی',
      'DAILY_LEAVE': 'مرخصی روزانه',
      'MANUAL_CHECK_OUT': 'تردد دستی (خروج)',
      'MANUAL_CHECK_IN': 'تردد دستی (ورود)',
    };

    return typeLabels[type] ?? '';
  }

  String? selectedItem;
  String? selecteditemName;
  OverlayEntry? _dropdownOverlay;
  bool _isDropdownOpen = false;
  void _toggleDropdown(BuildContext context) {
    if (_isDropdownOpen) {
      _closeDropdown();
    } else {
      // زمانی که کاربر خارج از متن کلیک کند، فوکوس برداشته می‌شود
      FocusScope.of(context).requestFocus(FocusNode());
      _openDropdown(context);
    }
  }

  void _openDropdown(BuildContext context) {
    final overlay = Overlay.of(context);
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    _dropdownOverlay = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: _closeDropdown,
            child: Container(
              color: Colors.transparent, // لایه شفاف برای تشخیص کلیک
            ),
          ),
          Positioned(
            left: position.dx,
            top: position.dy + renderBox.size.height + 8,
            width: renderBox.size.width,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Material(
                elevation: 0,
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.state.map((RequestTypesEntity item) {
                    final title = getTypeLabel(item.requestId!);
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedItem = item.requestId;
                          selecteditemName = title;
                          BoxRequestType.selectedItemNotifire.value =
                              item.requestId;
                          RequestDetailScreen.startDateNotifire.value = null;
                          RequestDetailScreen.endDateNotifire.value = null;
                          ClockBox.hourNotifireStrat.value = null;
                          ClockBox.minuteNotifireStart.value = null;
                          _closeDropdown();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 12,
                        ),
                        child: Row(
                          children: [
                            NormalRegular(title),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    overlay.insert(_dropdownOverlay!);
    setState(() {
      _isDropdownOpen = true;
    });
  }

  void _closeDropdown() {
    _dropdownOverlay?.remove();
    setState(() {
      _isDropdownOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isDropdownOpen) {
          _closeDropdown();
          return false;
        }
        return true;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const NormalMedium('نوع درخواست'),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => _toggleDropdown(
              context,
            ),
            child: Container(
              width: double.infinity,
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _isDropdownOpen
                      ? const Color(0xff861C8C)
                      : const Color(0xffE0E0F9),
                ),
              ),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NormalRegular(
                    selecteditemName ?? 'انتخاب کنید',
                    textColorInLight: selectedItem == null
                        ? const Color(0xffCAC4CF)
                        : const Color(0xff540E5C),
                  ),
                  Assets.icons.chevronUpDown.svg(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
