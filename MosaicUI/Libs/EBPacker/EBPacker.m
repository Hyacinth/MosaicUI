//
//  EBPacker.m
//  ExampleMosaicUI
//
//  Created by Ezequiel Becerra on 2/5/13.
//  Copyright (c) 2013 betzerra. All rights reserved.
//

#import "EBPacker.h"

@implementation EBPacker
@synthesize root;

-(id)initWithSize:(CGSize)initialSize{
    self = [self init];
    if (self){
        CGRect initialRect = CGRectMake(0, 0, initialSize.width, initialSize.height);
        self.root = [[EBPackerNode alloc] initWithRect:initialRect];
    }
    return self;
}

-(void)fit:(NSArray *)blocks{
    for (id <EBPackerBlockProtocol> aBlock in blocks){
        EBPackerNode *aNode = [self findNodeFromNode:self.root size:aBlock.size];
        if (aNode){
            aBlock.fit = [self splitNodeWithNode:aNode size:aBlock.size];
        }
    }
}

-(EBPackerNode *)findNodeFromNode:(EBPackerNode *)node size:(CGSize)size{
    EBPackerNode *retVal = nil;
    
    if (node.isUsed){
        retVal = [self findNodeFromNode:node.right size:size];
        if (!retVal){
            retVal = [self findNodeFromNode:node.down size:size];
        }
    }else if (node.frame.size.width >= size.width && node.frame.size.height >= size.height){
        retVal = node;
    }
    return retVal;
}


-(EBPackerNode *)splitNodeWithNode:(EBPackerNode *)node size:(CGSize)size{
    node.isUsed = YES;
    CGRect rightNodeRect = CGRectMake(node.frame.origin.x + size.width,
                                      node.frame.origin.y,
                                      node.frame.size.width - size.width,
                                      size.height);
    node.right = [[EBPackerNode alloc] initWithRect:rightNodeRect];
    
    CGRect downNodeRect = CGRectMake(node.frame.origin.x,
                                     node.frame.origin.y + size.height,
                                     node.frame.size.width,
                                     node.frame.size.height - size.height);
    node.down = [[EBPackerNode alloc] initWithRect:downNodeRect];
    
    return node;
}

@end
