#version 430
layout(location = 0) in ivec3 aPos;


uniform sampler3D texels;
uniform sampler3D image;
uniform float width_ratio;
uniform float height_ratio;
uniform float depth_ratio;
uniform float ac_seeds_num;


out VS_OUT {
	int gLayer;
	vec3 gPos;
	vec3 gColor;
} vs_out;

void main()
{
	vec3 curr_tex = vec3(aPos.x+0.5,aPos.y+0.5,aPos.z+0.5);
	vs_out.gPos = curr_tex;
	curr_tex.x *= width_ratio;
	curr_tex.y *= height_ratio;
	curr_tex.z *= depth_ratio;
	float targetId = texture(texels,curr_tex).a;
	vs_out.gColor = texture(image,curr_tex).rgb;
	vec3 target;
	//target.z = floor(targetId*width_ratio*height_ratio);
	if(targetId<0)
	{
	target.z=0;
	target.y = floor(ac_seeds_num*width_ratio);
	target.x = floor(ac_seeds_num-target.y/width_ratio);
	target+=0.5;
	}
	else
	{
	target.z=0;
	target.y = floor(targetId*width_ratio);
	target.x = floor(targetId-target.y/width_ratio);
	target+=0.5;
	}
	
	
	target.x = target.x*width_ratio;
	target.y = target.y*height_ratio;
	vec2 opengl_xy = 2*(target.xy)-1;
	gl_Position = vec4(opengl_xy,0.0,1.0);
	
	vs_out.gLayer = int(target.z);
	
}