//
//  Shader.vsh
//  Dwarfs
//
//  Created by Jonathan Wight on 09/05/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

attribute vec4 a_position;
attribute vec2 a_texCoord;

uniform mat4 u_modelViewMatrix;
uniform mat4 u_projectionMatrix;

varying vec2 v_texture;

void main()
    {
    v_texture = a_texCoord;
    gl_Position = u_projectionMatrix * u_modelViewMatrix * a_position;
    }
