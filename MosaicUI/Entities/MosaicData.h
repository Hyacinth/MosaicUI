//
//  MosaicModule.h
//  MosaicUI
//
//  Created by Ezequiel Becerra on 10/21/12.
//  Copyright (c) 2012 betzerra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EBPacker.h"

@interface MosaicData : NSObject <EBPackerBlockProtocol>{
    NSString *imageFilename;
    NSString *title;
    NSInteger moduleSize;
}

-(id)initWithDictionary:(NSDictionary *)aDict;

@property (strong) NSString *imageFilename;
@property (strong) NSString *title;
@property (readwrite) NSInteger moduleSize;

//  EBPackerBlockProtocol
@property (strong) EBPackerNode *fit;
@property (assign) CGSize size;

@end
