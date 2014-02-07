//
//  TBSphere.m
//  TwitterBubblesIOS
//
//  Created by Buddi on 03.02.14.
//  Copyright (c) 2014 BudWorks. All rights reserved.
//

#import "TBSphere.h"
#include <math.h>

//#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

@interface TBSphere()
{
    vertex_t* _vertices;
    GLuint* _indices;
    GLuint _vertexCount;
    GLuint _indexCount;
    GLuint _triangleCount;
    GLuint _slices;
    GLuint _stacks;
    
    GLuint _vertexArray;
    GLuint _vertexBuffer;
    GLuint _normalBuffer;
    GLuint _texCoordBuffer;
    GLuint _indexBuffer;
    int _numPoints;
    //GLfloat* gSphereVertexData;
}
-(void)initBuffersWithRadius:(GLfloat) radius andParts:(GLuint) parts;
@end

@implementation TBSphere

- (id)init
{
    [NSException raise:NSGenericException
                format:@"Disabled. Use +[[%@ alloc] %@] instead",
     NSStringFromClass([self class]),
     NSStringFromSelector(@selector(initWithRadius:andParts:))];
    return nil;
}

void normalizeVec(GLfloat vec[3])
{
    float vecLength = (vec[0] * vec[0]) * (vec[1] * vec[1]) + (vec[2] * vec[2]);
    vecLength = sqrtf(vecLength);
    vec[0] *= 1/vecLength;
    vec[1] *= 1/vecLength;
    vec[2] *= 1/vecLength;
}

- (id)initWithRadius:(GLfloat)radius andParts:(GLuint) parts
{
    self = [super init];
    if (self) {
        [self setupWithRadius:radius andParts:parts];
    }
    return self;
}

-(void) configureVertexArrayObject
{
    /*glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, _vertexCount * sizeof(vertex_t), _vertices, GL_STATIC_DRAW);
    
    // New lines (were previously in draw)
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(vertex_t), (void*) offsetof(vertex_t, position));
    
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, _indexCount * sizeof(GLuint), _indices, GL_STATIC_DRAW);
    
    glBindVertexArrayOES(0);*/
    
    
    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    unsigned int sizeofStuff = _vertexCount*sizeof(vertex_t);
    glBufferData(GL_ARRAY_BUFFER, _vertexCount*sizeof(vertex_t), _vertices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    sizeofStuff = _indexCount*sizeof(GLuint);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, _indexCount*sizeof(GLuint), _indices, GL_STATIC_DRAW);
    
    //glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(vertex_t), (void*)offsetof(vertex_t,position));
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, sizeof(vertex_t), (void*)offsetof(vertex_t,normal));
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    //glVertexAttribPointer(GLKVertexAttribColor, 4, GL_UNSIGNED_BYTE, GL_TRUE, sizeof(vertex_t), (void*)offsetof(vertex_t, color));
    //glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(vertex_t), (void*)offsetof(vertex_t,texCoord));
    //glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    
    glBindVertexArrayOES(0);
}


-(void) initBuffersWithRadius:(GLfloat) radius andParts:(GLuint) parts
{
    float theta1 = 0.0, theta2 = 0.0, theta3 = 0.0;
    float ex = 0.0f, ey = 0.0f, ez = 0.0f;
    float px = 0.0f, py = 0.0f, pz = 0.0f;
    
    if( radius < 0 )
    radius = -radius;
    
    
    for(int i = 0; i < parts/2; ++i)
    {
        theta1 = i * (M_PI*2) / parts - M_PI_2;
        theta2 = (i + 1) * (M_PI*2) / parts - M_PI_2;
        
        for(int j = 0; j <= parts; ++j)
        {
            theta3 = j * (M_PI*2) / parts;
            
            ex = cosf(theta2) * cosf(theta3);
            ey = sinf(theta2);
            ez = cosf(theta2) * sinf(theta3);
            px = radius * ex;
            py = radius * ey;
            pz = radius * ez;
            
            _vertices[(6*j)+(0%6)].position[0] = px;
            _vertices[(6*j)+(1%6)].position[1] = py;
            _vertices[(6*j)+(2%6)].position[2] = pz;
            
            _vertices[(6*j)+(0%6)].normal[0] = ex;
            _vertices[(6*j)+(1%6)].normal[1] = ey;
            _vertices[(6*j)+(2%6)].normal[2] = ez;
            
            //_vertices[(4*j)+(0%4)].texCoord[0] = -(j/(float)parts);
            //_vertices[(4*j)+(1%4)].texCoord[1] = 2*(i+1)/(float)parts;
            
            
            ex = cosf(theta1) * cosf(theta3);
            ey = sinf(theta1);
            ez = cosf(theta1) * sinf(theta3);
            px = radius * ex;
            py = radius * ey;
            pz = radius * ez;
            
            _vertices[(6*j)+(3%6)].position[0] = px;
            _vertices[(6*j)+(4%6)].position[1] = py;
            _vertices[(6*j)+(5%6)].position[2] = pz;
            
            _vertices[(6*j)+(3%6)].normal[0] = ex;
            _vertices[(6*j)+(4%6)].normal[1] = ey;
            _vertices[(6*j)+(5%6)].normal[2] = ez;
            
            //texCoords[(4*j)+(2%4)] = -(j/(float)parts);
            //texCoords[(4*j)+(3%4)] = 2*i/(float)parts;
        }
    }
    
}

