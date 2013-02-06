//
//  EBPackerNode.h
//  ExampleMosaicUI
//
//  Created by Ezequiel Becerra on 2/5/13.
//  Copyright (c) 2013 betzerra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EBPackerNode : NSObject{
    
}

@property (assign) CGRect frame;
@property (assign) BOOL isUsed;
@property (strong) EBPackerNode *right;
@property (strong) EBPackerNode *down;

-(id)initWithRect:(CGRect)aRect;

@end
