# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

这是一个Godot 4.4项目，用于创建各种游戏原型以验证不同游戏设计概念的可行性。项目使用C#作为主要脚本语言，所有脚本注释均使用中文编写。

## 开发命令

**构建和运行：**
- 在Godot编辑器中构建项目或直接从编辑器运行场景
- 无需外部构建脚本 - 使用Godot的内置构建系统
- 目标框架：.NET 8.0

**开发设置：**
- 在Godot 4.4编辑器中打开项目
- 主场景位于project.godot中指定的路径（uid://cp7nj2eqqyw1j）
- 已启用的插件：action_enum_generator, godot_resource_groups, phantom_camera, resources_spreadsheet_view

**提交设置：**
- 使用约定式提交，提交前简洁的总结此次的修改

## 代码架构

**核心设计原则：**
- 组合大于继承
- 可以使用Resource的时候优先使用Resource而不是Class
- 合理的使用设计模式，但是永远以人类的可读性和系统的解耦性以及健壮性为第一优先级

**实现示例：**
Dog类（assets/dog/Dog.cs:9）展示了该模式：
- 继承CharacterBody2D
- 使用InputComponent处理输入
- 订阅OnInputTriggered事件
- 处理移动和动画状态

**项目结构：**
- `/assets/` - 游戏特定组件和实体
- `/addons/` - 第三方插件和生成的代码
- 主要输入动作定义在project.godot中：up, down, left, right, find, sit

**关键模式：**
- 使用事件进行组件通信（OnInputTriggered）
- 使用资源进行配置（InputActionMapping）
- 在_ExitTree()方法中正确清理
- 代码库中全部使用中文注释