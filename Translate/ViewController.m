//
//  ViewController.m
//  Translate
//
//  Created by Kira on 11/25/13.
//  Copyright (c) 2013 Kira. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "AppDelegate+ReviewAlert.h"
#import "ASIHTTPRequest.h"
#import <QuartzCore/QuartzCore.h>
#import "UIButton+Key.h"
#import "FavListViewController.h"
#import "JSONKit.h"
#import <AVFoundation/AVFoundation.h>
#import "BWStatusBarOverlay.h"
#import "def.h"
#import "PlayerManager.h"
#import "HudController.h"
#import "IOSHelper.h"

#define MY_BANNER_UNIT_ID @"a1529f10250c167"   

#define kMaxTextLength 100

NSString *UUIDCreate()
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(NSString*)uuid_string_ref];
    
    CFRelease(uuid_string_ref);
    return uuid;
}

@interface ViewController ()

@end

@implementation ViewController

- (id)init
{
    self = [super initWithNibName:@"ViewController" bundle:nil];
    if (self) {
        // Custom initialization
        mutiData = [[NSMutableData alloc] init];
        NSString *content = @"Afrikaans.af,Albanian.sq,Arabic.ar,Azerbaijani.az,Basque.eu,Bengali.bn,Belarusian.be,Bulgarian.bg,Catalan.ca,Chinese Simplified.zh-CN,Chinese Traditional.zh-TW,Croatian.hr,Czech.cs,Danish.da,Dutch.nl,English.en,Esperanto.eo,Estonian.et,Filipino.tl,Finnish.fi,French.fr,Galician.gl,Georgian.ka,German.de,Greek.el,Gujarati.gu,Haitian Creole.ht,Hebrew.iw,Hindi.hi,Hungarian.hu,Icelandic.is,Indonesian.id,Irish.ga,Italian.it,Japanese.ja,Kannada.kn,Korean.ko,Latin.la,Latvian.lv,Lithuanian.lt,Macedonian.mk,Malay.ms,Maltese.mt,Norwegian.no,Persian.fa,Polish.pl,Portuguese.pt,Romanian.ro,Russian.ru,Serbian.sr,Slovak.sk,Slovenian.sl,Spanish.es,Swahili.sw,Swedish.sv,Tamil.ta,Telugu.te,Thai.th,Turkish.tr,Ukrainian.uk,Urdu.ur,Vietnamese.vi,Welsh.cy,Yiddish.yi,Automatic.auto";
        
        supportLanguage = [[content componentsSeparatedByString:@","] retain];
        NSArray *tmpFav = [[NSUserDefaults standardUserDefaults] objectForKey:kFavArray];
        favTextArray = [[NSMutableArray alloc] initWithArray:tmpFav];
        soundData = nil;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"setup"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"setup"];
        [[NSUserDefaults standardUserDefaults] setInteger:[supportLanguage count]-1 forKey:kSrcIndex];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kDesIndex];
    }
    int srcIndex = [[NSUserDefaults standardUserDefaults] integerForKey:kSrcIndex];
    [_picker selectRow:srcIndex inComponent:0 animated:NO];
    NSString *para = [supportLanguage objectAtIndex:srcIndex];
    [_btnSrc setTitle:NSLocalizedString([self contryOf:para], nil) forState:UIControlStateNormal];
    [_btnSrc setTempKey:[self keyOf:para]];
    
    int desIndex = [[NSUserDefaults standardUserDefaults] integerForKey:kDesIndex];
    [_picker selectRow:desIndex inComponent:1 animated:NO];
    para = [supportLanguage objectAtIndex:desIndex];
    [_btnDes setTitle:NSLocalizedString([self contryOf:para], nil) forState:UIControlStateNormal];
    [_btnDes setTempKey:[self keyOf:para]];
    
    //样式
    _srcTextView.layer.cornerRadius = 8.0;
    _srcTextView.layer.borderColor = [UIColor blackColor].CGColor;
    _srcTextView.layer.borderWidth = 2.0;
    _srcTextView.layer.shadowColor = [UIColor blackColor].CGColor;
    _srcTextView.layer.shadowOpacity = 0.7;
    
    _resultTextView.layer.cornerRadius = 8.0;
    _resultTextView.layer.borderColor = [UIColor blackColor].CGColor;
    _resultTextView.layer.borderWidth = 2.0;
    _resultTextView.layer.shadowColor = [UIColor blackColor].CGColor;
    _resultTextView.layer.shadowOpacity = 0.7;
    
    _btnSrc.layer.borderWidth = 2.0;
    _btnSrc.layer.borderColor = [UIColor blackColor].CGColor;
    [_btnSrc setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    _btnSrc.layer.cornerRadius = 5.0;
    _btnDes.layer.borderWidth = 2.0;
    _btnDes.layer.borderColor = [UIColor blackColor].CGColor;
    _btnDes.layer.cornerRadius = 5.0;
    [_btnDes setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"noiad"]) {
        [_btnBuy removeFromSuperview];
        self.btnBuy = nil;
        self.btnSound.frame = CGRectOffset(self.btnSound.frame, -70, 0);
        self.btnFav.frame = CGRectOffset(self.btnFav.frame, -50, 0);
        self.btnFavList.frame = CGRectOffset(self.btnFavList.frame, -20, 0);
    } else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noiadFinish:) name:@"noiad" object:nil];
    }
}

