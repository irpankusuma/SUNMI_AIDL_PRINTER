import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class ReturnData {
  final String status;
  final String code;
  final String message;

  ReturnData({ this.code,this.message,this.status });

  factory ReturnData.fromJson(Map<String,dynamic> json) => new ReturnData(
    code: json['Code'],
    message: json['Message'],
    status: json['Status']
  );

  Map<String,dynamic> toJson() => {
    'Code': code,
    'Message': message,
    'Status': status
  };
}

class MenuService {
  final String name;
  final Icon icons;
  final VoidCallback onTap;

  MenuService({ this.name, this.icons, this.onTap });
}