import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:re_editor/re_editor.dart';

class ContextMenuItemWidget extends PopupMenuItem<void>
    implements PreferredSizeWidget {
  ContextMenuItemWidget({
    super.key,
    required String text,
    required VoidCallback super.onTap,
  }) : super(
          child: Text(text),
        );

  @override
  Size get preferredSize => const Size(150, 25);
}

class ContextMenuControllerImpl implements SelectionToolbarController {
  const ContextMenuControllerImpl();

  @override
  void hide(BuildContext context) {}

  @override
  void show({
    required BuildContext context,
    required CodeLineEditingController controller,
    required TextSelectionToolbarAnchors anchors,
    Rect? renderRect,
    required LayerLink layerLink,
    required ValueNotifier<bool> visibility,
  }) {
    OverlayEntry? menuOverlay;

    String selectedText = controller.selectedText;

    void removeMenu() {
      menuOverlay?.remove();
      menuOverlay = null;
    }

    menuOverlay = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // GestureDetector to detect taps outside the menu
          GestureDetector(
            onTap: removeMenu,
            behavior: HitTestBehavior.translucent,
            child: Container(
              color: Colors.transparent, // Invisible background
            ),
          ),
          Positioned(
            height: 40,
            child: CompositedTransformFollower(
              link: layerLink,
              showWhenUnlinked: false,
              offset: const Offset(0, 20), // Position menu below anchor
              child: Material(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Menu(
                  onItemSelected: (value) {
                    if (value == "Copy") {
                      if (selectedText.isNotEmpty) {
                        Clipboard.setData(ClipboardData(text: selectedText));
                      }
                    } else if (value == "Paste") {
                      controller.paste();
                    }
                    removeMenu();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(menuOverlay!);
  }
}

class Menu extends StatelessWidget {
  final void Function(String) onItemSelected;

  const Menu({Key? key, required this.onItemSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Copy button with splash effect
          InkWell(
            onTap: () => onItemSelected("Copy"),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: const Text("Copy"),
            ),
          ),
          // Paste button with splash effect
          InkWell(
            onTap: () => onItemSelected("Paste"),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: const Text("Paste"),
            ),
          ),
        ],
      ),
    );
  }
}