- (void)noiadFinish:(NSNotification *)noti
{
    [_btnBuy removeFromSuperview];
    self.btnBuy = nil;
    self.btnSound.frame = CGRectOffset(self.btnSound.frame, -70, 0);
    self.btnFav.frame = CGRectOffset(self.btnFav.frame, -50, 0);
    self.btnFavList.frame = CGRectOffset(self.btnFavList.frame, -20, 0);
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if ([_pickerView superview] == nil) {
        _pickerView.frame = CGRectMake(0, self.view.frame.size.height-_pickerView.frame.size.height, _pickerView.frame.size.width, _pickerView.frame.size.height);
        [self.view addSubview:_pickerView];
        _pickerView.hidden = YES;
    }
    UIImageView *bk = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bk.png"]];
    bk.frame = self.view.bounds;
    [self.view insertSubview:[bk autorelease] atIndex:0];
    
}

- (void)dealloc
{
    self.textNoteLabel = nil;
    self.btnBuy = nil;
    self.btnDes = nil;
    self.btnFav = nil;
    self.btnFavList = nil;
    self.btnSound = nil;
    self.btnSrc = nil;
    self.btnTranslate = nil;
    [supportLanguage release];
    [mutiData release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnTranslateTap:(id)sender {
    [_srcTextView resignFirstResponder];
    [self translateSrcText];
}

- (IBAction)srcContryTap:(id)sender {
    [self responseContryButton:(UIButton *)sender];
}

- (IBAction)desContryTap:(id)sender {
    [self responseContryButton:(UIButton *)sender];
}

- (IBAction)btnPickerDone:(id)sender {
    CATransition *tran = [CATransition animation];
    tran.duration = 0.35;
    tran.type = kCATransitionPush;
    tran.subtype = kCATransitionFromBottom;
    [_pickerView.layer addAnimation:tran forKey:nil];
    [_pickerView setHidden:YES];
}

- (IBAction)btnPlaySoundTap:(id)sender {
    if (soundData != nil && [soundData length] != 0) {
        [[PlayerManager shareInterface] playSoundData:soundData];
        return;
    }
    //ht tp://translate.google.com/translate_tts?tl=en&q=text
    NSString *content = [[[[self.rawResultString objectFromJSONString] objectAtIndex:0] objectAtIndex:0] objectAtIndex:0];
//    content = [content stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *key = [_btnDes tempKey];
    NSString *str = [NSString stringWithFormat:@"http://translate.google.com/translate_tts?ie=UTF-8&tl=%@&q=%@", key, [content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *soundURL = [NSURL URLWithString:str];
    
    //    [[HudController shareHudController] showWithLabel:@"Loading..."];
    soundData = [[NSMutableData alloc] init];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:soundURL];
    [request setRequestMethod:@"GET"];
    [request setDidFinishSelector:@selector(ttsDidFinish:)];
    [request setDidFailSelector:@selector(ttsDidFail:)];
    [request setDelegate:self];
    [request setDidReceiveDataSelector:@selector(ttsRequest:didReceiveData:)];
    [request startAsynchronous];
}

- (IBAction)btnSwapTap:(id)sender
{
    if ([[_btnSrc tempKey] isEqualToString:@"auto"]) {
        return ;
    }
    int tmpSrc = [[NSUserDefaults standardUserDefaults] integerForKey:kSrcIndex];
    int tmpDes = [[NSUserDefaults standardUserDefaults] integerForKey:kDesIndex];
    [[NSUserDefaults standardUserDefaults] setInteger:tmpDes forKey:kSrcIndex];
    [[NSUserDefaults standardUserDefaults] setInteger:tmpSrc forKey:kDesIndex];
    
    NSString *con = [self contryOf:[supportLanguage objectAtIndex:tmpDes]];
    NSString *key = [self keyOf:[supportLanguage objectAtIndex:tmpDes]];
    [_btnSrc setTitle:NSLocalizedString(con, Nil) forState:UIControlStateNormal];
    [_btnSrc setTempKey:key];
    
    con = [self contryOf:[supportLanguage objectAtIndex:tmpSrc]];
    key = [self keyOf:[supportLanguage objectAtIndex:tmpSrc]];
    [_btnDes setTitle:NSLocalizedString(con, Nil) forState:UIControlStateNormal];
    [_btnDes setTempKey:key];
    
    [_picker selectRow:tmpSrc inComponent:1 animated:YES];
    [_picker selectRow:tmpDes inComponent:0 animated:YES];
}

- (IBAction)btnFavTap:(id)sender {
    if ([[_srcTextView text] length] == 0 || [[_resultTextView text] length] == 0) {
        [BWStatusBarOverlay showSuccessWithMessage:NSLocalizedString(@"Content Error", nil) duration:2.0 animated:YES];
        return ;
    }
    
    if (soundData != nil && [soundData length] > 0) {
        NSString *fPath = [self URLWithUUID];
        if (![soundData writeToURL:[NSURL fileURLWithPath:fPath] atomically:YES]) {
            NSLog(@"%s -> write error", __FUNCTION__);
        }
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[_srcTextView text], kSrcText, [_resultTextView text], kDesText, [_btnSrc tempKey], kSrcKey, [_btnDes tempKey], kDesKey,fPath,kSoundPath,nil];
        [favTextArray addObject:dic];
    } else {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[_srcTextView text], kSrcText, [_resultTextView text], kDesText, [_btnSrc tempKey], kSrcKey, [_btnDes tempKey], kDesKey,nil];
        [favTextArray addObject:dic];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:favTextArray forKey:kFavArray];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)URLWithUUID
{
    NSString *uuidFile = [UUIDCreate() stringByAppendingFormat:@".mp3"];
    NSString *docu = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [docu stringByAppendingPathComponent:uuidFile];
    return filePath;
}

- (IBAction)btnFavShowTap:(id)sender {
    FavListViewController *list = [[FavListViewController alloc] initWithList:favTextArray];
    list.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:[list autorelease] animated:YES completion:nil];
}

