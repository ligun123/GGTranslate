//
//  ViewController.h
//  Translate
//
//  Created by Kira on 11/25/13.
//  Copyright (c) 2013 Kira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"

@interface ViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate, GADBannerViewDelegate>
{
    NSMutableData *soundData;
    NSMutableData *mutiData;
    NSArray *supportLanguage;
    NSMutableArray *favTextArray;
    GADBannerView *admobView;
}

- (IBAction)btnTranslateTap:(id)sender;
- (IBAction)srcContryTap:(id)sender;
- (IBAction)desContryTap:(id)sender;
- (IBAction)btnPickerDone:(id)sender;
- (IBAction)btnPlaySoundTap:(id)sender;
- (IBAction)btnSwapTap:(id)sender;
- (IBAction)btnFavTap:(id)sender;
- (IBAction)btnFavShowTap:(id)sender;

@property (nonatomic, retain) IBOutlet UITextView *srcTextView;
@property (nonatomic, retain) IBOutlet UIButton *btnSrc;
@property (nonatomic, retain) IBOutlet UIButton *btnDes;
@property (nonatomic, retain) IBOutlet UIButton *btnTranslate;
@property (nonatomic, retain) IBOutlet UIButton *btnBuy;
@property (nonatomic, retain) IBOutlet UIView *pickerView;
@property (nonatomic, retain) IBOutlet UIPickerView *picker;
@property (nonatomic, retain) IBOutlet UITextView *resultTextView;
@property (nonatomic, copy) NSString *rawResultString;

@property (nonatomic, retain) IBOutlet UIButton *btnSound;
@property (nonatomic, retain) IBOutlet UIButton *btnFav;
@property (nonatomic, retain) IBOutlet UIButton *btnFavList;
@property (nonatomic, retain) IBOutlet UILabel *textNoteLabel;
@end
