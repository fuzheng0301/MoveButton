//
//  MoreViewController.m
//  MoveGrid
//
//  Created by Jerry.li on 14-11-7.
//  Copyright (c) 2014年 51app. All rights reserved.
//

#import "MoreViewController.h"
#import "CustomGrid.h"
#import "ViewController.h"
#import "PTSingletonManager.h"

@interface MoreViewController ()<CustomGridDelegate>
{
    //标记是否选中
    BOOL isSelected;
    BOOL isSkip;
    BOOL isPush;
    
    UIImage *normalImage;
    UIImage *highlightedImage;
}

@property(nonatomic, strong)NSMutableArray *addGridArray;
//存放格子按钮
@property(nonatomic, strong)NSMutableArray *gridItemArray;
@property(nonatomic, strong)UIView         *showMoreGridView;

@end

@implementation MoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"更多格子";
        self.gridItemArray = [NSMutableArray arrayWithCapacity:12];
        self.addGridArray = [NSMutableArray arrayWithCapacity:12];
        
        self.addGridTitleArray = [NSMutableArray arrayWithCapacity:12];
        self.addImageGridArray = [NSMutableArray arrayWithCapacity:12];
        self.addGridIdArray = [NSMutableArray arrayWithCapacity:12];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isPush = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    isSelected = NO;
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.alpha = 1;
    
    NSMutableArray *titleArr = [PTSingletonManager shareInstance].moreshowGridArray;
    NSMutableArray *imageArr = [PTSingletonManager shareInstance].moreshowImageGridArray;
    NSMutableArray *idArr = [PTSingletonManager shareInstance].moreshowGridIDArray;
    NSLog(@"title :%@ , image :%@ , id :%@ ",titleArr,imageArr,idArr);
    _showGridArray = [[NSMutableArray alloc]initWithArray:titleArr];
    _showImageGridArray = [[NSMutableArray alloc]initWithArray:imageArr];
    _showGridIDArray = [[NSMutableArray alloc]initWithArray:idArr];
    
    [self drawMoreGridView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (!isPush) {
        [self backToPreView];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    isPush = NO;
}

- (void)drawMoreGridView
{
    [self.gridItemArray removeAllObjects];
    [_showMoreGridView removeFromSuperview];
    
    _showMoreGridView = [[UIView alloc] init];
    [_showMoreGridView setFrame:CGRectMake(0, 0, ScreenWidth, GridHeight * PerColumGridCount)];
    [_showMoreGridView setBackgroundColor:[UIColor lightGrayColor]];
    
    normalImage = [UIImage imageNamed:@"app_item_bg"];
    highlightedImage = [UIImage imageNamed:@"app_item_pressed_bg"];
    UIImage *deleteIconImage = [UIImage imageNamed:@"app_item_add"];
    
    for (NSInteger index = 0; index < self.showGridIDArray.count; index++)
    {
        NSString *gridTitle = self.showGridArray[index];
        NSString *gridImageStr = self.showImageGridArray[index];
        NSInteger gridID = [self.showGridIDArray[index] integerValue];
        CustomGrid *gridItem = [[CustomGrid alloc] initWithFrame:CGRectZero title:gridTitle normalImage:normalImage highlightedImage:highlightedImage gridId:gridID atIndex:index isAddDelete:YES deleteIcon:deleteIconImage withIconImage:gridImageStr];
        gridItem.delegate = self;
        gridItem.gridTitle = gridTitle;
        gridItem.gridImageString = gridImageStr;
        gridItem.gridId = gridID;
        
        [self.gridItemArray addObject:gridItem];
        [self.showMoreGridView addSubview:gridItem];
    }
    
    [self.view addSubview:_showMoreGridView];
}

#pragma mark CustomGrid Delegate
//响应格子的点击事件
- (void)gridItemDidClicked:(CustomGrid *)clickItem
{
    isSkip = YES;
    
    for (NSInteger index = 0; index < self.gridItemArray.count; index++)
    {
        CustomGrid *gridItem = self.gridItemArray[index];
        if (gridItem.isChecked)
        {
            //隐藏删图标
            UIButton *deleteButton = (UIButton *)[self.showMoreGridView viewWithTag:gridItem.gridId];
            deleteButton.hidden = YES;
            isSelected = NO;
            isSkip = NO;
            
            [gridItem setIsChecked: NO];
            [gridItem setBackgroundImage:normalImage forState:UIControlStateNormal];
        }
    }
    
    if (isSkip) {
        
        [self itemAction:clickItem.gridTitle];
    }
}

//响应格子删除事件
- (void)gridItemDidDeleteClicked:(UIButton *)deleteButton
{
    NSLog(@"您添加的格子GridId：%ld", (long)deleteButton.tag);
    
    for (NSInteger i = 0; i < self.gridItemArray.count; i++) {
        CustomGrid *deleteGird = self.gridItemArray[i];
        if (deleteGird.gridId == deleteButton.tag) {
            //从视图上移除格子
            [deleteGird removeFromSuperview];
            
            NSInteger count = self.gridItemArray.count - 1;
            //从添加格子的索引开始，后面的格子依次往前移动一格
            for (NSInteger index = deleteGird.gridIndex; index < count; index++) {
                CustomGrid *preGrid = self.gridItemArray[index];
                CustomGrid *nextGrid = self.gridItemArray[index+1];
                
                [UIView animateWithDuration:0.5 animations:^{
                    nextGrid.center = preGrid.gridCenterPoint;
                }];
                nextGrid.gridIndex = index;
            }
            //将删除的格子从数组里面移除
            [self.gridItemArray removeObjectAtIndex:deleteGird.gridIndex];
            
            //删除格子的GirdID
            NSString *gridId = [NSString stringWithFormat:@"%ld", (long)deleteGird.gridId];
            [self.showMoreGridIdArray removeObject:gridId];
            [self.showMoreGridTitleArray removeObject:deleteGird.gridTitle];
            [self.showMoreGridImageArray removeObject:deleteGird.gridImageString];
            
            [self.addGridTitleArray addObject:deleteGird.gridTitle];
            [self.addImageGridArray addObject:deleteGird.gridImageString];
            [self.addGridIdArray addObject:gridId];
        }
    }
    
    //保存数据
    [self saveArray];
    
    //for test print out
    for (NSInteger i = 0; i < _gridItemArray.count; i++)
    {
        CustomGrid *gridItem = _gridItemArray[i];
        gridItem.gridCenterPoint = gridItem.center;
        NSLog(@"所有格子的位置信息{gridIndex: %ld, gridCenterPoint: %@, gridID: %ld}",
              (long)gridItem.gridIndex, NSStringFromCGPoint(gridItem.gridCenterPoint), (long)gridItem.gridId);
    }
}

//响应格子的长安手势事件
- (void)pressGestureStateBegan:(UILongPressGestureRecognizer *)longPressGesture withGridItem:(CustomGrid *) grid
{
    //验证当前长按的按钮是否已经是选中的状态，如果是，那么只增加放大效果
    if (grid.isChecked) {
        grid.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }else{
        //验证数组中所有的格子是否有选中状态的格子
        for (NSInteger i = 0; i < self.showMoreGridIdArray.count; i++) {
            CustomGrid *gridItem = self.gridItemArray[i];
            if (!isSelected && gridItem.isChecked) {
                isSelected = YES;
            }
        }
        
        //如果数组中有选中状态的格子，则不做任何操作，反则增加格子的选中状态
        if (!isSelected) {
            //标记该格子为选中状态
            grid.isChecked = YES;
            
            //显示格子右上角的添加图标
            UIButton *addButton = (UIButton *)[longPressGesture.view viewWithTag:grid.gridId];
            addButton.hidden = NO;
            isSelected = YES;
            
            //给选中的格子添加放大的特效
            [UIView animateWithDuration:0.5 animations:^{
                [grid setTransform:CGAffineTransformMakeScale(1.2, 1.2)];
                [grid setAlpha:0.8];
                [grid setBackgroundImage:highlightedImage forState:UIControlStateNormal];
            }];
        }
    }
}

- (void)pressGestureStateChangedWithPoint:(CGPoint) gridPoint gridItem:(CustomGrid *) gridItem
{
    
}

#pragma mark --- 长按结束
- (void)pressGestureStateEnded:(CustomGrid *) gridItem
{
    //手势结束时，还原格子的放大效果
    [UIView animateWithDuration:0.5 animations:^{
        [gridItem setTransform:CGAffineTransformIdentity];
        [gridItem setAlpha:1.0];
        isSelected = NO;
    }];
}

#pragma mark - 保存更新后数组
-(void)saveArray
{
    // 保存更新后数组
    NSMutableArray * array1 = [[NSMutableArray alloc]init];
    NSMutableArray * array2 = [[NSMutableArray alloc]init];
    NSMutableArray * array3 = [[NSMutableArray alloc]init];
    for (int i = 0; i < _gridItemArray.count; i++) {
        CustomGrid * grid = _gridItemArray[i];
        [array1 addObject:grid.gridTitle];
        [array2 addObject:grid.gridImageString];
        [array3 addObject:[NSString stringWithFormat:@"%ld",(long)grid.gridId]];
    }
    NSArray * titleArray = [array1 copy];
    NSArray * imageArray = [array2 copy];
    NSArray * idArray = [array3 copy];
    
    [PTSingletonManager shareInstance].moreshowGridArray = [[NSMutableArray alloc]initWithArray:titleArray];
    [PTSingletonManager shareInstance].moreshowImageGridArray = [[NSMutableArray alloc]initWithArray:imageArray];
    [PTSingletonManager shareInstance].moreshowGridIDArray = [[NSMutableArray alloc]initWithArray:idArray];
    
    //主页中的版块更改
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"moretitle"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"moreimage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"moregridID"];
    
    [[NSUserDefaults standardUserDefaults] setObject:titleArray forKey:@"moretitle"];
    [[NSUserDefaults standardUserDefaults] setObject:imageArray forKey:@"moreimage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] setObject:idArray forKey:@"moregridID"];
    
    //更多页面中的版块存储
    // 保存更新后数组
    NSMutableArray * moreTitleArray = [PTSingletonManager shareInstance].showGridArray;
    NSMutableArray * moreImageArray = [PTSingletonManager shareInstance].showImageGridArray;
    NSMutableArray * moreIdArray = [PTSingletonManager shareInstance].showGridIDArray;
    
    for (int i = 0; i < self.addGridTitleArray.count; i++) {
        [moreTitleArray insertObject:self.addGridTitleArray[i] atIndex:moreTitleArray.count-1];
        [moreImageArray insertObject:self.addImageGridArray[i] atIndex:moreImageArray.count-1];
        [moreIdArray insertObject:self.addGridIdArray[i] atIndex:moreIdArray.count-1];
    }
    [self.addGridTitleArray removeAllObjects];
    [self.addImageGridArray removeAllObjects];
    [self.addGridIdArray removeAllObjects];
    
    [PTSingletonManager shareInstance].showGridArray = [[NSMutableArray alloc]initWithArray:moreTitleArray];
    [PTSingletonManager shareInstance].showImageGridArray = [[NSMutableArray alloc]initWithArray:moreImageArray];
    [PTSingletonManager shareInstance].showGridIDArray = [[NSMutableArray alloc]initWithArray:moreIdArray];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"title"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"image"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"gridID"];
    
    [[NSUserDefaults standardUserDefaults] setObject:moreTitleArray forKey:@"title"];
    [[NSUserDefaults standardUserDefaults] setObject:moreImageArray forKey:@"image"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] setObject:moreIdArray forKey:@"gridID"];
    
    NSLog(@"更新后titleArray = %@",titleArray);
    NSLog(@"更新后imageArray = %@",imageArray);
    
}

- (void)itemAction:(NSString *)title
{
    NSLog(@"点击了%@格子",title);
}

- (void)backToPreView
{
    ViewController *mainView = [self.navigationController.viewControllers objectAtIndex:0];
    mainView.addGridTitleArray = self.addGridTitleArray;
    mainView.addGridImageArray = self.addImageGridArray;
    mainView.addGridIDArray = self.addGridIdArray;
    [self.navigationController popToViewController:mainView animated:YES];
}

@end
