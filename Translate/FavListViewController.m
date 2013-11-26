//
//  FavListViewController.m
//  Translate
//
//  Created by Kira on 11/25/13.
//  Copyright (c) 2013 Kira. All rights reserved.
//

#import "FavListViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "def.h"
#import "PlayerManager.h"
@interface FavListViewController ()

@end

@implementation FavListViewController

- (id)initWithList:(NSMutableArray *)arr
{
    self = [super initWithNibName:@"FavListViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.favList = arr;
    }
    return self;
}

- (void)dealloc
{
    self.favList = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    UIImageView *bk = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bk.png"]];
    bk.frame = self.view.bounds;
    [self.view insertSubview:[bk autorelease] atIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.favList count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"favcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(298, 0, 22, 22)];
        label.backgroundColor = [UIColor clearColor];
        label.tag = 100;
        label.font = [UIFont systemFontOfSize:12.0];
        [cell.contentView addSubview:label];
        [label release];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 264, 40)];
        label1.backgroundColor = [UIColor clearColor];
        label1.numberOfLines = 0;
        label1.tag = 101;
        label1.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:label1];
        [label1 release];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 264, 40)];
        label2.numberOfLines = 0;
        label2.textColor = [UIColor magentaColor];
        label2.backgroundColor = [UIColor clearColor];
        label2.tag = 102;
        label2.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:label2];
        [label2 release];

        UIImageView *but = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"speak.png"]];
        but.frame = CGRectMake(278, 50, 25, 25);
        [cell.contentView addSubview:[but autorelease]];
    }
    UILabel *NOLabel = (UILabel *)[cell.contentView viewWithTag:100];
    NOLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
    
    NSDictionary *dic = [self.favList objectAtIndex:indexPath.row];
    
    UILabel *labelSrc = (UILabel *)[cell.contentView viewWithTag:101];
    labelSrc.text = [dic objectForKey:kSrcText];
    
    UILabel *labelDes = (UILabel *)[cell.contentView viewWithTag:102];
    labelDes.text = [dic objectForKey:kDesText];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 60.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(btnDismisTap) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:NSLocalizedString(@"Dismiss", nil) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(10, 5, 300, 40);
    button.layer.borderColor = [UIColor orangeColor].CGColor;
    button.layer.borderWidth = 2.0;
    [view addSubview:button];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 48, 300, 12)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor orangeColor];
    label.text = NSLocalizedString(@"Tap cell to speak out the words!", nil);
    label.textAlignment = 1;
    label.font = [UIFont systemFontOfSize:13.0];
    [view addSubview:label];
    [label autorelease];
    return [view autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    label.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.5];
    label.textColor = [UIColor orangeColor];
    label.textAlignment = 1;
    label.text = NSLocalizedString(@"Favorites", nil);
    label.font = [UIFont boldSystemFontOfSize:20.0];
    [view addSubview:[label autorelease]];
    return [view autorelease];
}


- (void)btnDismisTap
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [self.favList objectAtIndex:indexPath.row];
    NSString *fPath = [dic objectForKey:kSoundPath];
    NSURL *url = [NSURL fileURLWithPath:fPath];
    [[PlayerManager shareInterface] playSound:url];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *dic = [self.favList objectAtIndex:indexPath.row];
        NSString *str = [dic objectForKey:kSoundPath];
        if (![[NSFileManager defaultManager] removeItemAtPath:str error:nil]) {
            NSLog(@"%s -> remove item error", __FUNCTION__);
        }
        [self.favList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [[NSUserDefaults standardUserDefaults] setObject:self.favList forKey:kFavArray];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
