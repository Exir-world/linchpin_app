/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/activity-a.svg
  SvgGenImage get activityA => const SvgGenImage('assets/icons/activity-a.svg');

  /// File path: assets/icons/activity.svg
  SvgGenImage get activity => const SvgGenImage('assets/icons/activity.svg');

  /// File path: assets/icons/autumn.svg
  SvgGenImage get autumn => const SvgGenImage('assets/icons/autumn.svg');

  /// File path: assets/icons/board-tasks-a.svg
  SvgGenImage get boardTasksA =>
      const SvgGenImage('assets/icons/board-tasks-a.svg');

  /// File path: assets/icons/board-tasks.svg
  SvgGenImage get boardTasks =>
      const SvgGenImage('assets/icons/board-tasks.svg');

  /// File path: assets/icons/calendar.svg
  SvgGenImage get calendar => const SvgGenImage('assets/icons/calendar.svg');

  /// File path: assets/icons/check-out.svg
  SvgGenImage get checkOut => const SvgGenImage('assets/icons/check-out.svg');

  /// File path: assets/icons/chevron-up-down.svg
  SvgGenImage get chevronUpDown =>
      const SvgGenImage('assets/icons/chevron-up-down.svg');

  /// File path: assets/icons/circle_clock.svg
  SvgGenImage get circleClock =>
      const SvgGenImage('assets/icons/circle_clock.svg');

  /// File path: assets/icons/clock-add-plus-a.svg
  SvgGenImage get clockAddPlusA =>
      const SvgGenImage('assets/icons/clock-add-plus-a.svg');

  /// File path: assets/icons/clock-add-plus.svg
  SvgGenImage get clockAddPlus =>
      const SvgGenImage('assets/icons/clock-add-plus.svg');

  /// File path: assets/icons/clock-add.svg
  SvgGenImage get clockAdd => const SvgGenImage('assets/icons/clock-add.svg');

  /// File path: assets/icons/clock-close.svg
  SvgGenImage get clockClose =>
      const SvgGenImage('assets/icons/clock-close.svg');

  /// File path: assets/icons/clock-dash.svg
  SvgGenImage get clockDash => const SvgGenImage('assets/icons/clock-dash.svg');

  /// File path: assets/icons/combined.svg
  SvgGenImage get combined => const SvgGenImage('assets/icons/combined.svg');

  /// File path: assets/icons/docs.svg
  SvgGenImage get docs => const SvgGenImage('assets/icons/docs.svg');

  /// File path: assets/icons/info.svg
  SvgGenImage get info => const SvgGenImage('assets/icons/info.svg');

  /// File path: assets/icons/pause.svg
  SvgGenImage get pause => const SvgGenImage('assets/icons/pause.svg');

  /// File path: assets/icons/play.svg
  SvgGenImage get play => const SvgGenImage('assets/icons/play.svg');

  /// File path: assets/icons/plus.svg
  SvgGenImage get plus => const SvgGenImage('assets/icons/plus.svg');

  /// File path: assets/icons/ringing.svg
  SvgGenImage get ringing => const SvgGenImage('assets/icons/ringing.svg');

  /// File path: assets/icons/spring.svg
  SvgGenImage get spring => const SvgGenImage('assets/icons/spring.svg');

  /// File path: assets/icons/summer.svg
  SvgGenImage get summer => const SvgGenImage('assets/icons/summer.svg');

  /// File path: assets/icons/tag.svg
  SvgGenImage get tag => const SvgGenImage('assets/icons/tag.svg');

  /// File path: assets/icons/timer-off-sleep.svg
  SvgGenImage get timerOffSleep =>
      const SvgGenImage('assets/icons/timer-off-sleep.svg');

  /// File path: assets/icons/timer-tick-2.svg
  SvgGenImage get timerTick2 =>
      const SvgGenImage('assets/icons/timer-tick-2.svg');

  /// File path: assets/icons/timer-tick-3.svg
  SvgGenImage get timerTick3 =>
      const SvgGenImage('assets/icons/timer-tick-3.svg');

  /// File path: assets/icons/timer-tick-4.svg
  SvgGenImage get timerTick4 =>
      const SvgGenImage('assets/icons/timer-tick-4.svg');

  /// File path: assets/icons/timer-tick.svg
  SvgGenImage get timerTick => const SvgGenImage('assets/icons/timer-tick.svg');

  /// File path: assets/icons/verify.png
  AssetGenImage get verify => const AssetGenImage('assets/icons/verify.png');

  /// File path: assets/icons/winter.svg
  SvgGenImage get winter => const SvgGenImage('assets/icons/winter.svg');

  /// List of all assets
  List<dynamic> get values => [
        activityA,
        activity,
        autumn,
        boardTasksA,
        boardTasks,
        calendar,
        checkOut,
        chevronUpDown,
        circleClock,
        clockAddPlusA,
        clockAddPlus,
        clockAdd,
        clockClose,
        clockDash,
        combined,
        docs,
        info,
        pause,
        play,
        plus,
        ringing,
        spring,
        summer,
        tag,
        timerOffSleep,
        timerTick2,
        timerTick3,
        timerTick4,
        timerTick,
        verify,
        winter
      ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/logo.png
  AssetGenImage get logo => const AssetGenImage('assets/images/logo.png');

  /// List of all assets
  List<AssetGenImage> get values => [logo];
}

class $AssetsTranslationsGen {
  const $AssetsTranslationsGen();

  /// File path: assets/translations/en.json
  String get en => 'assets/translations/en.json';

  /// File path: assets/translations/fa.json
  String get fa => 'assets/translations/fa.json';

  /// List of all assets
  List<String> get values => [en, fa];
}

class Assets {
  Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsTranslationsGen translations = $AssetsTranslationsGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class SvgGenImage {
  const SvgGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  }) : _isVecFormat = false;

  const SvgGenImage.vec(
    this._assetName, {
    this.size,
    this.flavors = const {},
  }) : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = _svg.SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
      );
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter: colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
