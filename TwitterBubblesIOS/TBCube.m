//
//  TBCube.m
//  TwitterBubblesIOS
//
//  Created by Buddi on 05.02.14.
//  Copyright (c) 2014 BudWorks. All rights reserved.
//

#import "TBCube.h"


GLfloat gCubeVertexData[216] =
{
    // Data layout for each line below is:
    // positionX, positionY, positionZ,     normalX, normalY, normalZ,
    0.5f, -0.5f, -0.5f,        1.0f, 0.0f, 0.0f,
    0.5f, 0.5f, -0.5f,         1.0f, 0.0f, 0.0f,
    0.5f, -0.5f, 0.5f,         1.0f, 0.0f, 0.0f,
    0.5f, -0.5f, 0.5f,         1.0f, 0.0f, 0.0f,
    0.5f, 0.5f, -0.5f,          1.0f, 0.0f, 0.0f,
    0.5f, 0.5f, 0.5f,         1.0f, 0.0f, 0.0f,
    
    0.5f, 0.5f, -0.5f,         0.0f, 1.0f, 0.0f,
    -0.5f, 0.5f, -0.5f,        0.0f, 1.0f, 0.0f,
    0.5f, 0.5f, 0.5f,          0.0f, 1.0f, 0.0f,
    0.5f, 0.5f, 0.5f,          0.0f, 1.0f, 0.0f,
    -0.5f, 0.5f, -0.5f,        0.0f, 1.0f, 0.0f,
    -0.5f, 0.5f, 0.5f,         0.0f, 1.0f, 0.0f,
    
    -0.5f, 0.5f, -0.5f,        -1.0f, 0.0f, 0.0f,
    -0.5f, -0.5f, -0.5f,       -1.0f, 0.0f, 0.0f,
    -0.5f, 0.5f, 0.5f,         -1.0f, 0.0f, 0.0f,
    -0.5f, 0.5f, 0.5f,         -1.0f, 0.0f, 0.0f,
    -0.5f, -0.5f, -0.5f,       -1.0f, 0.0f, 0.0f,
    -0.5f, -0.5f, 0.5f,        -1.0f, 0.0f, 0.0f,
    
    -0.5f, -0.5f, -0.5f,       0.0f, -1.0f, 0.0f,
    0.5f, -0.5f, -0.5f,        0.0f, -1.0f, 0.0f,
    -0.5f, -0.5f, 0.5f,        0.0f, -1.0f, 0.0f,
    -0.5f, -0.5f, 0.5f,        0.0f, -1.0f, 0.0f,
    0.5f, -0.5f, -0.5f,        0.0f, -1.0f, 0.0f,
    0.5f, -0.5f, 0.5f,         0.0f, -1.0f, 0.0f,
    
    0.5f, 0.5f, 0.5f,          0.0f, 0.0f, 1.0f,
    -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
    0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
    0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
    -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
    -0.5f, -0.5f, 0.5f,        0.0f, 0.0f, 1.0f,
    
    0.5f, -0.5f, -0.5f,        0.0f, 0.0f, -1.0f,
    -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, -1.0f,
    0.5f, 0.5f, -0.5f,         0.0f, 0.0f, -1.0f,
    0.5f, 0.5f, -0.5f,         0.0f, 0.0f, -1.0f,
    -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, -1.0f,
    -0.5f, 0.5f, -0.5f,        0.0f, 0.0f, -1.0f
};


@interface TBCube () {
    //GLuint _program;
    //GLKMatrix4 _modelViewProjectionMatrix;                                          //3
    //GLKMatrix3 _normalMatrix;
    //float _rotation;
    GLuint _vertexArray;
    GLuint _vertexBuffer;
}
@end

@implementation TBCube

- (id) initWithSetup
{
    self = [super init];
    if(self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    /*[EAGLContext setCurrentContext:self.context];                                   //7
     [self loadShaders];
     self.effect = [[GLKBaseEffect alloc] init];                                     //8
     self.effect.light0.enabled = GL_TRUE;                                           //9
     self.effect.light0.diffuseColor = GLKVector4Make(1.0f, 0.4f, 0.4f, 1.0f);       //10
     glEnable(GL_DEPTH_TEST);*/                                                        //11
    glGenVertexArraysOES(1, &_vertexArray);                                         //12
    glBindVertexArrayOES(_vertexArray);
    glGenBuffers(1, &_vertexBuffer);                                                //13
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER,
                 sizeof(gCubeVertexData), gCubeVertexData, GL_STATIC_DRAW); //14
    glEnableVertexAttribArray(GLKVertexAttribPosition);                             //15
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 24,
                          BUFFER_OFFSET(0));
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 24,
                          BUFFER_OFFSET(12));
    glBindVertexArrayOES(0);                                                        //16
}

- (void)tearDown                                                                  //17
{
    //[EAGLContext setCurrentContext:self.context];
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);
    /*self.effect = nil;
     if (_program) {
     glDeleteProgram(_program);
     _program = 0;
     }*/
}

- (void)draw
{
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);                                        //14
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glBindVertexArrayOES(_vertexArray);                                             //15
    // Render the object with GLKit.
    //[self.effect prepareToDraw];                                                    //16
    //glDrawArrays(GL_TRIANGLES, 0, 36);                                              //17
    // Render the object again with ES2.
    //glUseProgram(_program);                                                         //18
    //glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0,
    //                   _modelViewProjectionMatrix.m);
    //glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, _normalMatrix.m);
    glDrawArrays(GL_TRIANGLES, 0, 36);                                              //19
}

@end
