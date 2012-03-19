//
//  CTextureRenderer.h
//  VideoFilterToy_OSX
//
//  Created by Jonathan Wight on 3/6/12.
//  Copyright (c) 2012 toxicsoftware.com. All rights reserved.
//

#import "CBlockRenderer.h"

@class CTexture;
@class CBlitProgram;

@interface CTextureRenderer : CBlockRenderer

@property (readwrite, nonatomic, strong) CTexture *texture;
@property (readwrite, nonatomic, strong) CBlitProgram *program;

@end
