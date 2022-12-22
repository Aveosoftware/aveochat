library aveochat;

import 'dart:async';

import 'package:aveochat/app/modules/chat_room/views/chat_room_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';

import 'dart:developer';

import 'package:aveochat/app/modules/aveo_chat/widgets/chat_tile.dart';
import 'package:aveochat/app/modules/aveo_chat/widgets/no_chats.dart';
import 'package:aveochat/app/modules/aveo_chat/widgets/search_box.dart';
import 'package:aveochat/src/widgets/chat_shimmer.dart';

import 'app/modules/aveo_chat/controllers/aveo_chat_controller.dart';

part 'models/chat.dart';
part 'models/message.dart';
part 'models/user.dart';
part 'repository/chat_service_framework.dart';
part 'repository/firebase/firebase_chat_service_impl.dart';
part 'src/aveo_chat_config.dart';
part 'src/constants.dart';
part 'app/modules/aveo_chat/views/aveo_chat_view.dart';
part 'src/widgets/aveo_chat_tile.dart';
part 'src/widgets/chat_room.dart';
part 'src/widgets/message_tile.dart';
part 'src/widgets/theme_data.dart';
