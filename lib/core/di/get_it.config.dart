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
import 'package:chat_rooms/features/chat/data/chat_data_source/remote/chat_fire_store_data_source.dart'
    as _i703;
import 'package:chat_rooms/features/chat/data/chat_data_source/remote/chat_remote_data_source.dart'
    as _i700;
import 'package:chat_rooms/features/chat/data/repo/chat_repo.dart' as _i149;
import 'package:chat_rooms/features/chat/data/repo/chat_repo_impl.dart' as _i12;
import 'package:chat_rooms/features/chat/presentation/cubit/chat_cubit.dart'
    as _i137;
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
import 'package:chat_rooms/features/home/data/home_data_source/remote/home_fireStore_data_source.dart'
    as _i213;
import 'package:chat_rooms/features/home/data/home_data_source/remote/home_remote_data_source.dart'
    as _i430;
import 'package:chat_rooms/features/home/data/repo/home_repo.dart' as _i66;
import 'package:chat_rooms/features/home/data/repo/home_repo_impl.dart'
    as _i1057;
import 'package:chat_rooms/features/home/presentation/cubit/home_cubit.dart'
    as _i694;
import 'package:chat_rooms/features/home/presentation/cubit/room_password_cubit.dart'
    as _i799;
import 'package:chat_rooms/features/liked/data/liked_data_source/remote/liked_firestore_data_source.dart'
    as _i328;
import 'package:chat_rooms/features/liked/data/liked_data_source/remote/liked_remote_data_source.dart'
    as _i207;
import 'package:chat_rooms/features/liked/data/repo/liked_repo.dart' as _i954;
import 'package:chat_rooms/features/liked/data/repo/liked_repo_impl.dart'
    as _i585;
import 'package:chat_rooms/features/liked/presentation/cubit/liked_cubit.dart'
    as _i977;
import 'package:chat_rooms/features/profile/data/data_source/remote/profile_firestore_data_source.dart'
    as _i970;
import 'package:chat_rooms/features/profile/data/data_source/remote/profile_remote_data_source.dart'
    as _i824;
import 'package:chat_rooms/features/profile/data/repo/profile_repo.dart'
    as _i153;
import 'package:chat_rooms/features/profile/data/repo/profile_repo_impl.dart'
    as _i894;
import 'package:chat_rooms/features/profile/presentation/cubit/profile_cubit.dart'
    as _i106;
import 'package:chat_rooms/features/update_profile/data/data_source/remote/update_profile_firebase_data_source.dart'
    as _i107;
import 'package:chat_rooms/features/update_profile/data/data_source/remote/update_profile_remote_data_source.dart'
    as _i108;
import 'package:chat_rooms/features/update_profile/data/repo/update_profile_repo.dart'
    as _i109;
import 'package:chat_rooms/features/update_profile/data/repo/update_profile_repo_impl.dart'
    as _i110;
import 'package:chat_rooms/features/update_profile/presentation/cubit/update_profile_cubit.dart'
    as _i111;
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
    gh.singleton<_i430.HomeRemoteDataSource>(
      () => _i213.HomeFirestoreDataSource(),
    );
    gh.singleton<_i824.ProfileRemoteDataSource>(
      () => _i970.ProfileFirestoreDataSource(),
    );
    gh.singleton<_i66.HomeRepo>(
      () => _i1057.HomeRepoImpl(gh<_i430.HomeRemoteDataSource>()),
    );
    gh.singleton<_i74.RemoteAuthDataSource>(
      () => _i1024.FireBaseAuthDataSource(),
    );
    gh.singleton<_i700.ChatRemoteDataSource>(
      () => _i703.ChatFireStoreDataSource(),
    );
    gh.singleton<_i207.LikedRemoteDataSource>(
      () => _i328.LikedFirestoreDataSource(),
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
    gh.singleton<_i153.ProfileRepo>(
      () => _i894.ProfileRepoImpl(gh<_i824.ProfileRemoteDataSource>()),
    );
    gh.factory<_i106.ProfileCubit>(
      () => _i106.ProfileCubit(gh<_i153.ProfileRepo>()),
    );
    gh.singleton<_i108.UpdateProfileRemoteDataSource>(
      () => _i107.UpdateProfileFirebaseDataSource(),
    );
    gh.singleton<_i109.UpdateProfileRepo>(
      () => _i110.UpdateProfileRepoImpl(
        gh<_i108.UpdateProfileRemoteDataSource>(),
      ),
    );
    gh.factory<_i111.UpdateProfileCubit>(
      () => _i111.UpdateProfileCubit(gh<_i109.UpdateProfileRepo>()),
    );
    gh.singleton<_i954.LikedRepo>(
      () => _i585.LikedRepoImpl(gh<_i207.LikedRemoteDataSource>()),
    );
    gh.factory<_i623.CreateRoomCubit>(
      () => _i623.CreateRoomCubit(gh<_i53.CreateRoomRepo>()),
    );
    gh.singleton<_i149.ChatRepo>(
      () => _i12.ChatRepoImpl(gh<_i700.ChatRemoteDataSource>()),
    );
    gh.factory<_i694.HomeCubit>(() => _i694.HomeCubit(gh<_i66.HomeRepo>()));
    gh.factory<_i799.RoomPasswordCubit>(
      () => _i799.RoomPasswordCubit(gh<_i66.HomeRepo>()),
    );
    gh.factory<_i977.LikedCubit>(() => _i977.LikedCubit(gh<_i954.LikedRepo>()));
    gh.factory<_i137.ChatCubit>(() => _i137.ChatCubit(gh<_i149.ChatRepo>()));
    return this;
  }
}
