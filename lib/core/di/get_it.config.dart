// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:chat_rooms/features/auth/data/data_source/remote/fire_base_auth_data_source.dart'
    as _i1024;
import 'package:chat_rooms/features/auth/data/data_source/remote/remote_auth_data_source.dart'
    as _i74;
import 'package:chat_rooms/features/auth/data/repo/auth_repo.dart' as _i19;
import 'package:chat_rooms/features/auth/data/repo/auth_repo_impl.dart'
    as _i233;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.singleton<_i74.RemoteAuthDataSource>(
      () => _i1024.FireBaseAuthDataSource(),
    );
    gh.singleton<_i19.AuthRepo>(
      () => _i233.AuthRepoImpl(
        remoteAuthDataSource: gh<_i74.RemoteAuthDataSource>(),
      ),
    );
    return this;
  }
}
