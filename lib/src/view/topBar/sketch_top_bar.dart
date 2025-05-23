import 'package:flutter/material.dart';
import 'package:sketch_flow/sketch_view_model.dart';
import 'package:sketch_flow/sketch_view.dart';

class SketchTopBar extends StatelessWidget implements PreferredSizeWidget {
  /// Top bar widget
  ///
  /// [topBarHeight] The height of the top bar
  ///
  /// [topBarColor] The background color of the top bar
  ///
  /// [topBarBorderColor] The border color of the top bar
  ///
  /// [topBarBorderWidth] he border width of the top bar
  ///
  /// [backButtonIcon] The icon for the back button
  ///
  /// [onClickBackButton] Callback function invoked when the back button
  ///
  /// [undoIcon] Undo icon (see [SketchToolIcon])
  ///
  /// [redoIcon] Redo icon (see [SketchToolIcon])
  ///
  /// [exportSVGIcon] Export SVG Icon
  ///
  /// [exportPNGIcon] Export PNG Icon
  ///
  /// [exportJSONIcon] Export JSON Icon
  ///
  /// [exportTestDataIcon] Export test data Icon
  ///
  /// [showJsonDialogIcon] JSON dialog view settings (default false)
  ///
  /// [onClickToJsonButton] Callback function invoked when the json button
  ///
  /// [showInputTestDataIcon] Input Test Data view settings (default false)
  ///
  /// [onClickInputTestButton] Callback function invoked when test input button
  const SketchTopBar({
    super.key,
    required this.viewModel,
    this.topBarHeight,
    this.topBarColor = Colors.white,
    this.topBarBorderColor = Colors.grey,
    this.topBarBorderWidth,
    this.backButtonIcon,
    this.onClickBackButton,
    this.undoIcon,
    this.redoIcon,
    this.exportSVGIcon,
    this.exportPNGIcon,
    this.exportJSONIcon,
    this.exportTestDataIcon,
    this.showJsonDialogIcon,
    this.onClickToJsonButton,
    this.showInputTestDataIcon,
    this.onClickInputTestButton,
    this.onClickExtractPNG,
    this.onClickExtractSVG
  });
  final SketchViewModel viewModel;

  final double? topBarHeight;
  final Color topBarColor;
  final Color topBarBorderColor;
  final double? topBarBorderWidth;

  final Widget? backButtonIcon;
  final Function()? onClickBackButton;

  final SketchToolIcon? undoIcon;

  final SketchToolIcon? redoIcon;

  final Widget? exportSVGIcon;
  final Widget? exportPNGIcon;
  final Widget? exportJSONIcon;
  final Widget? exportTestDataIcon;

  final bool? showJsonDialogIcon;
  final Function()? onClickToJsonButton;

  final bool? showInputTestDataIcon;
  final Function()? onClickInputTestButton;

  final Function()? onClickExtractPNG;

  final Function(List<Offset>)? onClickExtractSVG;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            decoration: BoxDecoration(
                color: topBarColor,
                border: Border(
                    bottom: BorderSide(
                        color: topBarBorderColor,
                        width: topBarBorderWidth ?? 0.5
                    )
                )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    icon: backButtonIcon ?? Icon(Icons.arrow_back_ios, color: Colors.black,),
                    onPressed: onClickBackButton,
                ),
                Row(
                  children: [
                    /// Undo Icon button
                    ValueListenableBuilder<bool>(
                        valueListenable: viewModel.canUndoNotifier,
                        builder: (context, canUndo, _) {
                          return IconButton(
                              icon: canUndo
                                  ? (undoIcon?.enableIcon ?? Icon(Icons.undo_rounded))
                                  : (undoIcon?.disableIcon ?? Icon(Icons.undo_rounded)),
                              onPressed: canUndo ? () {
                                viewModel.undo();
                              } : null
                          );
                        }
                    ),

                    /// Redo Icon button
                    ValueListenableBuilder<bool>(
                        valueListenable: viewModel.canRedoNotifier,
                        builder: (context, canRedo, _) {
                          return IconButton(
                              icon: canRedo
                                  ? (redoIcon?.enableIcon ?? Icon(Icons.redo_rounded))
                                  : (redoIcon?.disableIcon ?? Icon(Icons.redo_rounded)),
                              onPressed: canRedo ? () {
                                viewModel.redo();
                              } : null
                          );
                        }
                    ),

                    IconButton(
                        onPressed: () {
                          if(onClickExtractSVG != null) {
                            List<Offset> offsets = [];

                            for (final content in viewModel.contents) {
                              offsets.addAll(content.offsets);
                            }

                            onClickExtractSVG!(offsets);
                          }
                        },
                        icon: exportSVGIcon ?? Icon(Icons.file_open_outlined)
                    ),

                    IconButton(
                        onPressed: () {
                          if(onClickExtractPNG != null) {
                            onClickExtractPNG!();
                          }
                        },
                        icon: exportPNGIcon ?? Icon(Icons.image)
                    ),

                    /// Button for JSON data debugging
                    if(showJsonDialogIcon ?? false)
                      IconButton(
                        icon: exportJSONIcon ?? Icon(Icons.javascript),
                        onPressed: () {
                          if(onClickToJsonButton != null) {
                            onClickToJsonButton!();
                          }
                        }
                      ),

                    if(showInputTestDataIcon ?? false)
                      IconButton(
                          icon: exportTestDataIcon ?? Icon(Icons.input),
                          onPressed: ()  {
                            if (onClickInputTestButton != null) {
                              onClickInputTestButton!();
                            }
                          },
                      ),
                  ],
                ),

              ],
            )
        )
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(topBarHeight ?? kToolbarHeight);
}