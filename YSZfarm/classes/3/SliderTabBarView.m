//
//  SliderTabBarView.m
//  YSZfarm
//
//  Created by Mac on 2017/8/3.
//  Copyright © 2017年 yusz. All rights reserved.
//

#import "SliderTabBarView.h"
#import "DetailTableCell.h"
#import "FarmDetailViewController.h"
#import "FarmDatabase.h"
#import "SwitcherTableViewCell.h"
#import "AFHTTPSessionManager.h"


#define TOPHEIGHT 50
#define indexSensor _sensorList[indexPath.row]

NSString *const TCellIdentifier = @"cellIDfourth";
NSString *const TTableCellNibName = @"DetailTableCell";

NSString *const TTCellIdentifier = @"cellIDfifth";
NSString *const TTTableCellNibName = @"SwitcherTableViewCell";

@interface SliderTabBarView()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

///@brife SliderTabBarView的Frame
@property (assign) CGRect mViewFrame;

///@brife 下方的ScrollView
@property (strong, nonatomic) UIScrollView *scrollView;

///@brife 上方的按钮数组
@property (strong, nonatomic) NSMutableArray *topViews;

///@brife TableViews的数据源
@property (strong, nonatomic) NSMutableArray *dataSource;

///@brife 当前选中页数
@property (assign) NSInteger currentPage;

///@brife 下面滑动的View
@property (strong, nonatomic) UIView *slideView;

///@brife 上方的view
@property (strong, nonatomic) UIView *topMainView;

///@brife 上方的ScrollView
@property (strong, nonatomic) UIScrollView *topScrollView;

///@brife 视频控制界面
@property (strong,nonatomic) UIView *controlView;

///@brife 摄像头移动操作界面
@property (strong,nonatomic) UIView *ptzView;

///@brife 摄像上下左右移动操作按钮
@property (strong,nonatomic) UIButton *ptzLeftBtn;
@property (strong,nonatomic) UIButton *ptzRightBtn;
@property (strong,nonatomic) UIButton *ptzUpBtn;
@property (strong,nonatomic) UIButton *ptzDownBtn;

@end

@implementation SliderTabBarView

- (instancetype)initWithFrame:(CGRect)frame WithCount:(NSInteger)count{
    self = [super initWithFrame:frame];
    
    if (self) {
        _mViewFrame = frame;
        _tabCount = count;
        _topViews = [[NSMutableArray alloc] init];
        _scrollTableViews = [[NSMutableArray alloc] init];
        
        NSArray *deviceList = [[FarmDatabase shareInstance] allDevices];
        [deviceList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([[NSString stringWithFormat:@"%@",[obj objectForKey:@"deviceId"]] isEqualToString:/*@"200006872"*/@"1746"]) {
                _sensorList = [obj objectForKey:@"sensorList"];
            }
        }];
        
        [self initScrollView];
        
        [self initTopTabs];
        
        [self initDownTables];
        
        [self initDownControlView];
        
    }
    
    return self;
}

#pragma mark -- 实例化ScrollView
- (void)initScrollView{
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,  TOPHEIGHT, _mViewFrame.size.width, _mViewFrame.size.height - TOPHEIGHT)];
    _scrollView.contentSize = CGSizeMake(_mViewFrame.size.width * _tabCount, _mViewFrame.size.height - TOPHEIGHT);
    _scrollView.backgroundColor = [UIColor whiteColor];
    
    _scrollView.pagingEnabled = YES;
    
    _scrollView.delegate = self;
    
    [self addSubview:_scrollView];
}

