//
//  CNewMesh.m
//  ModelViewer
//
//  Created by Jonathan Wight on 03/22/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CMesh.h"


@implementation CMesh

@synthesize geometries;
@synthesize center;
@synthesize p1, p2;
@synthesize transform;
@synthesize cullBackFaces;

- (id)init
	{
	if ((self = [super init]) != NULL)
		{
        transform = Matrix4Identity;
		}
	return(self);
	}


- (void)dealloc
    {
    [geometries release];
    geometries = NULL;
    //
    [super dealloc];
    }

@end
