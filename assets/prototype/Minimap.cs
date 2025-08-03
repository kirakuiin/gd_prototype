using Godot;

namespace gd_prototype.assets.prototype;

public partial class Minimap: Node2D
{
    [Export]
    public SubViewport Viewport;
    public override void _Ready()
    {
        Viewport.World2D = GetTree().Root.World2D;
    }
}