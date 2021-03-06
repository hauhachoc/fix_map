import "package:fix_map/dao/dao.dart";
import "package:fix_map/models/models.dart";
import "package:fix_map/repositories/fix_map_client.dart";
import "package:fix_map/repositories/repostiories.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";

class ShopRepository extends SharedPreferencesRepository {
  final shopDao = ShopDao();

  Future<List<Shop>> getShops(LatLngBounds bounds) async {
    return await shopDao.searchShops(bounds: bounds);
  }

  Future<Shop> getShopBy(String hash) async {
    final ShopResponse shopResponse = await FixMapClient.getShop(hash);

    if (shopResponse.responseText != "Successfully") {
      throw Exception("Opps, has error!");
    }
    return shopResponse.shop;
  }

  Future<List<Shop>> downloadShops() async {
    final FixMapResponse fixMapResponse = await FixMapClient.getAllShop();

    if (fixMapResponse.responseText != "Successfully") {
      throw Exception("Opps, has error!");
    }

    return fixMapResponse.shops;
  }

  Future<List<Shop>> getAllRecord() async {
    final shops = await shopDao.getAllShop();
    if (shops.isNotEmpty) {
      return shops;
    }
    return [];
  }

  Future getAllShops({String query, int offset, int limit}) =>
      shopDao.getShops(query: query, offset: offset, limit: limit);

  Future<int> insertShop(Shop shop) => shopDao.createShop(shop);

  Future updateShop(Shop shop) => shopDao.updateShop(shop);
}
