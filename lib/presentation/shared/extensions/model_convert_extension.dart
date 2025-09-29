import 'package:vdiary_internship/data/models/post/hashtag_model.dart';
import 'package:vdiary_internship/data/models/post/like_model.dart';
import 'package:vdiary_internship/data/models/post/link_model.dart';
import 'package:vdiary_internship/data/models/post/mention_model.dart';
import 'package:vdiary_internship/data/models/post/post_model.dart';
import 'package:vdiary_internship/data/models/user/user_model.dart';
import 'package:vdiary_internship/data/models/user/hive/user_model_hive.dart';
import 'package:vdiary_internship/data/models/message/chat_member_model.dart';
import 'package:vdiary_internship/data/models/message/chat_room_model.dart';
import 'package:vdiary_internship/data/models/message/message_model.dart';
import 'package:vdiary_internship/data/models/message/message_status_model.dart';
import 'package:vdiary_internship/data/models/post/hive/post_model_hive.dart';
import 'package:vdiary_internship/data/models/post/hive/hashtag_model_hive.dart';
import 'package:vdiary_internship/data/models/post/hive/like_model_hive.dart';
import 'package:vdiary_internship/data/models/post/hive/link_model_hive.dart';
import 'package:vdiary_internship/data/models/post/hive/mention_model_hive.dart';

extension UserRoleX on UserRole {
  UserRoleHive toUserRoleHive() {
    switch (this) {
      case UserRole.admin:
        return UserRoleHive.admin;
      case UserRole.user:
        return UserRoleHive.user;
    }
  }
}

extension UserRoleHiveX on UserRoleHive {
  UserRole toUserRole() {
    switch (this) {
      case UserRoleHive.admin:
        return UserRole.admin;
      case UserRoleHive.user:
        return UserRole.user;
    }
  }
}

// Extension cho UserModel → UserModelHive
extension UserModelX on UserModel {
  UserModelHive toUserModelHive() {
    return UserModelHive(
      id: id,
      email: email,
      name: name,
      verified: verified,
      role: role.toUserRoleHive(),
      avatarUrl: avatarUrl,
      numberFriends: numberFriends,
      coverImageUrl: coverImageUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

// Extension cho LinkModel → LinkModelHive
extension LinkModelX on LinkModel {
  LinkModelHive toLinkModelHive() {
    return LinkModelHive(
      url: url,
      title: title,
      description: description,
      image: image,
    );
  }
}

// Extension cho HashtagModel → HashtagModelHive
extension HashtagModelX on HashtagModel {
  HashtagModelHive toHashtagModelHive() {
    return HashtagModelHive(id: id, name: name);
  }
}

// Extension cho MentionModel → MentionModelHive
extension MentionModelX on MentionModel {
  MentionModelHive toMentionModelHive() {
    return MentionModelHive(id: id, name: name, email: email, avatar: avatar);
  }
}

// Extension cho LikeModel → LikeModelHive
extension LikeModelX on LikeModel {
  LikeModelHive toLikeModelHive() {
    return LikeModelHive(
      id: id,
      typeReact: typeReact,
      user: user.toUserModelHive(),
    );
  }
}

// Extension cho PostModel → PostModelHive
extension PostModelX on PostModel {
  PostModelHive toPostModelHive() {
    return PostModelHive(
      id: id,
      caption: caption,
      images: images,
      videos: videos,
      links: links.map((link) => link.toLinkModelHive()).toList(),
      author: author,
      hashtags:
          hashtags.map((hashtag) => hashtag.toHashtagModelHive()).toList(),
      mentions:
          mentions.map((mention) => mention.toMentionModelHive()).toList(),
      listUsers: listUsers.map((like) => like.toLikeModelHive()).toList(),
      likeCount: likeCount,
      privacy: privacy,
      comments: comments,
      user: user.toUserModelHive(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

// Extension cho ChatMember → ChatMemberModelHive
extension ChatMemberX on ChatMember {
  ChatMember toChatMemberModelHive() {
    return ChatMember(
      userId: userId,
      role: role,
      lastSeenMessageId: lastSeenMessageId,
      joinedAt: joinedAt,
    );
  }
}

// Extension cho MessageStatus → MessageStatusModelHive
extension MessageStatusX on MessageStatus {
  MessageStatus toMessageStatusModelHive() {
    return MessageStatus(deliveredTo: deliveredTo, readBy: readBy);
  }
}

// Extension cho Message → MessageModelHive
extension MessageX on Message {
  Message toMessageModelHive() {
    return Message(
      messageId: messageId,
      senderId: senderId,
      type: type,
      text: text,
      images: images,
      createdAt: createdAt,
      isDeleted: isDeleted,
      status: status.toMessageStatusModelHive(),
    );
  }
}

// Extension cho ChatRoom → ChatRoomModelHive
extension ChatRoomX on ChatRoom {
  ChatRoom toChatRoomModelHive() {
    return ChatRoom(
      roomId: roomId,
      type: type,
      name: name,
      avatarUrl: avatarUrl,
      members: members.map((member) => member.toChatMemberModelHive()).toList(),
      memberIds: memberIds,
      lastMessage: lastMessage,
      createdAt: createdAt,
      createdBy: createdBy,
    );
  }
}
