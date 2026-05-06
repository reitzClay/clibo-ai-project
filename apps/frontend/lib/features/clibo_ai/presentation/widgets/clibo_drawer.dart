import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class CliboDrawer extends StatelessWidget {
  const CliboDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple.shade900, Colors.black],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.auto_awesome, color: Colors.deepPurpleAccent, size: 40),
                  SizedBox(height: 10),
                  Text(
                    "CLIBO CONFIG",
                    style: TextStyle(color: Colors.white, letterSpacing: 1.2),
                  ),
                ],
              ),
            ),
          ),
          // Moved Summon Logic here to free up Main Screen real estate
          ListTile(
            leading: const Icon(Icons.bolt, color: Colors.amber),
            title: const Text("Summon Clibo"),
            subtitle: const Text("Wake the AI Overlay"),
            onTap: () async {
              if (await FlutterOverlayWindow.isActive()) return;
              await FlutterOverlayWindow.showOverlay(
                enableDrag: true,
                flag: OverlayFlag.defaultFlag,
                alignment: OverlayAlignment.center,
                visibility: NotificationVisibility.visibilityPublic,
                height: WindowSize.matchParent,
                width: WindowSize.matchParent,
              );
              if (context.mounted) Navigator.pop(context); // Close drawer after summon
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.timeline),
            title: const Text("Dream Mapping"),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Isolate Settings"),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
