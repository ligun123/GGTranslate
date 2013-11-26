//
//  PlayerManager.h
//  GGTranslate
//
//  Created by Kira on 11/25/13.
//  Copyright (c) 2013 Kira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface PlayerManager : NSObject <AVAudioPlayerDelegate>

+ (id)shareInterface;

- (void)playSound:(NSURL *)url;

- (void)playSoundData:(NSData *)data;

@end
