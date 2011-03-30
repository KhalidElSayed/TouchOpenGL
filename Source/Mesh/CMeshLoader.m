//
//  CNewModelLoader.m
//  ModelViewer
//
//  Created by Jonathan Wight on 03/22/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CMeshLoader.h"

#import "CMesh.h"
#import "CGeometry.h"
#import "CVertexBufferReference.h"
#import "CVertexBuffer_PropertyListRepresentation.h"
#import "NSData_NumberExtensions.h"

#define NO_DEFAULTS 1

@interface CMeshLoader ()
@property (readwrite, nonatomic, retain) NSDictionary *modelDictioary;
@property (readwrite, nonatomic, retain) CMesh *mesh;
@property (readwrite, nonatomic, retain) NSMutableDictionary *buffers;

- (CVertexBufferReference *)vertexBufferReferenceWithDictionary:(NSDictionary *)inRepresentation error:(NSError **)outError;

@end

#pragma mark -

@implementation CMeshLoader

@synthesize modelDictioary;
@synthesize mesh;
@synthesize buffers;

- (void)dealloc
    {
    //
    [super dealloc];
    }

- (CMesh *)loadMeshWithURL:(NSURL *)inURL error:(NSError **)outError
	{
	self.modelDictioary = [NSDictionary dictionaryWithContentsOfURL:inURL];
    if (self.modelDictioary == NULL)
        {
        return(NULL);
        }
    
    
	self.mesh = [[[CMesh alloc] init] autorelease];

    id theObject = [self.modelDictioary objectForKey:@"center"];
    if (theObject)
        {
        self.mesh.center = Vector3FromPropertyListRepresentation(theObject);
        }

    theObject = [self.modelDictioary objectForKey:@"boundingbox"];
    if (theObject)
        {
        self.mesh.p1 = Vector3FromPropertyListRepresentation([theObject objectAtIndex:0]);
        self.mesh.p2 = Vector3FromPropertyListRepresentation([theObject objectAtIndex:1]);
        }


	theObject = [self.modelDictioary objectForKey:@"transform"];
	if (theObject != NULL)
		{
		self.mesh.transform = Matrix4FromPropertyListRepresentation(theObject);
		}


	// #### Buffers
	self.buffers = [NSMutableDictionary dictionary];
	NSDictionary *theBuffersDictionary = [self.modelDictioary objectForKey:@"buffers"];
	for (NSString *theBufferName in theBuffersDictionary)
		{
		NSDictionary *theBufferDictionary = [theBuffersDictionary objectForKey:theBufferName];
		
		CVertexBuffer *theVertexBuffer = [[[CVertexBuffer alloc] initWithPropertyListRepresentation:theBufferDictionary error:NULL] autorelease];
		
		[self.buffers setObject:theVertexBuffer forKey:theBufferName];
		}

	// #### Geometries...
	NSMutableArray *theGeometries = [NSMutableArray array];
	for (NSDictionary *theGeometryDictionary in [self.modelDictioary objectForKey:@"geometries"])
		{
		CGeometry *theGeometry = [[[CGeometry alloc] init] autorelease];
		
		for (NSString *theKey in [NSArray arrayWithObjects:@"indices", @"positions", @"normals", @"texCoords", NULL])
			{
			NSDictionary *theVerticesDictionary = [theGeometryDictionary objectForKey:theKey];
			if (theVerticesDictionary != NULL)
				{
				CVertexBufferReference *theVertexBufferReference = [self vertexBufferReferenceWithDictionary:theVerticesDictionary error:outError];
				if (theVertexBufferReference == NULL)
					{
					return(NULL);
					}
				[theGeometry setValue:theVertexBufferReference forKey:theKey];
				}
			}

		[theGeometries addObject:theGeometry];
		}

	self.mesh.geometries = theGeometries;


	return(self.mesh);
	}

- (CVertexBufferReference *)vertexBufferReferenceWithDictionary:(NSDictionary *)inRepresentation error:(NSError **)outError
	{
    NSNumber *theNumber = [(NSDictionary *)inRepresentation objectForKey:@"size"];
    NSAssert(NO_DEFAULTS && theNumber != NULL, @"No size specified.");
    GLint theSize = [theNumber intValue] ?: 3;

    NSString *theString = [(NSDictionary *)inRepresentation objectForKey:@"type"];
    NSAssert(NO_DEFAULTS && theString.length > 0, @"No type specified.");
    GLenum theType = GLenumFromString(theString) ?: GL_FLOAT;

    theString = [(NSDictionary *)inRepresentation objectForKey:@"normalized"];
    NSAssert(NO_DEFAULTS && theNumber != NULL, @"No normalized specified.");
    GLboolean theNormalized = [theString boolValue] ?: GL_FALSE;

    theString = [(NSDictionary *)inRepresentation objectForKey:@"stride"];
    NSAssert(NO_DEFAULTS && theNumber != NULL, @"No stride specified.");
    GLint theStride = [theString intValue];

    theString = [(NSDictionary *)inRepresentation objectForKey:@"offset"];
    NSAssert(NO_DEFAULTS && theNumber != NULL, @"No offset specified.");
    GLint theOffset = [theString intValue];

    NSString *theBufferName = [(NSDictionary *)inRepresentation objectForKey:@"buffer"];
    CVertexBuffer *theVertexBuffer = [self.buffers objectForKey:theBufferName];

    GLint theRowSize = 0;

    if (theStride != 0)
        {
        theRowSize = theStride;
        }
    else if (theType == GL_FLOAT)
        {
        theRowSize = sizeof(GLfloat) * theSize;
        }
    else if (theType == GL_SHORT)
        {
        theRowSize = sizeof(GLshort) * theSize;
        }

    if (theVertexBuffer.data.length % theRowSize != 0)
        {
        if (outError != NULL)
            {
            *outError = [NSError errorWithDomain:@"TODO_DOMAIN" code:-1 userInfo:NULL];
            }
        return(NULL);
        }

    GLint theRowCount = (GLint)(theVertexBuffer.data.length / theRowSize);


	CVertexBufferReference *theVertexBufferReference = [[[CVertexBufferReference alloc] initWithVertexBuffer:theVertexBuffer rowSize:theRowSize rowCount:theRowCount size:theSize type:theType normalized:theNormalized stride:theStride offset:theOffset] autorelease];
	return(theVertexBufferReference);
	}



@end