import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/clibo_ai/data/datasources/clibo_socket_provider.dart';
import 'features/clibo_ai/data/repositories/CliboRepositoryImpl.dart';
import 'features/clibo_ai/presentation/manager/clibo_cubit.dart';
import 'features/clibo_ai/presentation/pages/clibo_dashboard_page.dart';
import 'features/clibo_ai/presentation/widgets/samsung_surface_fixer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CliboApp());
}

@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  final repo = CliboRepositoryImpl(CliboSocketProvider());
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SamsungSurfaceFixer(cubit: CliboCubit(repository: repo)),
  ));
}

class CliboApp extends StatelessWidget {
  const CliboApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CliboCubit(repository: CliboRepositoryImpl(CliboSocketProvider())),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(useMaterial3: true).copyWith(
          scaffoldBackgroundColor: const Color(0xFF0D0221),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark, secondary: Colors.cyanAccent),
        ),
        home: const CliboDashboardPage(),
      ),
    );
  }
}