- (void)responseContryButton:(UIButton *)sender
{
    if (!_pickerView.hidden) {
        return;
    }
    [_srcTextView resignFirstResponder];
    CATransition *tran = [CATransition animation];
    tran.duration = 0.35;
    tran.type = kCATransitionMoveIn;
    tran.subtype = kCATransitionFromTop;
    [_pickerView.layer addAnimation:tran forKey:nil];
    _pickerView.hidden = NO;
}

- (void)translateSrcText
{
    if ([[_srcTextView text] length] > kMaxTextLength) {
        [BWStatusBarOverlay showSuccessWithMessage:NSLocalizedString(@"Content Error", nil) duration:2.0 animated:YES];
        return;
    }
    [[HudController shareHudController] showWithLabel:@"Loading..."];
    //翻译文字是清空soundData
    [soundData release];
    soundData = nil;
    
    NSString *duzi = [_srcTextView text];
    //translate.google.cn/translate_a/t?client=t&sl=zh-CN&tl=ja&hl=zh-CN&sc=2&ie=UTF-8&oe=UTF-8&oc=1&prev=btn&ssel=6&tsel=3&q=%E4%BD%A0%E5%A6%88%E5%A6%88%E5%A5%BD%E5%90%97
    NSString *str = [NSString stringWithFormat:@"http://translate.google.cn/translate_a/t?client=t&sl=%@&tl=%@&hl=zh-CN&sc=2&ie=UTF-8&oe=UTF-8&oc=1&prev=btn&ssel=6&tsel=3&q=%@", [_btnSrc tempKey], [_btnDes tempKey],[duzi stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:str]];
    [request setRequestMethod:@"GET"];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestDidFinish:)];
    [request setDidReceiveDataSelector:@selector(request:didReceiveData:)];
    [request setDidFailSelector:@selector(requestDidFail:)];
    [request setTimeOutSeconds:20];
    [request startAsynchronous];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text UTF8String][0] == '\n') {
        [textView resignFirstResponder];
        [self translateSrcText];
        return NO;
    }
    self.textNoteLabel.text = [NSString stringWithFormat:@"%d/%d", textView.text.length, kMaxTextLength];
    return YES;
}

