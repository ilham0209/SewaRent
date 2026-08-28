import '../features/auth/data/repositories/auth_repository.dart';
import '../features/favourite/data/repositories/favourite_repository.dart';
import '../features/profile/data/repositories/profile_repository.dart';
import '../features/property/data/repositories/property_repository.dart';
import '../features/rental_request/data/repositories/rental_request_repository.dart';
import 'network/api_client.dart';
import 'storage/token_storage.dart';

class AppServices {
  AppServices._();

  static final tokenStorage = TokenStorage();
  static final apiClient = ApiClient(tokenStorage: tokenStorage);

  static final authRepository = AuthRepository(apiClient: apiClient);
  static final propertyRepository = PropertyRepository(apiClient: apiClient);
  static final favouriteRepository = FavouriteRepository(apiClient: apiClient);
  static final rentalRequestRepository = RentalRequestRepository(
    apiClient: apiClient,
  );
  static final profileRepository = ProfileRepository(apiClient: apiClient);
}
