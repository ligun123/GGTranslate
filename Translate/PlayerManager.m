//
//  PlayerManager.m
//  GGTranslate
//
//  Created by Kira on 11/25/13.
//  Copyright (c) 2013 Kira. All rights reserved.
//

#import "PlayerManager.h"

static PlayerManager *pl = nil;

@implementation PlayerManager

+ (id)shareInterface
{
    if (pl == nil) {
        pl = [[PlayerManager alloc] init];
    }
    return pl;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    player.delegate = nil;
    [player release];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    player.delegate = nil;
    [player release];
}

- (void)dealloc
{
    [super dealloc];
}

- (void)playSound:(NSURL *)url
{
    NSError *err = nil;
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&err];
    if (err) {
        NSLog(@"%s -> %@", __FUNCTION__, err);
    }
    player.delegate = self;
    [player prepareToPlay];
    [player play];
}

- (void)playSoundData:(NSData *)data
{
    NSError *err = nil;
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:data error:&err];
    if (err) {
        NSLog(@"%s -> %@", __FUNCTION__, err);
    }
    player.delegate = self;
    [player prepareToPlay];
    [player play];
}

@end