- (void)requestDidFail:(ASIHTTPRequest *)request
{
    [[HudController shareHudController] hudWasHidden];
    [BWStatusBarOverlay showSuccessWithMessage:NSLocalizedString(@"Network Timeout", nil) duration:3.0 animated:YES];
}

- (void)requestDidFinish:(ASIHTTPRequest *)request
{
    //    [[HudController shareHudController] hudWasHidden];
    NSString *str = [[NSString alloc] initWithData:mutiData encoding:NSUTF8StringEncoding];
    [mutiData release];
    mutiData = [[NSMutableData alloc] init];
    str = [str stringByReplacingOccurrencesOfString:@",,," withString:@","];
    str = [str stringByReplacingOccurrencesOfString:@",," withString:@","];
    str = [str stringByReplacingOccurrencesOfString:@"[," withString:@"["];
    self.rawResultString = str;
    _resultTextView.text = [[[[str objectFromJSONString] objectAtIndex:0] objectAtIndex:0] objectAtIndex:0];
    [self btnPlaySoundTap:nil];
}

- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    [mutiData appendData:data];
}

#pragma mark - TTS Request

- (NSString *)pathForSound
{
    return [NSTemporaryDirectory() stringByAppendingPathComponent:@"temp.mp3"];
}

- (void)ttsDidFinish:(ASIHTTPRequest *)request
{
    [[HudController shareHudController] hudWasHidden];
//    [[AppDelegate interface] scheduleAlertAlone];
    if ([soundData length] == 0) {
        //没有tts
        self.btnSound.hidden = YES;
    } else {
        self.btnSound.hidden = NO;
        [[PlayerManager shareInterface] playSoundData:soundData];
    }
}

- (void)ttsDidFail:(ASIHTTPRequest *)request
{
    NSLog(@"%s -> %@", __FUNCTION__, [request error]);
    [[HudController shareHudController] hudWasHidden];
    [BWStatusBarOverlay showSuccessWithMessage:NSLocalizedString(@"Network Timeout", nil) duration:3.0 animated:YES];
}

- (void)ttsRequest:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    NSLog(@"%s -> ", __FUNCTION__);
    [soundData appendData:data];
}

#pragma mark - Picker View

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [supportLanguage count] - component;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *para = [supportLanguage objectAtIndex:row];
    NSString *con = [self contryOf:para];
    return NSLocalizedString(con, nil);
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        NSString *con = [self contryOf:[supportLanguage objectAtIndex:row]];
        NSString *key = [self keyOf:[supportLanguage objectAtIndex:row]];
        [_btnSrc setTitle:NSLocalizedString(con, nil) forState:UIControlStateNormal];
        [_btnSrc setTempKey:key];
        [[NSUserDefaults standardUserDefaults] setInteger:row forKey:kSrcIndex];
    }
    else if (component == 1) {
        NSString *con = [self contryOf:[supportLanguage objectAtIndex:row]];
        NSString *key = [self keyOf:[supportLanguage objectAtIndex:row]];
        [_btnDes setTitle:NSLocalizedString(con, nil) forState:UIControlStateNormal];
        [_btnDes setTempKey:key];
        [[NSUserDefaults standardUserDefaults] setInteger:row forKey:kDesIndex];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)contryOf:(NSString *)para
{
    NSArray *arr = [para componentsSeparatedByString:@"."];
    return [arr objectAtIndex:0];
}

- (NSString *)keyOf:(NSString *)para
{
    NSArray *arr = [para componentsSeparatedByString:@"."];
    return [arr objectAtIndex:1];
}

#pragma mark - NO IAD

- (IBAction)btnBuyTap:(id)sender
{
    [IOSHelper buyNoIad];
}


@end