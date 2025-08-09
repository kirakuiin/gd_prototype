using System.Data;
using Godot;
using PhantomCamera;


public partial class VirualCamera : Node2D
{
    [Export] private Node2D _glued;
    
    [Export] private Node2D _simple;
    
    [Export] private Node2D _group;
    
    [Export] private Node2D _frame;
    
    [Export] private Node2D _path;

    [Export] private Node2D _plane;

    [Export] private TileMapLayer _layer;
    
    [Export] private RichTextLabel _label;
    
    private const int MaxPriority = 10;

    private PhantomCameraHost _host;

    public override void _Ready()
    {
        _host = GetNode<Node>("%Host").AsPhantomCameraHost();
    }

    public override void _Input(InputEvent @event)
    {
        if (Input.IsActionJustPressed("interact"))
        {
            SwitchCamera();
        }

        if (Input.IsActionJustReleased("action"))
        {
            var emitter = GetNode<Node2D>("PhantomCameraNoiseEmitter2D").AsPhantomCameraNoiseEmitter2D();
            emitter.Emit();
        }
    }

    private string GetCameraType()
    {
        var localPos = _layer.ToLocal(_plane.GlobalPosition);
        var gridPos = _layer.LocalToMap(localPos);
        var data = _layer.GetCellTileData(gridPos);
        if (data == null) return "";
        return data.HasCustomData("camera") ? data.GetCustomData("camera").AsString() : "";
    }

    private void SwitchCamera()
    {
        var cameraName = GetCameraType();
        var camera = _GetPhantomCamera(cameraName);
        if (camera == null) return;
        _host.GetActivePhantomCamera()!.AsPhantomCamera2D()!.Node2D.Visible = false;
        camera.Priority = MaxPriority;
        camera.Node2D.Visible = true;
        _label.Text = $"当前相机模式: {cameraName}";
    }

    private PhantomCamera2D _GetPhantomCamera(string cameraName)
    {
        switch (cameraName)
        {
            case "glued":
                return _glued.AsPhantomCamera2D();
            case "simple":
                return _simple.AsPhantomCamera2D();
            case "frame":
                return _frame.AsPhantomCamera2D();
            case "group":
                return _group.AsPhantomCamera2D();
            case "path":
                return _path.AsPhantomCamera2D();
        }

        return null;
    }
    
}