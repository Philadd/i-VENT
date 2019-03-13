//
//  NickNameViewController.m
//  YSZfarm
//
//  Created by 杭州轨物科技有限公司 on 2018/3/2.
//  Copyright © 2018年 yusz. All rights reserved.
//

#import "NickNameViewController.h"
#import "TouchTableView.h"
#import "NickNameTableViewCell.h"

NSString *const CellIdentifier_NickName = @"CellID_NickName";
NSString *const CellNibName_NickName = @"NickNameTableViewCell";

@interface NickNameViewController ()
@property (nonatomic, strong) UITableView *myTableView;
@end

@implementation NickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:yColor_back];

    _myTableView = ({
        TouchTableView *tableView = [[TouchTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerNib:[UINib nibWithNibName:CellNibName_NickName
                                              bundle:nil] forCellReuseIdentifier:CellIdentifier_NickName];
        
        [self.view addSubview:tableView];
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        
        //tableView.scrollEnabled = NO;
        if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([tableView respondsToSelector:@selector(setLayoutMargins:)])  {
            [tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        tableView;
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NickNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier_NickName];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellNibName_NickName owner:self options:nil] lastObject];
        }
        cell.nickNameTF.text = _nickName;
        [cell.nickNameTF becomeFirstResponder];
        return cell;
    }
    return nil;
}

//section头部间距

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;//section头部高度
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    view.backgroundColor = [UIColor clearColor];
    return view ;
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

@end
