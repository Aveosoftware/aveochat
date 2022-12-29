library aveochat;

import 'dart:async';

import 'package:animations/animations.dart';
import 'package:aveochat/app/modules/chat_room/controllers/chat_room_controller.dart';
import 'package:aveochat/app/modules/chat_room/views/chat_room_view.dart';
import 'package:aveochat/core/image_viewer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';

import 'dart:developer';

import 'package:aveochat/app/modules/aveo_chat/widgets/chat_tile.dart';
import 'package:aveochat/app/modules/aveo_chat/widgets/no_chats.dart';
import 'package:aveochat/app/modules/aveo_chat/widgets/search_box.dart';
import 'package:aveochat/core/chat_shimmer.dart';

import 'app/modules/aveo_chat/controllers/aveo_chat_controller.dart';

part 'models/chat.dart';
part 'models/message.dart';
part 'models/user.dart';
part 'repository/chat_service_framework.dart';
part 'repository/firebase/firebase_chat_service_impl.dart';
part 'src/aveo_chat_config.dart';
part 'constants/constants.dart';
part 'app/modules/aveo_chat/views/aveo_chat_view.dart';
part 'app/modules/chat_room/widgets/message_tile.dart';
part 'core/theme_data.dart';
