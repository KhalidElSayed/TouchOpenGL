//
//  CRendererOpenGLLayer.h
//  TouchOpenGL
//
//  Created by Jonathan Wight on 01/31/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@class CRenderer;

@interface CRendererOpenGLLayer : CAOpenGLLayer {

}

@property (readwrite, nonatomic, strong) CRenderer *renderer;

@end