void drawsphere();

-(void) draw
{
    /*glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_NORMAL_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glVertexPointer(3, GL_FLOAT, 0, vertices);
    glNormalPointer(GL_FLOAT, 0, normals);
    glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, (_parts+1)*2);
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_NORMAL_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);*/
    //drawsphere();
    //glBindVertexArrayOES(_vertexArray);
    //glDrawArrays(GL_TRIANGLES, 0, vertexCount/3);
    //[self drawModel];
    [self drawNew];
}

-(void) initSphere:(GLfloat) radius withSlices:(GLuint) slices andStacks:(GLuint) stacks
{
#define PI 3.14159265358979323846f
    /*int width/slices = 32;
    int height/stacks = 16;*/
    
    float theta, phi;
    int i, j, t;
    
    /*nvec = (height-2)* width+2;
     ntri = (height-2)*(width-1)*2;
     
     dat = (float*) malloc( nvec * 3*sizeof(float) );
     idx =   (int*) malloc( ntri * 3*sizeof(int)   );*/
    
    for( t=0, j=1; j<stacks-1; j++ )
    for(      i=0; i<slices; i++ )
    {
        theta = (float)j/(stacks-1) * PI;
        phi   = (float)i/(slices-1 ) * PI*2;
        vertex_t vertex = _vertices[t++];
        vertex.position[0] =  sinf(theta) * cosf(phi);
        vertex.position[1] =  cosf(theta);
        vertex.position[2] = -sinf(theta) * sinf(phi);
    }
    vertex_t vertex = _vertices[t++];
    vertex.position[0]=0; vertex.position[1]= 1; vertex.position[2]=0;
    vertex = _vertices[t++];
    vertex.position[0]=0; vertex.position[1]=-1; vertex.position[2]=0;
    
    for( t=0, j=0; j<stacks-3; j++ )
    for(      i=0; i<slices-1; i++ )
    {
        _indices[t++] = (j  )*slices + i  ;
        _indices[t++] = (j+1)*slices + i+1;
        _indices[t++] = (j  )*slices + i+1;
        _indices[t++] = (j  )*slices + i  ;
        _indices[t++] = (j+1)*slices + i  ;
        _indices[t++] = (j+1)*slices + i+1;
    }
    for( i=0; i<slices-1; i++ )
    {
        _indices[t++] = (stacks-2)*slices;
        _indices[t++] = i;
        _indices[t++] = i+1;
        _indices[t++] = (stacks-2)*slices+1;
        _indices[t++] = (stacks-3)*slices + i+1;
        _indices[t++] = (stacks-3)*slices + i;
    }
}

void drawsphere()
{
    /*glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_NORMAL_ARRAY);
    glVertexPointer(3,GL_FLOAT,0,dat);
    glNormalPointer(GL_FLOAT,0,dat);
    glDrawElements(GL_TRIANGLES, _triangleCount*3, GL_UNSIGNED_INT, idx );
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_NORMAL_ARRAY);*/
    
    //free(idx);
    //free(dat);
}

-(void) drawModel
{
    //const vertexStruct vertices[] = {...};
    //const GLubyte indices[] = {...};
    glBindVertexArrayOES(_vertexArray);
    //glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    
    glDrawElements(GL_TRIANGLES, _triangleCount*3, GL_UNSIGNED_INT, (void*)0);
    //glDrawArrays(GL_TRIANGLE_STRIP, 0, _vertexCount);
}

- (void)dealloc
{
    [self tearDown];
}

-(void) tearDown
{
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);
}

GLfloat sphereVerticies[10000]={0.0};
GLfloat sphereNormals[10000]={0.0};
GLfloat sphereTexCoords[6667]={0.0};
GLuint triangleIndices[15000]={0};

