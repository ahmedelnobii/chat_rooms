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
import 'package:chat_rooms/features/auth/presentation/cubit/auth_cubit.dart'
    as _i124;
import 'package:chat_rooms/features/create_room/data/ceate_room_data_source/remote/create_room_fire_base_data_source.dart'
    as _i132;
import 'package:chat_rooms/features/create_room/data/ceate_room_data_source/remote/create_room_remote_data_source.dart'
    as _i104;
import 'package:chat_rooms/features/create_room/data/repo/create_room_repo.dart'
    as _i53;
import 'package:chat_rooms/features/create_room/data/repo/create_room_repo_impl.dart'
    as _i198;
import 'package:chat_rooms/features/create_room/presentation/cubit/create_room_cubit.dart'
    as _i623;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.singleton<_i104.CreateRoomRemoteDataSource>(
      () => _i132.CreateRoomFireBaseDataSource(),
    );
    gh.singleton<_i74.RemoteAuthDataSource>(
      () => _i1024.FireBaseAuthDataSource(),
    );
    gh.singleton<_i53.CreateRoomRepo>(
      () => _i198.CreateRoomRepoImpl(gh<_i104.CreateRoomRemoteDataSource>()),
    );
    gh.singleton<_i19.AuthRepo>(
      () => _i233.AuthRepoImpl(
        remoteAuthDataSource: gh<_i74.RemoteAuthDataSource>(),
      ),
    );
    gh.singleton<_i124.AuthCubit>(() => _i124.AuthCubit(gh<_i19.AuthRepo>()));
    gh.factory<_i623.CreateRoomCubit>(
      () => _i623.CreateRoomCubit(gh<_i53.CreateRoomRepo>()),
    );
    return this;
  }
}
