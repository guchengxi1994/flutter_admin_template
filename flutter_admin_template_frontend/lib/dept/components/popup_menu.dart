import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:ui' as ui;

enum PopupItem { addSubItem, insertAbove, insertBelow, clear, modify, details }

class TabllePopupMenu extends StatelessWidget {
  const TabllePopupMenu(
      {super.key,
      required this.isRoot,
      this.onAddSubDept,
      this.onClear,
      this.onDetails,
      this.onInsertAbove,
      this.onInsertBelow,
      this.onModify});
  final bool isRoot;
  final VoidCallback? onAddSubDept;
  final VoidCallback? onModify;
  final VoidCallback? onInsertAbove;
  final VoidCallback? onInsertBelow;
  final VoidCallback? onClear;
  final VoidCallback? onDetails;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<PopupItem>(
        onSelected: (value) {
          switch (value) {
            /// Duplicated
            ///
            /// better be deleted
            case PopupItem.addSubItem:
              {
                if (onAddSubDept != null) {
                  onAddSubDept!();
                }
              }
            case PopupItem.clear:
              {
                if (onClear != null) {
                  onClear!();
                }
              }

            case PopupItem.details:
              {
                if (onDetails != null) {
                  onDetails!();
                }
              }
            case PopupItem.insertAbove:
              {
                if (onInsertAbove != null) {
                  onInsertAbove!();
                }
              }
            case PopupItem.insertBelow:
              {
                if (onInsertBelow != null) {
                  onInsertBelow!();
                }
              }

            /// Duplicated
            ///
            /// better be deleted
            case PopupItem.modify:
              {
                if (onModify != null) {
                  onModify!();
                }
              }
            default:
              break;
          }
        },
        itemBuilder: (ctx) => [
              /*
            Duplicated
            Better be deleted

               const PopupMenuItem<PopupItem>(
                value: PopupItem.addSubItem,
                child: FittedBox(
                  child: Row(
                    children: [
                      Icon(Icons.add_circle, color: Colors.green),
                      Text("Add Sub Dept",
                          style: TextStyle(color: Colors.green))
                    ],
                  ),
                ),
              ),
              const PopupMenuItem<PopupItem>(
                value: PopupItem.modify,
                child: FittedBox(
                  child: Row(
                    children: [
                      Icon(Icons.change_circle, color: Colors.green),
                      Text("Modify", style: TextStyle(color: Colors.green))
                    ],
                  ),
                ),
              ),
          */

              const PopupMenuItem<PopupItem>(
                value: PopupItem.details,
                child: FittedBox(
                  child: Row(
                    children: [
                      Icon(Icons.info, color: Colors.green),
                      Text("Details", style: TextStyle(color: Colors.green))
                    ],
                  ),
                ),
              ),
              if (!isRoot)
                PopupMenuItem<PopupItem>(
                  value: PopupItem.insertAbove,
                  child: FittedBox(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: SvgPicture.asset(
                            "assets/icons/ainsert.svg",
                            // theme: const SvgTheme(currentColor: Colors.green),
                            colorFilter: const ColorFilter.mode(
                                Colors.green, ui.BlendMode.srcIn),
                          ),
                        ),
                        const Text("Insert Above",
                            style: TextStyle(color: Colors.green))
                      ],
                    ),
                  ),
                ),
              if (!isRoot)
                PopupMenuItem<PopupItem>(
                    value: PopupItem.insertBelow,
                    // child: Text('Insert Above'),
                    child: FittedBox(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: SvgPicture.asset(
                              "assets/icons/binsert.svg",
                              // theme: const SvgTheme(currentColor: Colors.green),
                              colorFilter: const ColorFilter.mode(
                                  Colors.green, ui.BlendMode.srcIn),
                            ),
                          ),
                          const Text("Insert Below",
                              style: TextStyle(color: Colors.green))
                        ],
                      ),
                    )),
              if (!isRoot)
                const PopupMenuItem<PopupItem>(
                  value: PopupItem.clear,
                  child: FittedBox(
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        Text("Delete", style: TextStyle(color: Colors.red))
                      ],
                    ),
                  ),
                ),
            ]);
  }
}
