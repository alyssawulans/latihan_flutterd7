import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:latihan_flutterd7/day_36/models/login_response.dart';
import 'package:latihan_flutterd7/day_36/models/register_response.dart';
import 'package:latihan_flutterd7/day_36/models/profile_response.dart';
import 'package:latihan_flutterd7/day_36/models/edit_profile_response.dart';
import 'package:latihan_flutterd7/day_36/models/all_batches_model.dart';
import 'package:latihan_flutterd7/day_36/models/training_model.dart';

part 'auth_service.g.dart';

@RestApi(baseUrl: 'https://appabsensi.mobileprojp.com')
abstract class AuthService {
  factory AuthService(Dio dio, {String baseUrl}) = _AuthService;

  @POST('/api/register')
  Future<RegisterResponse> register(@Body() Map<String, dynamic> body);

  @POST('/api/login')
  Future<LoginResponse> login(@Body() Map<String, dynamic> body);

  @GET('/api/profile')
  Future<ProfileResponse> getProfile();

  @PUT('/api/profile')
  Future<EditProfileResponse> editProfile(@Body() Map<String, dynamic> body);

  @GET('/api/batches')
  Future<AllBatchesModel> getBatches();

  @GET('/api/trainings')
  Future<TrainingModel> getTrainings();
}