int createSphere (GLfloat spherePoints[], GLfloat sphereNormals[], GLuint triangleIndices[], GLfloat texCoords[], GLfloat fRadius, GLfloat step)
{
    int points = 0;
    
    GLfloat uStep = step * M_PI / 180.0;
    GLfloat vStep = uStep;
    
    unsigned long index=0;
    
    for (GLfloat u = 0.0f; u <= (2 * M_PI); u += uStep)
    {
        for (GLfloat v = -M_PI_2; v <= M_PI_2; v += vStep)
        {
            triangleIndices[index++]=points;
            triangleIndices[index++]=points+1;
            triangleIndices[index++]=points+2;
            triangleIndices[index++]=points+3;
            triangleIndices[index++]=points+2;
            triangleIndices[index++]=points+1;
            
            /*triangleIndices[index++]=points+1;
            triangleIndices[index++]=points+2;
            triangleIndices[index++]=points+3;
            triangleIndices[index++]=points+2;
            triangleIndices[index++]=points+1;
            triangleIndices[index++]=points;*/
            
            points++;
            spherePoints[(points - 1) * 3] = fRadius * cosf(v) * cosf(u);             // x
            spherePoints[((points - 1) * 3) + 1] = fRadius * cosf(v) * sinf(u);       // y
            spherePoints[((points - 1) * 3) + 2] = fRadius * sinf(v);                 // z
            sphereNormals[(points - 1) * 3] = spherePoints[(points - 1) * 3];
            sphereNormals[((points - 1) * 3) + 1] = spherePoints[((points - 1) * 3) + 1];
            sphereNormals[((points - 1) * 3) + 2] = spherePoints[((points - 1) * 3) + 2];
            //texCoords[((points - 1) * 3) + 1] = ;
            normalizeVec(sphereNormals);
            
            points++;
            spherePoints[(points - 1) * 3] = fRadius * cosf(v) * cosf(u + uStep);             // x
            spherePoints[((points - 1) * 3) + 1] = fRadius * cosf(v) * sinf(u + uStep);       // y
            spherePoints[((points - 1) * 3) + 2] = fRadius * sinf(v);                         // z
            sphereNormals[(points - 1) * 3] = spherePoints[(points - 1) * 3];
            sphereNormals[((points - 1) * 3) + 1] = spherePoints[((points - 1) * 3) + 1];
            sphereNormals[((points - 1) * 3) + 2] = spherePoints[((points - 1) * 3) + 2];
            normalizeVec(sphereNormals);
            
            points++;
            spherePoints[(points - 1) * 3] = fRadius * cosf(v + vStep) * cosf(u);                  // x
            spherePoints[((points - 1) * 3) + 1] = fRadius * cosf(v + vStep) * sinf(u);            // y
            spherePoints[((points - 1) * 3) + 2] = fRadius * sinf(v + vStep);                      // z
            sphereNormals[(points - 1) * 3] = spherePoints[(points - 1) * 3];
            sphereNormals[((points - 1) * 3) + 1] = spherePoints[((points - 1) * 3) + 1];
            sphereNormals[((points - 1) * 3) + 2] = spherePoints[((points - 1) * 3) + 2];
            normalizeVec(sphereNormals);
            
            points++;
            spherePoints[(points - 1) * 3] = fRadius * cosf(v + vStep) * cosf(u + uStep);           // x
            spherePoints[((points - 1) * 3) + 1] = fRadius * cosf(v + vStep) * sinf(u + uStep);     // y
            spherePoints[((points - 1) * 3) + 2] = fRadius * sinf(v + vStep);                       // z
            sphereNormals[(points - 1) * 3] = spherePoints[(points - 1) * 3];
            sphereNormals[((points - 1) * 3) + 1] = spherePoints[((points - 1) * 3) + 1];
            sphereNormals[((points - 1) * 3) + 2] = spherePoints[((points - 1) * 3) + 2];
            normalizeVec(sphereNormals);
            
        }
    }        
    return points;
}

