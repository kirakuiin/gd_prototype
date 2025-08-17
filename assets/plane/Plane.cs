using Godot;
using gd_prototype.assets.components;

namespace gd_prototype.assets.plane;

/// <summary>
/// 狗狗控制器
/// </summary>
public partial class Plane : CharacterBody2D
{
    [Export]
    private InputComponent _inputComponent;
    
    [Export]
    public float Speed { get; set; } = 100.0f;

    private Vector2 _direction = Vector2.Zero;

    public override void _Ready()
    {
        if (_inputComponent != null)
        {
            // 假设 InputComponent 有一个这样的事件，如果实际名称不同，需要修改这里
            // 例如：_inputComponent.OnAction += HandleAction;
            _inputComponent.OnInputTriggered += OnInputTriggered;
        }
        else
        {
            GD.PrintErr("InputComponent is not assigned in the inspector for Dog.cs");
        }
    }

    public override void _ExitTree()
    {
        if (_inputComponent != null)
        {
            _inputComponent.OnInputTriggered -= OnInputTriggered;
        }
    }

    public override void _PhysicsProcess(double delta)
    {
        Velocity = _direction * Speed;

        MoveAndSlide();
        
        // 在处理完移动后重置方向，以便下一帧重新计算
        _direction = Vector2.Zero;
    }

    // 这个方法处理来自InputComponent的输入事件
    private void OnInputTriggered(string actionName, Variant argv)
    {
        // 我们累加方向，而不是直接设置速度
        switch (actionName)
        {
            case EInputAction.Move:
                _direction = (Vector2)argv;
                break;
        }
        _direction = _direction.Normalized();
        PlayAnimation();
    }

    private void PlayAnimation()
    {
        if (_direction != Vector2.Zero)
        {
            var angle = -_direction.AngleTo(Vector2.Up);
            Rotation = angle;
        }
    }
    
}
