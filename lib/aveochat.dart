library aveochat;

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:melos_chat/src/widgets/chat_room.dart';
import 'package:melos_chat/src/widgets/chat_shimmer.dart';
import 'package:readmore/readmore.dart';

part 'src/chat_configs.dart';
part 'src/config.dart';
part 'src/firebase_repo/firebase_chat_service.dart';
part 'src/firebase_repo/firebase_chat_service_impl.dart';
part 'src/models/chat.dart';
part 'src/models/message.dart';
part 'src/models/user.dart';
part 'src/widgets/aveo_chat.dart';
part 'src/widgets/aveo_chat_tile.dart';
part 'src/widgets/message_tile.dart';
part 'src/widgets/search_box.dart';
part 'src/widgets/theme_data.dart';
