//
//  Shader.fsh
//  TwitterBubblesIOS
//
//  Created by Buddi on 03.02.14.
//  Copyright (c) 2014 BudWorks. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
