using System.IO;
using System.Linq;
using Godot;

/// <summary>
/// 读取编辑器中设置好的action并生成脚本。
/// </summary>
public partial class InputMapGenerator : EditorScript
{
	
	public void Generate(string path)
	{
		var scriptContent = GenerateScriptContent();
		GD.Print(scriptContent);
		CreateCsFile(path);
		WriteScriptContent(scriptContent, path);
	}

	private string GenerateScriptContent()
	{
		InputMap.LoadFromProjectSettings();
		var inputs = InputMap.GetActions().Where(value => !value.ToString().Contains('.') && !value.ToString().Contains("ui"))
			.ToList();

		var inputsString = string.Join("\n\t", inputs.Select(input => {
			string inputStr = input.ToString().Split(".")[0];
			return $"public const string {input.ToString().ToPascalCase()} = \"{input}\";";
		}));

		return @$"public class EInputAction {{
	{inputsString}
}}
";
	}

	private void CreateCsFile(string path)
	{
		if (!File.Exists(path))
		{
			File.Create(path).Close();
		}
	}

	private void WriteScriptContent(string scriptContent, string path)
	{
		var scriptPath = "res://" + path;
		var script = ResourceLoader.Load<CSharpScript>(scriptPath);
		script.SourceCode = scriptContent;
		ResourceSaver.Save(script, scriptPath);
	}
}
