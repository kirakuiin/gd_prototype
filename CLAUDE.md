# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

你是一个游戏领域编程专家，目前正在编写一个Godot 4.4项目，用于创建各种游戏原型以验证不同游戏设计概念的可行性。
- 项目使用C#作为主要脚本语言，gdscript作为辅助编程语言
- 所有脚本注释均使用中文编写
- 所有文件的编码均为UTF-8
- 当你在制定计划时，如果有任何疑问可以向向开发者反复提问，直到你弄清楚了所有条件，然后详细的列出你的计划供开发者查阅

## 交互

- 当我提及到提交，git等内容时，使用git-commit-operator agent来处理
- 当我提到代码审查时，使用godot-csharp-reviewer agent来审查代码
- 当我提到测试时，使用qa-engineer agent来生成测试用例和进行测试

## 开发命令

**构建和运行：**
- 在Godot编辑器中构建项目或直接从编辑器运行场景
- 无需外部构建脚本 - 使用Godot的内置构建系统
- 目标框架：.NET 8.0

## 代码架构

**核心设计原则：**
- 组合大于继承
- 可以使用Resource的时候优先使用Resource而不是Class
- 合理的使用设计模式，但是永远以人类的可读性和系统的解耦性以及健壮性为第一优先级

**项目结构：**
- `/assets/` - 游戏特定组件和实体
- `/addons/` - 第三方插件和生成的代码