- (void)initTopTabs{
    CGFloat width = _mViewFrame.size.width / 6;
    
    if(self.tabCount <=6){
        width = _mViewFrame.size.width / self.tabCount;
    }
    
    _topMainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _mViewFrame.size.width, TOPHEIGHT)];
    
    _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _mViewFrame.size.width, TOPHEIGHT)];
    
    _topScrollView.showsHorizontalScrollIndicator = NO;
    
    _topScrollView.showsVerticalScrollIndicator = YES;
    
    _topScrollView.bounces = NO;
    
    _topScrollView.delegate = self;
    
    if (_tabCount >= 6) {
        _topScrollView.contentSize = CGSizeMake(width * _tabCount, TOPHEIGHT);
        
    } else {
        _topScrollView.contentSize = CGSizeMake(_mViewFrame.size.width, TOPHEIGHT);
    }
    
    
    [self addSubview:_topMainView];
    
    [_topMainView addSubview:_topScrollView];
    
    
    for (int i = 0; i <_tabCount; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * width, 0, width, TOPHEIGHT)];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, TOPHEIGHT)];
        button.tag = i;
        button.backgroundColor = [UIColor darkGrayColor];
        if (i == 0) {
            [button setTitle:[NSString stringWithFormat:@"设备数据"] forState:UIControlStateNormal];
        }else if (i == 1){
            [button setTitle:[NSString stringWithFormat:@"视频控制"] forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(tabButton:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        [_topViews addObject:view];
        [_topScrollView addSubview:view];
    }
}

#pragma mark -- 点击顶部按钮触发的动作
-(void)tabButton:(id)sender{
    
    UIButton *button = sender;
    [_scrollView setContentOffset:CGPointMake(button.tag * _mViewFrame.size.width, 0) animated:YES];
    
}

#pragma mark --初始化下方的TableView和ControlView
-(void)initDownTables{
    
    for (int i = 0; i < _tabCount; i++) {
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(i * _mViewFrame.size.width, 0, _mViewFrame.size.width, _mViewFrame.size.height - TOPHEIGHT - 30)];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tag = i;
        
        [tableView registerNib:[UINib nibWithNibName:TTableCellNibName bundle:nil] forCellReuseIdentifier:TCellIdentifier];
        
        [_scrollTableViews addObject:tableView];
        [_scrollView addSubview:tableView];
    }
    
}

