//
//  EBPacker.h
//  ExampleMosaicUI
//
//  Created by Ezequiel Becerra on 2/5/13.
//  Copyright (c) 2013 betzerra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EBPackerNode.h"
#import "EBPackerBlockProtocol.h"

@interface EBPacker : NSObject{

}

@property (strong) EBPackerNode *root;

-(id)initWithSize:(CGSize)initialSize;
-(void)fit:(NSArray *)blocks;
-(EBPackerNode *)splitNodeWithNode:(EBPackerNode *)node size:(CGSize)size;
-(EBPackerNode *)findNodeFromNode:(EBPackerNode *)node size:(CGSize)size;

@end
