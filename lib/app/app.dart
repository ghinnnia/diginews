import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diginews_offline_first/core/di/injection_container.dart';
import 'package:diginews_offline_first/core/network/network_info.dart';
import 'package:diginews_offline_first/core/router/app_router.dart';
import 'package:diginews_offline_first/core/theme/app_theme.dart';
import 'package:diginews_offline_first/features/news/domain/usecases/get_news_usecase.dart';
import 'package:diginews_offline_first/features/news/domain/usecases/search_news_usecase.dart';
import 'package:diginews_offline_first/features/news/presentation/bloc/news_bloc.dart';
import 'package:diginews_offline_first/features/realtime/presentation/cubit/realtime_cubit.dart';

class DigiNewsApp extends StatelessWidget {
  const DigiNewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NewsBloc>(
          create: (_) => NewsBloc(
            getNewsUseCase: sl<GetNewsUseCase>(),
            searchNewsUseCase: sl<SearchNewsUseCase>(),
            networkInfo: sl<NetworkInfo>(),
          ),
        ),
        BlocProvider<RealtimeCubit>(
          create: (_) => sl<RealtimeCubit>()..startListening(),
        ),
      ],
      child: MaterialApp.router(
        title: 'DigiNews',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.themeData,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