void createSphere2 (vertex_t** vertices, GLuint* verticesCount, GLuint** indices, GLuint* indicesCount, GLfloat fRadius, GLfloat step)
{
    GLfloat _sphereVerticies[10000]={0.0};
    //GLfloat _sphereNormals[10000]={0.0};
    GLuint _triangleIndices[15000]={0};
    int points = 0;
    
    GLfloat uStep = step * M_PI / 180.0;
    GLfloat vStep = uStep;
    
    unsigned long index=0;
    
    for (GLfloat u = 0.0f; u <= (2 * M_PI); u += uStep)
    {
        for (GLfloat v = -M_PI_2; v <= M_PI_2; v += vStep)
        {
            /*triangleIndices[index++]=points;
             triangleIndices[index++]=points+1;
             triangleIndices[index++]=points+2;
             triangleIndices[index++]=points+3;
             triangleIndices[index++]=points+2;
             triangleIndices[index++]=points+1;*/
            
            _triangleIndices[index++]=points+1;
            _triangleIndices[index++]=points+2;
            _triangleIndices[index++]=points+3;
            _triangleIndices[index++]=points+2;
            _triangleIndices[index++]=points+1;
            _triangleIndices[index++]=points;
            
            
            //points++;
            int xIndex = points * 3;
            _sphereVerticies[xIndex] = fRadius * cosf(v) * cosf(u);             // x
            _sphereVerticies[xIndex + 1] = fRadius * cosf(v) * sinf(u);       // y
            _sphereVerticies[xIndex + 2] = fRadius * sinf(v);                 // z
            //_sphereNormals[points*3] =
            points++;
            
            xIndex = points * 3;
            _sphereVerticies[xIndex] = fRadius * cosf(v) * cosf(u + uStep);             // x
            _sphereVerticies[xIndex + 1] = fRadius * cosf(v) * sinf(u + uStep);       // y
            _sphereVerticies[xIndex + 2] = fRadius * sinf(v);                         // z
            points++;
            
            xIndex = points * 3;
            _sphereVerticies[xIndex] = fRadius * cosf(v + vStep) * cosf(u);                  // x
            _sphereVerticies[xIndex + 1] = fRadius * cosf(v + vStep) * sinf(u);            // y
            _sphereVerticies[xIndex + 2] = fRadius * sinf(v + vStep);                      // z
            points++;
            
            xIndex = points * 3;
            _sphereVerticies[xIndex] = fRadius * cosf(v + vStep) * cosf(u + uStep);           // x
            _sphereVerticies[xIndex + 1] = fRadius * cosf(v + vStep) * sinf(u + uStep);     // y
            _sphereVerticies[xIndex + 2] = fRadius * sinf(v + vStep);                       // z
            points++;
        }
    }
    *verticesCount = points;
    vertex_t* _vertices_ = (vertex_t*)malloc(*verticesCount * sizeof(vertex_t));
    unsigned int i;
    for (i = 0; i < *verticesCount; i++) {
        _vertices_[i].position[0] = _sphereVerticies[i];
        _vertices_[i].normal[0] = _sphereVerticies[i];
        _vertices_[i].position[1] = _sphereVerticies[i+1];
        _vertices_[i].normal[1] = _sphereVerticies[i+1];
        _vertices_[i].position[2] = _sphereVerticies[i+2];
        _vertices_[i].normal[2] = _sphereVerticies[i+2];
        normalizeVec(_vertices_[i].normal);
    }
    *vertices = _vertices_;
    *indicesCount = index;
    GLuint* _indices_ = (GLuint*)malloc(*indicesCount * sizeof(GLuint));
    for (i = 0; i < index; i++) {
        _indices_[i] = _triangleIndices[i];
    }
    *indices = _indices_;
}

- (void)setupWithRadius:(GLfloat)radius andParts:(GLuint) parts
{
    glEnable(GL_CULL_FACE);
    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);
    
    _numPoints = createSphere(sphereVerticies, sphereNormals, triangleIndices, sphereTexCoords, radius, 16.0f);
    
    size_t sizeofStuff = 0;
    sizeofStuff = sizeof(sphereVerticies);
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(sphereVerticies), sphereVerticies, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_normalBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _normalBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(sphereNormals), sphereNormals, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_texCoordBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _texCoordBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(sphereTexCoords), sphereTexCoords, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    sizeofStuff = sizeof(triangleIndices);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(triangleIndices), triangleIndices, GL_STATIC_DRAW);
    
    // New lines (were previously in draw)
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, (const GLvoid *) 0);
    
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 0, (const GLvoid *) 0);
    
    glBindVertexArrayOES(0);
}

- (void)setupNew2
{
    //glEnable(GL_CULL_FACE);
    //glGenVertexArraysOES(1, &_vertexArray);
    //glBindVertexArrayOES(_vertexArray);
    
    createSphere2(&_vertices, &_vertexCount, &_indices, &_indexCount, 1.0f, 20.0f);
    
    /*glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(), sphereVerticies, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(triangleIndices), triangleIndices, GL_STATIC_DRAW);
    
    // New lines (were previously in draw)
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, (const GLvoid *) 0);
    
    glBindVertexArrayOES(0);*/
    [self configureVertexArrayObject];
}

- (void)drawNew
{
    glBindVertexArrayOES(_vertexArray);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    // New lines (were previously in draw)
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, (const GLvoid *) 0);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    
    glBindBuffer(GL_ARRAY_BUFFER, _normalBuffer);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 0, (const GLvoid *) 0);
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    
    glDrawElements(GL_TRIANGLES, (int)(_numPoints*1.5), GL_UNSIGNED_INT, 0);
    //glDrawElements(GL_TRIANGLES, _indexCount, GL_UNSIGNED_INT, 0);
}

@end
