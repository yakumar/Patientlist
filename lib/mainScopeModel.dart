
import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import 'hospScoped.dart';
import 'userScoped.dart';
import 'connectedScopeModel.dart';

class MainModel extends Model with UserModel, Hospital, ConnectedScopeModel{}
