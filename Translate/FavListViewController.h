//
//  FavListViewController.h
//  Translate
//
//  Created by Kira on 11/25/13.
//  Copyright (c) 2013 Kira. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray *favList;

- (id)initWithList:(NSMutableArray *)arr;

@end
