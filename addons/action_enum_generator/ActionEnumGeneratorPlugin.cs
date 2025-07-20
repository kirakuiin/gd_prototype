using Godot;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

#if TOOLS

[Tool]
public partial class ActionEnumGeneratorPlugin : EditorPlugin
{
    private const string SetOutputPath = "addons/InputActions.cs";

    private Button _generateButton;

    public override void _EnterTree()
    {
        _generateButton = new Button();
        _generateButton.Text = "Generate Input Actions";
        _generateButton.TooltipText = "从项目输入映射生成 InputActions.cs。";
        _generateButton.Pressed += OnGenerateButtonPressed;

        AddControlToContainer(CustomControlContainer.Toolbar, _generateButton);
    }

    public override void _ExitTree()
    {
        if (_generateButton != null)
        {
            RemoveControlFromContainer(CustomControlContainer.Toolbar, _generateButton);
            _generateButton.QueueFree();
        }
    }

    private void OnGenerateButtonPressed()
    {
        GD.Print("开始生成输入动作静态类...");

        var generator = new InputMapGenerator();
        generator.Generate(SetOutputPath);

        GD.Print($"成功生成! 文件已保存到: {SetOutputPath}");
        GD.Print("重要提示: 请点击编辑器右上角的 'Build' 按钮来重新编译 C# 项目，以使更改生效。");
    }
}

#endif