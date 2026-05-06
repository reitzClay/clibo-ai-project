import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../manager/clibo_cubit.dart';
import '../pages/clibo_overlay_page.dart';

class SamsungSurfaceFixer extends StatefulWidget {
  final CliboCubit cubit;
  const SamsungSurfaceFixer({super.key, required this.cubit});

  @override
  State<SamsungSurfaceFixer> createState() => _SamsungSurfaceFixerState();
}

class _SamsungSurfaceFixerState extends State<SamsungSurfaceFixer> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => _ready = true);
        widget.cubit.startPulsing();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) return const Scaffold(backgroundColor: Colors.black);
    return RepaintBoundary(
      child: BlocProvider.value(value: widget.cubit, child: const CliboOverlayPage()),
    );
  }
}
