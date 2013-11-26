//
//  UIButton+Key.m
//  GGTranslate
//
//  Created by Kira on 11/22/13.
//  Copyright (c) 2013 Kira. All rights reserved.
//

#import "UIButton+Key.h"
#import <objc/runtime.h>

@implementation UIButton (Key)

static void *name;

- (void)setTempKey:(NSString *)tempKey
{
    objc_setAssociatedObject(self, name, tempKey, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)tempKey
{
    return (NSString *)objc_getAssociatedObject(self, name);
}

@end
