import 'package:flutter/material.dart';
import 'package:linchpin_app/core/common/dimens.dart';
import 'package:linchpin_app/core/common/text_widgets.dart';
import 'package:linchpin_app/features/requests/presentation/widgets/persian_calender/persian_calendar.dart';
import 'package:linchpin_app/features/root/presentation/app_bar_root.dart';
import 'package:linchpin_app/gen/assets.gen.dart';

class RequestDetailScreen extends StatefulWidget {
  const RequestDetailScreen({super.key});

  @override
  State<RequestDetailScreen> createState() => _RequestDetailScreenState();
}

class _RequestDetailScreenState extends State<RequestDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarRoot(context, true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: padding_Horizantalx),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24),
              BigDemiBold('ثبت درخواست'),
              SizedBox(height: 24),
              BoxRequestType(),
              SizedBox(height: 24),
              PersianCalendar(
                initialDate: DateTime(2025, 1, 14),
                onDateSelected: (
                  persianDateSlash,
                  persianDateHyphen,
                  englishDateIso8601,
                ) {
                  debugPrint(persianDateSlash);
                  debugPrint(persianDateHyphen);
                  debugPrint(englishDateIso8601);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BoxRequestType extends StatefulWidget {
  const BoxRequestType({super.key});

  @override
  State<BoxRequestType> createState() => _BoxRequestTypeState();
}

class _BoxRequestTypeState extends State<BoxRequestType> {
  String? selectedItem;
  OverlayEntry? _dropdownOverlay;
  bool _isDropdownOpen = false;

  final List<String> items = [
    'تردد دستی (ورود)',
    'تردد دستی (خروج)',
    'مرخصی استحقاقی',
    'مرخصی ساعتی',
  ];

  void _toggleDropdown(BuildContext context) {
    if (_isDropdownOpen) {
      _closeDropdown();
    } else {
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
                  children: items.map((String item) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedItem = item;
                          _closeDropdown();
                        });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        child: Row(
                          children: [
                            NormalRegular(item),
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
          NormalMedium('نوع درخواست'),
          SizedBox(height: 12),
          GestureDetector(
            onTap: () => _toggleDropdown(context),
            child: Container(
              width: double.infinity,
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: _isDropdownOpen
                        ? Color(0xff861C8C)
                        : Color(0xffE0E0F9)),
              ),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NormalRegular(
                    selectedItem ?? 'انتخاب کنید',
                    textColorInLight: selectedItem == null
                        ? Color(0xffCAC4CF)
                        : Color(0xff540E5C),
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
