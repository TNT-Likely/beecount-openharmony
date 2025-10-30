import 'package:flutter/material.dart';
import '../services/category_service.dart';
import '../data/db.dart';

/// 统一的分类名称到图标映射，供列表与分类选择共用，保证一致性
/// 现在使用CategoryService的智能推导功能
///
/// 已废弃：请使用 getCategoryIconData 函数代替
@Deprecated('Use getCategoryIconData instead')
IconData iconForCategory(String name) {
  return CategoryService.getCategoryIconByName(name);
}

/// 获取分类的图标数据
///
/// 优先使用分类对象中存储的icon字段,如果为空则根据分类名称智能推导
///
/// [category] 分类对象,可以为null(用于默认分类或虚拟分类)
/// [categoryName] 分类名称,当category为null时必须提供
///
/// 示例:
/// ```dart
/// // 使用分类对象(推荐)
/// final icon = getCategoryIconData(category: myCategory);
///
/// // 仅使用分类名称(回退方案)
/// final icon = getCategoryIconData(categoryName: '餐饮');
/// ```
IconData getCategoryIconData({Category? category, String? categoryName}) {
  // 优先使用分类对象的icon字段
  if (category != null && category.icon != null && category.icon!.isNotEmpty) {
    return CategoryService.getCategoryIcon(category.icon);
  }

  // 回退到名称推导
  final name = category?.name ?? categoryName;
  if (name == null || name.isEmpty) {
    return CategoryService.getCategoryIcon(null); // 返回默认图标
  }

  return CategoryService.getCategoryIconByName(name);
}
