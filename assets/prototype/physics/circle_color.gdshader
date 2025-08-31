shader_type canvas_item;

// HSV颜色参数
uniform vec4 color: source_color;

// 圆形参数
uniform float radius : hint_range(0.0, 1.0) = 0.5;


void fragment() {
   // 获取纹理原始颜色
   vec4 tex_color = texture(TEXTURE, UV);

   // 计算到中心的距离
   vec2 center = vec2(0.5, 0.5);
   float dist = distance(UV, center);

   // 创建圆形遮罩
   float circle_mask = 1.0 - step(radius, dist);

   // 输出最终颜色
   COLOR = color * circle_mask;
}