import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class CliboDrawer extends StatelessWidget {
  const CliboDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0D0221), // Matching project background
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple.shade900, Colors.black],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: const Border(
                bottom: BorderSide(color: Colors.cyanAccent, width: 0.5),
              ),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.auto_awesome, color: Colors.cyanAccent, size: 40),
                  SizedBox(height: 10),
                  Text(
                    "CLIBO CONFIG",
                    style: TextStyle(
                      color: Colors.white, 
                      letterSpacing: 4, 
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // SUMMON LOGIC: With Permission Guard & Focus Pointer
          ListTile(
            leading: const Icon(Icons.bolt, color: Colors.cyanAccent),
            title: const Text("SUMMON CLIBO", style: TextStyle(color: Colors.white, letterSpacing: 1.5)),
            subtitle: const Text("Wake the Vagus Nerve Overlay", style: TextStyle(color: Colors.white38, fontSize: 10)),
            onTap: () async {
              // 1. Check for Android 'Display over other apps' permission
              final bool isGranted = await FlutterOverlayWindow.isPermissionGranted();
              
              if (!isGranted) {
                // Triggers the system settings page for the user
                await FlutterOverlayWindow.requestPermission();
                return; 
              }

              // 2. Prevent duplicate overlays
              if (await FlutterOverlayWindow.isActive()) {
                await FlutterOverlayWindow.closeOverlay(); // Toggle off if already active
                if (context.mounted) Navigator.pop(context);
                return;
              }

              // 3. Launch the Pip-Boy
              await FlutterOverlayWindow.showOverlay(
                enableDrag: true,
                flag: OverlayFlag.focusPointer, // Allows interaction with Ghost/Controls
                alignment: OverlayAlignment.center,
                visibility: NotificationVisibility.visibilityPublic,
                height: WindowSize.matchParent,
                width: WindowSize.matchParent,
              );
              
              if (context.mounted) Navigator.pop(context);
            },
          ),
          
          const Divider(color: Colors.white10),
          
          ListTile(
            leading: const Icon(Icons.timeline, color: Colors.white38),
            title: const Text("DREAM MAPPING", style: TextStyle(color: Colors.white70)),
            onTap: () => Navigator.pop(context),
          ),
          
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.white38),
            title: const Text("ISOLATE SETTINGS", style: TextStyle(color: Colors.white70)),
            onTap: () => Navigator.pop(context),
          ),
          
          const Spacer(),
          
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "CLIBO v1.1.0-SNAPSHOT",
              style: TextStyle(color: Colors.white12, fontSize: 8, letterSpacing: 2),
            ),
          ),
        ],
      ),
    );
  }
}
