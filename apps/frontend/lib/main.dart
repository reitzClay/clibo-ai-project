import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/clibo_ai/data/datasources/clibo_socket_provider.dart';
import 'features/clibo_ai/data/repositories/CliboRepositoryImpl.dart';
import 'features/clibo_ai/presentation/manager/clibo_cubit.dart';
import 'features/clibo_ai/presentation/pages/clibo_dashboard_page.dart';
import 'features/clibo_ai/presentation/widgets/samsung_surface_fixer.dart';
import 'core/theme/species_theme.dart';
 

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize the Single Source of Truth
  final socketProvider = CliboSocketProvider()..connect(); // Start connection
  final repository = CliboRepositoryImpl(socketProvider);
  final cliboCubit = CliboCubit(repository: repository)..startPulsing();

  runApp(CliboApp(cubit: cliboCubit));
}

@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Overlay entry point uses its own heartbeat
  final socketProvider = CliboSocketProvider()..connect();
  final repo = CliboRepositoryImpl(socketProvider);
  final cubit = CliboCubit(repository: repo)..startPulsing();
  
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(useMaterial3: true),
    // The Fixer ensures Samsung screens don't flicker during the overlay
    home: SamsungSurfaceFixer(cubit: cubit),
  ));
}

class CliboApp extends StatelessWidget {
  final CliboCubit cubit;
  const CliboApp({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit, // Use .value so it doesn't close the cubit we created in main
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(useMaterial3: true).copyWith(
          scaffoldBackgroundColor: const Color(0xFF0D0221),
        ),
        home: const CliboDashboardPage(),
      ),
    );
  }
}