- (void)initDownControlView{
    
    _controlView = [[UIView alloc] initWithFrame:CGRectMake(1 * _mViewFrame.size.width, 0, _mViewFrame.size.width, _mViewFrame.size.height - TOPHEIGHT)];
    NSInteger buttonSideLength = 64;
    _controlView.backgroundColor = [UIColor whiteColor];
    
    UIButton *ptzBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ptzBtn.frame = CGRectMake((_mViewFrame.size.width - buttonSideLength) / 2.0, (_mViewFrame.size.height - buttonSideLength - TOPHEIGHT - 20) / 2.0, buttonSideLength, buttonSideLength);
    [ptzBtn setImage:[UIImage imageNamed:@"播放控制"] forState:UIControlStateNormal];
    ptzBtn.enabled = YES;
    [ptzBtn addTarget:self action:@selector(presentPtzView) forControlEvents:UIControlEventTouchUpInside];
    
    _ptzView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _mViewFrame.size.width, _mViewFrame.size.height - TOPHEIGHT)];
    _ptzView.backgroundColor = [UIColor whiteColor];
    _ptzView.hidden = YES;
    
    UIButton *ptzCloseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ptzCloseBtn.frame = CGRectMake(_mViewFrame.size.width - buttonSideLength, 0, buttonSideLength, buttonSideLength);
    [ptzCloseBtn setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
    [ptzCloseBtn addTarget:self action:@selector(closePtzView) forControlEvents:UIControlEventTouchUpInside];
    
    _ptzLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _ptzLeftBtn.frame = CGRectMake((_mViewFrame.size.width - buttonSideLength * 3.0) / 2.0, (_mViewFrame.size.height - buttonSideLength - TOPHEIGHT - 20) / 2.0, buttonSideLength, buttonSideLength);
    [_ptzLeftBtn setImage:[UIImage imageNamed:@"左"] forState:UIControlStateNormal];
    [_ptzLeftBtn addTarget:self action:@selector(ptzControlButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [_ptzLeftBtn addTarget:self action:@selector(ptzControlButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    _ptzUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _ptzUpBtn.frame = CGRectMake((_mViewFrame.size.width - buttonSideLength) / 2.0, (_mViewFrame.size.height - buttonSideLength * 3.0 - TOPHEIGHT - 20) / 2.0, buttonSideLength, buttonSideLength);
    [_ptzUpBtn setImage:[UIImage imageNamed:@"上"] forState:UIControlStateNormal];
    [_ptzUpBtn addTarget:self action:@selector(ptzControlButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [_ptzUpBtn addTarget:self action:@selector(ptzControlButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    _ptzDownBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _ptzDownBtn.frame = CGRectMake((_mViewFrame.size.width - buttonSideLength) / 2.0, (_mViewFrame.size.height - buttonSideLength - TOPHEIGHT - 20) / 2.0 + buttonSideLength, buttonSideLength, buttonSideLength);
    [_ptzDownBtn setImage:[UIImage imageNamed:@"下"] forState:UIControlStateNormal];
    [_ptzDownBtn addTarget:self action:@selector(ptzControlButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [_ptzDownBtn addTarget:self action:@selector(ptzControlButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    _ptzRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _ptzRightBtn.frame = CGRectMake((_mViewFrame.size.width - buttonSideLength) / 2.0 + buttonSideLength, (_mViewFrame.size.height - buttonSideLength - TOPHEIGHT - 20) / 2.0, buttonSideLength, buttonSideLength);
    [_ptzRightBtn setImage:[UIImage imageNamed:@"右"] forState:UIControlStateNormal];
    [_ptzRightBtn addTarget:self action:@selector(ptzControlButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [_ptzRightBtn addTarget:self action:@selector(ptzControlButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    [_scrollView addSubview:_controlView];
    [_scrollView bringSubviewToFront:_controlView];
    [_controlView addSubview:ptzBtn];
    [_controlView addSubview:_ptzView];
    [_ptzView addSubview:ptzCloseBtn];
    [_ptzView addSubview:_ptzRightBtn];
    [_ptzView addSubview:_ptzDownBtn];
    [_ptzView addSubview:_ptzUpBtn];
    [_ptzView addSubview:_ptzLeftBtn];
}


#pragma mark --根据scrollView的滚动位置复用tableView，减少内存开支
-(void)updateTableWithPageNumber:(NSUInteger)pageNumber{
    
    [self changeBackColorWithPage:pageNumber];
    
    int tabviewTag = pageNumber % (int)_tabCount;
    
    CGRect tableNewFrame = CGRectMake(pageNumber * _mViewFrame.size.width, 0, _mViewFrame.size.width, _mViewFrame.size.height - TOPHEIGHT);
    
    UITableView *reuseTableView = _scrollTableViews[tabviewTag];
    reuseTableView.frame = tableNewFrame;
    [reuseTableView reloadData];
}

- (void)changeBackColorWithPage:(NSInteger)currentPage {
    for (int i = 0; i < _topViews.count; i ++) {
        UIView *tempView = _topViews[i];
        
        UIButton *button = [tempView subviews][0];
        if (i == currentPage) {
            tempView.backgroundColor = [UIColor greenColor];
            button.backgroundColor = [UIColor lightGrayColor];
        } else {
            tempView.backgroundColor = [UIColor grayColor];
            button.backgroundColor = [UIColor darkGrayColor];
        }
    }
}

#pragma mark -- scrollView的代理方法

-(void)modifyTopScrollViewPositiong:(UIScrollView *)scrollView{
    if ([_topScrollView isEqual:scrollView]) {
        CGFloat contentOffsetX = _topScrollView.contentOffset.x;
        
        CGFloat width = _slideView.frame.size.width;
        
        int count = (int)contentOffsetX/(int)width;
        
        CGFloat step = (int)contentOffsetX%(int)width;
        
        CGFloat sumStep = width * count;
        
        if (step > width/2) {
            
            sumStep = width * (count + 1);
            
        }
        
        [_topScrollView setContentOffset:CGPointMake(sumStep, 0) animated:YES];
        return;
    }
    
}

///拖拽后调用的方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //[self modifyTopScrollViewPositiong:scrollView];
}



-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView

{
    if ([scrollView isEqual:_scrollView]) {
        _currentPage = _scrollView.contentOffset.x/_mViewFrame.size.width;
        
        _currentPage = _scrollView.contentOffset.x/_mViewFrame.size.width;
        
        //    UITableView *currentTable = _scrollTableViews[_currentPage];
        //    [currentTable reloadData];
        
        [self updateTableWithPageNumber:_currentPage];
        
        return;
    }
    [self modifyTopScrollViewPositiong:scrollView];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([_scrollView isEqual:scrollView]) {
        CGRect frame = _slideView.frame;
        
        if (self.tabCount <= 6) {
            frame.origin.x = scrollView.contentOffset.x/_tabCount;
        } else {
            frame.origin.x = scrollView.contentOffset.x/6;
            
        }
        
        
        _slideView.frame = frame;
    }
    
}

#pragma mark -- talbeView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _sensorList.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:_scrollTableViews[0]]) {
        if ([[NSString stringWithFormat:@"%@",[indexSensor objectForKey:@"sensorType"]] isEqualToString:@"1"]) {
            DetailTableCell *cell = [tableView dequeueReusableCellWithIdentifier:TCellIdentifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:TTableCellNibName owner:self options:nil] lastObject];
            }
            
            cell.labelName.text = [NSString stringWithFormat:@"%@",[indexSensor objectForKey:@"sensorName"]];
            
            cell.labelDetail.text =[NSString stringWithFormat:@"%@ %@",[indexSensor objectForKey:@"value"],[indexSensor objectForKey:@"unit"]];
            
            return cell;
            
        }else if ([[NSString stringWithFormat:@"%@",[indexSensor objectForKey:@"sensorType"]] isEqualToString:@"2"])
        {
            SwitcherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TTCellIdentifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:TTTableCellNibName owner:self options:nil] lastObject];
            }
            
            cell.labelName.text = [NSString stringWithFormat:@"%@",[indexSensor objectForKey:@"sensorName"]];
            
            cell.switcher.on = NO;
            [cell.switcher addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
            
            if ([[NSString stringWithFormat:@"%@",[indexSensor objectForKey:@"switcher"]] isEqualToString:@"1"]) {
                cell.switcher.on = YES;
            }else{
                cell.switcher.on = NO;
            }
            
            return cell;
            
        }else if ([[NSString stringWithFormat:@"%@",[indexSensor objectForKey:@"sensorType"]] isEqualToString:@"5"]){
            SwitcherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TTCellIdentifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:TTTableCellNibName owner:self options:nil] lastObject];
            }
            
            cell.labelName.text = [NSString stringWithFormat:@"%@",[indexSensor objectForKey:@"sensorName"]];
            if ([[NSString stringWithFormat:@"%@",[indexSensor objectForKey:@"switcher"]] isEqualToString:@"1"]) {
                cell.switcher.on = YES;
            }else{
                cell.switcher.on = NO;
            }
            cell.switcher.enabled = NO;
            
            return cell;
            
        }else{
            return nil;
        }
    }else
    {
        BOOL nibsRegistered=NO;
        if (!nibsRegistered) {
            UINib *nib=[UINib nibWithNibName:TTableCellNibName bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:TCellIdentifier];
            nibsRegistered=YES;
        }
        DetailTableCell *cell = [tableView dequeueReusableCellWithIdentifier:TCellIdentifier];
        
        cell.labelName.text = @"";
        return cell;
    }
    

}

- (void)switchAction:(UISwitch *)sender{
    
    UITableViewCell *cell = (UITableViewCell *)sender.superview.superview;
    NSIndexPath *indexPath = [_scrollTableViews[0] indexPathForCell:cell];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    if (sender.on == YES) {
        
    }else{
        
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:@"http://api.dtuip.com/qy/device/controlSwitchValue.html" parameters:parameters progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
              
              NSData * data = [NSJSONSerialization dataWithJSONObject:responseDic options:(NSJSONWritingOptions)0 error:nil];
              NSString * daetr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
              NSLog(@"success123:%@",daetr);
              
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"Error:%@",error);
          }];
}

#pragma mark - 视频设备控制页面
- (void)presentPtzView{
    _ptzView.hidden = NO;
    [_controlView bringSubviewToFront:_ptzView];
}

- (void)closePtzView{
    _ptzView.hidden = YES;
}
@end
