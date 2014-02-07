//
//  TBShader.h
//  TwitterBubblesIOS
//
//  Created by Buddi on 03.02.14.
//  Copyright (c) 2014 BudWorks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface TBShader : NSObject

/**
 *
 * handle to this shader program
 */
@property(readonly) GLuint programHandle;

/**
 * Load the vertex shader.
 *
 * @param file
 */
-(BOOL) loadVertexShader:(NSString*) name;

/**
 * Load the fragment shader.
 *
 * @param file
 */
-(BOOL) loadFragmentShader:(NSString*) file;

/**
 * Creates the shader program with the already compiled shaders.
 */
-(BOOL) useShaders;

/**
 * Uses the shader program.
 */
-(void) startShader;

/**
 * Resets to fixed function shader.
 */
//-(void) endShader;

/**
 * only use this method before you ever called 'useShaders'
 */
-(void) bindAttribute:(NSString*) name atLocation:(GLuint) location;

/**
 * Returns the handle of an attribute variable of that program.
 *
 * @param name
 *           name of the attribute variable to look for.
 * @return handle to the attribute variable.
 */
-(GLuint) getAttribLocation:(NSString*) name;

/**
 * Returns the handle of an attribute variable of that program.
 *
 * @param name
 *           name name of the attribute variable to look for.
 * @return handle to the uniform variable.
 */
-(GLuint) getUniformLocation:(NSString*) name;

/**
 * releases all resources used by this shader
 */
-(void) tearDown;


@end
