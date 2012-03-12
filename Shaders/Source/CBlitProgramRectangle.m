//
//  CBlitProgramRectangle.m
//  Dwarf
//
//  Created by Jonathan Wight on 9/10/11.
//  Copyright (c) 2011 toxicsoftware.com. All rights reserved.
//

#import "CBlitProgramRectangle.h"

#import "OpenGLTypes.h"
#import "OpenGLIncludes.h"
#import "CTexture.h"
#import "CVertexBufferReference.h"

#define ktexCoordsAttributeIndex 0
#define kpositionsAttributeIndex 1

@interface CBlitProgramRectangle ()

// Uniforms
@property (readwrite, nonatomic, assign) GLint texture0Uniform;
@property (readwrite, nonatomic, assign) GLint texture0Index;
@property (readwrite, nonatomic, assign) GLint colorUniform;
@property (readwrite, nonatomic, assign) GLint modelViewMatrixUniform;
@property (readwrite, nonatomic, assign) GLint projectionViewMatrixUniform;

@end

@implementation CBlitProgramRectangle

// Uniforms
@synthesize texture0;
@synthesize texture0Uniform;
@synthesize texture0Index;
@synthesize color;
@synthesize colorUniform;
@synthesize modelViewMatrix;
@synthesize modelViewMatrixUniform;
@synthesize projectionViewMatrix;
@synthesize projectionViewMatrixUniform;

// Attributes
@synthesize texCoords;
@synthesize positions;

- (id)init
    {
    NSArray *theUniformNames = @[
        @"u_texture0",
        @"u_color",
        @"u_modelViewMatrix",
        @"u_projectionMatrix",
        ];

    NSArray *theShaders = @[
        [[self class] loadShader:@"BlitTextureRectangle.fsh"],
        [[self class] loadShader:@"Default.vsh"],
        ];

    if ((self = [self initWithShaders:theShaders uniformNames:theUniformNames]) != NULL)
        {
        [self bindAttribute:@"a_texCoord" location:ktexCoordsAttributeIndex];
        [self bindAttribute:@"a_position" location:kpositionsAttributeIndex];


		AssertOpenGLNoError_();

		[self linkProgram:NULL];

		NSError *theError = NULL;
		[self validate:&theError];

		AssertOpenGLNoError_();

        // texture0
        texture0 = NULL;
        texture0Uniform = -1;
        texture0Index = 0;
        // color
        color = (Color4f){ 0.0, 0.0, 0.0, 0.0 };
        colorUniform = -1;
        // modelViewMatrix
        modelViewMatrix = Matrix4Identity;
        modelViewMatrixUniform = -1;
        // projectionViewMatrix
        projectionViewMatrix = Matrix4Identity;
        projectionViewMatrixUniform = -1;
        }
    return self;
    }

- (void)update
    {
    [super update];
    //
    AssertOpenGLNoError_();

    // texture0
    if (texture0Uniform == -1)
        {
        texture0Uniform = glGetUniformLocation(self.name, "u_texture0");
        }

    [texture0 use:texture0Uniform index:texture0Index];
    AssertOpenGLNoError_();
    // color
    if (colorUniform == -1)
        {
        colorUniform = glGetUniformLocation(self.name, "u_color");
        }

    glUniform4fv(colorUniform, 1, &color.r);
    AssertOpenGLNoError_();
    // modelViewMatrix
    if (modelViewMatrixUniform == -1)
        {
        modelViewMatrixUniform = glGetUniformLocation(self.name, "u_modelViewMatrix");
        }

    glUniformMatrix4fv(modelViewMatrixUniform, 1, NO, &modelViewMatrix.m[0][0]);
    AssertOpenGLNoError_();
    // projectionViewMatrix
    if (projectionViewMatrixUniform == -1)
        {
        projectionViewMatrixUniform = glGetUniformLocation(self.name, "u_projectionMatrix");
        }

    glUniformMatrix4fv(projectionViewMatrixUniform, 1, NO, &projectionViewMatrix.m[0][0]);
    AssertOpenGLNoError_();

    // texCoords
    if (texCoords)
        {
        [texCoords use:ktexCoordsAttributeIndex];
        glEnableVertexAttribArray(ktexCoordsAttributeIndex);

        AssertOpenGLNoError_();
        }
    // positions
    if (positions)
        {
        [positions use:kpositionsAttributeIndex];
        glEnableVertexAttribArray(kpositionsAttributeIndex);

        AssertOpenGLNoError_();
        }
    }

@end