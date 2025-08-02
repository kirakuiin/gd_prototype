using Godot;

namespace gd_prototype.assets.components;

/// <summary>
/// 该资源定义了 Godot 输入动作与响应（如调用方法或发射信号）之间的映射关系。
/// </summary>
[GlobalClass]
public partial class InputActionMapping : Resource
{
    /// <summary>
    /// 定义输入动作的触发方式。
    /// </summary>
    public enum EInputType
    {
        Pressed,  // 对应 Input.IsActionJustPressed，按下时触发一次
        Released, // 对应 Input.IsActionJustReleased，释放时触发一次
        Held,     // 对应 Input.IsActionPressed，按住时持续触发
        Analog    // 对应模拟输入，如手柄摇杆，持续提供 Vector2 值
    }

    // --- 布尔类型输入 (Pressed, Released, Held, Analog) --- 
    [Export]
    public EInputType InputType { get; set; } = EInputType.Pressed;

    [Export]
    public string ActionName { get; set; } = "";

    // --- 模拟类型输入 (Analog) --- 
    [ExportGroup("模拟/摇杆输入设置")]
    [Export]
    public string AnalogNegativeX { get; set; } = ""; // 例如 "move_left"
    [Export]
    public string AnalogPositiveX { get; set; } = ""; // 例如 "move_right"
    [Export]
    public string AnalogNegativeY { get; set; } = ""; // 例如 "move_up"
    [Export]
    public string AnalogPositiveY { get; set; } = ""; // 例如 "move_down"
}