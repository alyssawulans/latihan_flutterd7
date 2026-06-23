import 'package:dio/dio.dart';
import 'package:latihan_flutterd7/day_34/models/rickmorty_models.dart';
import 'package:retrofit/retrofit.dart';

part 'api_rickmorty_services.g.dart';

@RestApi(baseUrl: 'https://rickandmortyapi.com/api')
abstract class ApiRickmortyService {
  factory ApiRickmortyService(Dio dio, {String baseUrl}) = _ApiRickmortyService;

  @GET('/character')
  Future<RickmortyModels> getCharacters({
    @Query("name") String? name,
    @Query("status") String? status,
    @Query("species") String? species,
    @Query("page") int? page,
  });
}
