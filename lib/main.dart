import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:solana_beach/config/theme/app_theme.dart';
import 'package:solana_beach/core/injection/dependency_injection.dart';
import 'package:solana_beach/features/dashboard/presentation/blocs/app_bloc/app_bloc.dart';
import 'package:solana_beach/features/dashboard/presentation/blocs/block_bloc/block_bloc.dart';
import 'package:solana_beach/features/dashboard/presentation/blocs/block_list_bloc/block_list_bloc.dart';
import 'package:solana_beach/features/dashboard/presentation/screens/block_list_screen.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  DependencyInjection.injectDependencies();
  runApp(const SolanaBeach());
}

class SolanaBeach extends StatelessWidget {
  const SolanaBeach({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => BlockListBloc()..add(const GetLatestBlocksEvent()),
        ),
        BlocProvider(create: (context) => BlockBloc()),
        BlocProvider(create: (context) => AppBloc()),
      ],
      child: MaterialApp(
        home: BlocListener<AppBloc, AppState>(
          listener: (context, state) {
            if (state.connectivityResult.contains(ConnectivityResult.none)) {
              ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  content: const Row(
                    children: [
                      Icon(Icons.wifi_off, color: Colors.white),
                      SizedBox(width: 10),
                      Text("There is no internet connection"),
                    ],
                  ),
                  backgroundColor: Colors.redAccent,
                  duration: const Duration(days: 365),
                  dismissDirection: DismissDirection.none,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            }
          },
          child: const BlockListScreen(),
        ),
        themeMode: ThemeMode.dark,
        darkTheme: AppTheme.dark,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
