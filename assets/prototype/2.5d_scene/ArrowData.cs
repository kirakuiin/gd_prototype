using Godot;

namespace gd_prototype.assets.prototype.ai;

/// <summary>
/// 代表一个箭矢的数据
/// </summary>
[GlobalClass]
public partial class ArrowData : Resource
{
    /// <summary>
    /// 移动速率
    /// </summary>
    [Export]
    public float Speed = 200;

    /// <summary>
    /// 伤害值
    /// </summary>
    [Export]
    public float Damage = 10;
}