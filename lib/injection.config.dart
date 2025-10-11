// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import 'src/features/feed/application/fetch_post_cubit/fetch_post_cubit.dart' as _i980;
import 'src/features/feed/domain/interface/i_feed_repository.dart' as _i775;
import 'src/features/feed/infrastructure/feed_repository.dart' as _i609;
import 'src/features/memories/application/create_memories_cubit/create_memories_cubit.dart' as _i332;
import 'src/features/memories/application/fetch_memories_cubit/fetch_memories_cubit.dart' as _i422;
import 'src/features/memories/domain/interface/i_memories_repository.dart' as _i378;
import 'src/features/memories/infrastructure/memories_repository.dart' as _i160;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({String? environment, _i526.EnvironmentFilter? environmentFilter}) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i378.IMemoriesRepository>(() => _i160.MemoriesRepository(_i609.FeedRepository()));
    gh.lazySingleton<_i775.IFeedRepository>(() => _i609.FeedRepository());
    gh.factory<_i332.CreateMemoriesCubit>(() => _i332.CreateMemoriesCubit(gh<_i378.IMemoriesRepository>()));
    gh.factory<_i422.FetchMemoriesCubit>(() => _i422.FetchMemoriesCubit(gh<_i378.IMemoriesRepository>()));
    gh.factory<_i980.FetchPostCubit>(() => _i980.FetchPostCubit(gh<_i775.IFeedRepository>()));
    return this;
  }
}
