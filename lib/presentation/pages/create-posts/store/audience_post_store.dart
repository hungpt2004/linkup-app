import 'package:mobx/mobx.dart';
import 'package:vdiary_internship/core/constants/gen/image_path.dart';

part 'audience_post_store.g.dart';

// ignore: library_private_types_in_public_api
class AudienceStore = _AudienceStore with _$AudienceStore;

abstract class _AudienceStore with Store {
  @observable
  String typeAudience = 'Public';

  @observable
  String typeAudienceIcon = ImagePath.earthIcon;

  @action
  void setTypeAudience(String type) => typeAudience = type;

  @action
  void setTypeAudienceIcon(String type) {
    if (type == 'Friends') {
      setTypeAudienceIconPath(ImagePath.friendOptionIcon);
    } else if (type == 'Private') {
      setTypeAudienceIconPath(ImagePath.lockDefaultIcon);
    } else {
      setTypeAudienceIconPath(ImagePath.earthIcon);
    }
  }

  @action
  void setTypeAudienceIconPath(String imagePath) {
    typeAudienceIcon = imagePath;
  }

  // Hàm xử lý chọn user
  // Nếu chọn trùng type thì xóa luôn
  @action
  void toggleChangeTypeAudience(String type) {
    setTypeAudience(type);
    setTypeAudienceIcon(type);
  }
}
