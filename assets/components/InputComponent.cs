using System;
using Godot;
using Godot.Collections;

namespace gd_prototype.assets.components;

/// <summary>
/// 一个通用的输入处理组件。
/// 它通过处理一个 InputActionMapping 资源数组，根据玩家输入来触发相应的动作。
/// </summary>
[GlobalClass]
public partial class InputComponent : Node
{
	/// <summary>
	/// 一组定义好的操作集合
	/// </summary>
	[Export]
	public InputSet InputSet { get; set; }

	/// <summary>
	/// 如果为 true，该组件将处理输入。可用于临时禁用输入处理。
	/// </summary>
	[Export]
	public bool IsActive { get; set; } = true;
	
	/// <summary>
	/// 当输入检测到时触发
	/// </summary>
	public event Action<string, Variant?> OnInputTriggered;
	
	private Array<InputActionMapping> Mappings => InputSet == null ? [] : InputSet.ActionMappings;

	public override void _Input(InputEvent @event)
	{
		if (!IsActive || Mappings == null)
		{
			return;
		}

		foreach (var mapping in Mappings)
		{
			if (mapping == null)
			{
				continue;
			}

			switch (mapping.InputType)
			{
				// 只处理离散的按键事件
				case InputActionMapping.EInputType.Pressed when Input.IsActionJustPressed(mapping.ActionName):
				case InputActionMapping.EInputType.Released when Input.IsActionJustReleased(mapping.ActionName):
					TriggerResponse(mapping);
					break;
			}
		}
	}

	public override void _Process(double delta)
	{
		if (!IsActive || Mappings == null)
		{
			return;
		}

		foreach (var mapping in Mappings)
		{
			if (mapping == null)
			{
				continue;
			}

			switch (mapping.InputType)
			{
				// 处理持续按住的按键
				case InputActionMapping.EInputType.Held when Input.IsActionPressed(mapping.ActionName):
					TriggerResponse(mapping);
					break;
				// 处理模拟输入（摇杆）
				case InputActionMapping.EInputType.Analog:
				{
					var analogVector = Input.GetVector(
						mapping.AnalogNegativeX, 
						mapping.AnalogPositiveX, 
						mapping.AnalogNegativeY, 
						mapping.AnalogPositiveY
					);

					TriggerResponse(mapping, analogVector);

					break;
				}
			}
		}
	}

	private void TriggerResponse(InputActionMapping mapping, Variant? argument = null)
	{
		OnInputTriggered?.Invoke(mapping.ActionName, argument);
	}
	
	public override string[] _GetConfigurationWarnings()
	{
      var warnings = new System.Collections.Generic.List<string>();

      if (InputSet == null)
      {
          warnings.Add("未指定输入集资源 (InputSet)");
      }
      else
      {
          if (InputSet.ActionMappings.Count == 0)
          {
              warnings.Add("输入集不包含任何动作映射");
          }
      }

      return warnings.ToArray();
  }
}
