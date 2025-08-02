using Godot;
using Godot.Collections;

namespace gd_prototype.assets.components;

/// <summary>
/// 一个通用的输入配置。
/// 其内部包含了一个或多个 InputActionMapping 资源, 共同构成了一个通用的操作集。
/// </summary>
[GlobalClass]
public partial class InputSet : Resource
{
    /// <summary>
    /// 输入集的名称，用于标识和查找
    /// </summary>
    [Export]
    public string Name { get; set; } = "New Input Set";

    /// <summary>
    /// 输入集的描述信息
    /// </summary>
    [Export]
    public string Description { get; set; } = "";

    /// <summary>
    /// 该输入集包含的所有输入动作映射
    /// </summary>
    [Export]
    public Array<InputActionMapping> ActionMappings { get; set; } = [];
}