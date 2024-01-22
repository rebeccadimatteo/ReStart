import '../../../entity/ads_DTO.dart';

/// Questa classe rappresenta il DAO del ADS

abstract class AdsDAO {

  Future<bool> add(AdsDTO a);
  Future<bool> existById(int id);
  Future<bool> existByUsername(String username);
  Future<List<AdsDTO>> findAll();
  Future<AdsDTO?> findById(int id);
  Future<AdsDTO?> findByUsername(String username);
  Future<bool> removeById(int id);
  Future<bool> removeByUsername(String username);
  Future<bool> update(AdsDTO a);
}