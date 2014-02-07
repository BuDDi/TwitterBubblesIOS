//
//  TBTypes.h
//  TwitterBubblesIOS
//
//  Created by Buddi on 03.02.14.
//  Copyright (c) 2014 BudWorks. All rights reserved.
//

#ifndef TwitterBubblesIOS_TBTypes_h
#define TwitterBubblesIOS_TBTypes_h

#import <GLKit/GLKit.h>

#ifndef BUFFER_OFFSET
#define BUFFER_OFFSET(i) ((char *)NULL + (i))
#endif

typedef struct _vertexStruct
{
    GLfloat position[3];
    GLfloat normal[3];
    //GLubyte color[4];
    GLfloat texCoord[2];
} vertex_t;

// Attribute index.
enum {
    ATTRIB_POSITION,
    ATTRIB_NORMAL,
    ATTRIB_TEXCOORD,
    ATTRIB_COLOR,
    NUM_ATTRIBUTES
};

#endif
