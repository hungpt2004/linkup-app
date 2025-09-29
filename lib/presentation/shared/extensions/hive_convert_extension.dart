// Extension cho UserModelHive → UserModel
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

extension UserModelHiveX on UserModelHive {
  UserModel toUserModel() {
    return UserModel(
      id: id,
      email: email,
      name: name,
      verified: verified,
      role: role.toUserRole(),
      avatarUrl: avatarUrl,
      numberFriends: numberFriends,
      coverImageUrl: coverImageUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

// Extension cho LinkModelHive → LinkModel
extension LinkModelHiveX on LinkModelHive {
  LinkModel toLinkModel() {
    return LinkModel(
      url: url,
      title: title,
      description: description,
      image: image,
    );
  }
}

// Extension cho HashtagModelHive → HashtagModel
extension HashtagModelHiveX on HashtagModelHive {
  HashtagModel toHashtagModel() {
    return HashtagModel(id: id, name: name);
  }
}

// Extension cho MentionModelHive → MentionModel
extension MentionModelHiveX on MentionModelHive {
  MentionModel toMentionModel() {
    return MentionModel(id: id, name: name, email: email, avatar: avatar);
  }
}

// Extension cho LikeModelHive → LikeModel
extension LikeModelHiveX on LikeModelHive {
  LikeModel toLikeModel() {
    return LikeModel(id: id, typeReact: typeReact, user: user.toUserModel());
  }
}

// Extension cho PostModelHive → PostModel
extension PostModelHiveX on PostModelHive {
  PostModel toPostModel() {
    return PostModel(
      id: id,
      caption: caption,
      images: images,
      videos: videos,
      links: links.map((link) => link.toLinkModel()).toList(),
      author: author,
      hashtags: hashtags.map((hashtag) => hashtag.toHashtagModel()).toList(),
      mentions: mentions.map((mention) => mention.toMentionModel()).toList(),
      listUsers: listUsers.map((like) => like.toLikeModel()).toList(),
      likeCount: likeCount,
      privacy: privacy,
      comments: comments,
      user: user.toUserModel(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

// Extension cho ChatMemberModelHive → ChatMember
extension ChatMemberModelHiveX on ChatMember {
  ChatMember toChatMember() {
    return ChatMember(
      userId: userId,
      role: role,
      lastSeenMessageId: lastSeenMessageId,
      joinedAt: joinedAt,
    );
  }
}

// Extension cho MessageStatusModelHive → MessageStatus
extension MessageStatusModelHiveX on MessageStatus {
  MessageStatus toMessageStatus() {
    return MessageStatus(deliveredTo: deliveredTo, readBy: readBy);
  }
}

// Extension cho MessageModelHive → Message
extension MessageModelHiveX on Message {
  Message toMessage() {
    return Message(
      messageId: messageId,
      senderId: senderId,
      type: type,
      text: text,
      images: images,
      createdAt: createdAt,
      isDeleted: isDeleted,
      status: status.toMessageStatus(),
    );
  }
}

// Extension cho ChatRoomModelHive → ChatRoom
extension ChatRoomModelHiveX on ChatRoom {
  ChatRoom toChatRoom() {
    return ChatRoom(
      roomId: roomId,
      type: type,
      name: name,
      avatarUrl: avatarUrl,
      members: members.map((member) => member.toChatMember()).toList(),
      memberIds: memberIds,
      lastMessage: lastMessage,
      createdAt: createdAt,
      createdBy: createdBy,
    );
  }
}
