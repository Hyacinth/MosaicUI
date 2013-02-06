//
//  EBPackerBlockProtocol.h
//  ExampleMosaicUI
//
//  Created by Ezequiel A Becerra on 2/5/13.
//  Copyright (c) 2013 betzerra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EBPackerNode.h"

@protocol EBPackerBlockProtocol <NSObject>

//  EBPackerNode
-(void)setFit:(EBPackerNode *)aNode;
-(EBPackerNode *)fit;

//  Size
-(void)setSize:(CGSize)aSize;
-(CGSize)size;

@optional
-(id)initWithSize:(CGSize)aSize;

@end
