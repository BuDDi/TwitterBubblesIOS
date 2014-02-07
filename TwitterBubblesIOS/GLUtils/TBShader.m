//
//  TBShader.m
//  TwitterBubblesIOS
//
//  Created by Buddi on 03.02.14.
//  Copyright (c) 2014 BudWorks. All rights reserved.
//

#import "TBShader.h"

// private field / method declarations
@interface TBShader() {
    // vertex shader handle
    GLuint vsHandle;
    // fragment shader handle
    GLuint fsHandle;
}
- (BOOL)validateProgram:(GLuint)prog;
#if defined(DEBUG)
+(void) printProgramLog:(GLint) program;
+(void) printShaderLog:(GLint) shader;
#endif
@end


@implementation TBShader

@synthesize programHandle = _programHandle;


- (id)init
{
    self = [super init];
    if (self) {
        // create the program on initialization
        _programHandle = glCreateProgram();
    }
    return self;
}
/**
 * Load the vertex shader.
 *
 * @param file
 */
-(BOOL) loadVertexShader:(NSString*) name
{
    NSString* vertShaderPathname;
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:name ofType:@"vsh"];
    if (![self compileShader:&vsHandle type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    return YES;
}

/**
 * Load the fragment shader.
 *
 * @param file
 */
-(BOOL) loadFragmentShader:(NSString*) name
{
    // Create and compile fragment shader.
    NSString* fragShaderPathname;
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:name ofType:@"fsh"];
    if (![self compileShader:&fsHandle type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    return YES;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    [TBShader printShaderLog: *shader];
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        *shader = 0;
        return NO;
    }
#if defined(DEBUG)
    GLint attachedShaders;
    glGetProgramiv(_programHandle, GL_ATTACHED_SHADERS, &attachedShaders);
#endif
    if (*shader && _programHandle) {
        glAttachShader(_programHandle, *shader);
        // if debug on check if the shader has been attached
#if defined(DEBUG)
        GLint newAttachedShaders;
        glGetProgramiv(_programHandle, GL_ATTACHED_SHADERS, &newAttachedShaders);
        if(newAttachedShaders == attachedShaders) {
            NSLog(@"Could not attach shader");
            glDeleteShader(*shader);
            *shader = 0;
            return NO;
        }
#endif
    }
    return YES;
}

/**
 * Creates the shader program with the already compiled shaders.
 */
-(BOOL) useShaders
{
    // Attach vertex shader to program.
    //_programHandle = glCreateProgram();
#if defined(DEBUG)
    if (_programHandle == 0) {
        NSLog(@"Did not get a valid program handle from OpenGL ES");
        return NO;
    }
#endif
#if defined(DEBUG)
    GLint attachedShaders;
    glGetProgramiv(_programHandle, GL_ATTACHED_SHADERS, &attachedShaders);
    if (attachedShaders == 0) {
        NSLog(@"Did not attach any shader");
        return NO;
    }
#endif
    GLint status;
    // now link the program
    glLinkProgram(_programHandle);

#if defined(DEBUG)
    [TBShader printProgramLog: _programHandle];
#endif
    
    glGetProgramiv(_programHandle, GL_LINK_STATUS, &status);
    if (status == 0) {
        NSLog(@"Failed to link program: %d", _programHandle);
        
        if (vsHandle) {
            glDeleteShader(vsHandle);
            vsHandle = 0;
        }
        if (fsHandle) {
            glDeleteShader(fsHandle);
            fsHandle = 0;
        }
        if (_programHandle) {
            glDeleteProgram(_programHandle);
            _programHandle = 0;
        }
        
        return NO;
    }
    // Release vertex and fragment shaders.
    if (vsHandle) {
        glDetachShader(_programHandle, vsHandle);
        glDeleteShader(vsHandle);
        vsHandle = 0;
    }
    if (fsHandle) {
        glDetachShader(_programHandle, fsHandle);
        glDeleteShader(fsHandle);
        fsHandle = 0;
    }
    return YES;
}

/**
 * Uses the shader program.
 */
-(void) startShader
{
    glUseProgram(_programHandle);
}

/**
 * Resets to fixed function shader.
 */
/*-(void) endShader
{
    // should use the default shader
    glUseProgram(0);
}*/

-(void) bindAttribute:(NSString *)name atLocation:(GLuint)location
{
    glBindAttribLocation(_programHandle, location, [name UTF8String]);
}

/**
 * Returns the handle of an attribute variable of that program.
 *
 * @param name
 *           name of the attribute variable to look for.
 * @return handle to the attribute variable.
 */
-(GLuint) getAttribLocation:(NSString*) name
{
    return glGetAttribLocation(_programHandle, [name UTF8String]);
}

/**
 * Returns the handle of an attribute variable of that program.
 *
 * @param name
 *           name name of the attribute variable to look for.
 * @return handle to the uniform variable.
 */
-(GLuint) getUniformLocation:(NSString*) name
{
    return glGetUniformLocation(_programHandle, [name UTF8String]);
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

-(void) tearDown
{
    // detach shaders from program and delete the shaders
    if (vsHandle && _programHandle) {
        glDetachShader(_programHandle, vsHandle);
        glDeleteShader(vsHandle);
        vsHandle = 0;
    }
    if (fsHandle && _programHandle) {
        glDetachShader(_programHandle, fsHandle);
        glDeleteShader(fsHandle);
        fsHandle = 0;
    }
    // delete the program
    if (_programHandle) {
        glDeleteProgram(_programHandle);
        _programHandle = 0;
    }
}

- (void)dealloc
{
    [self tearDown];
}

// methods excluded in Release
#if defined(DEBUG)
+(void) printProgramLog:(GLint) program
{
    GLint logLength;
    glGetProgramiv(program, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(program, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
}

+(void) printShaderLog:(GLint) shader
{
    GLint logLength;
    glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
}
#endif

@end
