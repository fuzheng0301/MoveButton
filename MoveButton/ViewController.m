//
//  ViewController.m
//  MoveButton
//
//  Created by 聚财通 on 16/5/26.
//  Copyright © 2016年 付正. All rights reserved.
//

#import "ViewController.h"
#import "CustomGrid.h"
#import "MoreViewController.h"
#import "PTSingletonManager.h"

@interface ViewController ()<CustomGridDelegate,UIScrollViewDelegate>
{
    BOOL isSelected;
    BOOL contain;
    //是否可跳转应用对应的详细页面
    BOOL isSkip;
    UIScrollView * myScrollView;
    
    //选中格子的起始位置
    CGPoint startPoint;
    //选中格子的起始坐标位置
    CGPoint originPoint;
    
    UIImage *normalImage;
    UIImage *highlightedImage;
    UIImage *deleteIconImage;
}
@end

@implementation ViewController

- (instancetype)init
{
    if (self = [super init]) {
        
        self.gridListArray = [[NSMutableArray alloc] initWithCapacity:12];
        
        self.showGridArray = [[NSMutableArray alloc] initWithCapacity:12];
        self.showGridImageArray = [[NSMutableArray alloc] initWithCapacity:12];
        self.showGridIDArray = [[NSMutableArray alloc] initWithCapacity:12];
        
        self.moreGridIdArray = [[NSMutableArray alloc] initWithCapacity:12];
        self.moreGridTitleArray = [[NSMutableArray alloc]initWithCapacity:12];
        self.moreGridImageArray = [[NSMutableArray alloc]initWithCapacity:12];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"移动格子";
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.gridListArray = [[NSMutableArray alloc] initWithCapacity:12];
    
    self.showGridArray = [[NSMutableArray alloc] initWithCapacity:12];
    self.showGridImageArray = [[NSMutableArray alloc] initWithCapacity:12];
    self.showGridIDArray = [[NSMutableArray alloc] initWithCapacity:12];
    
    self.moreGridIdArray = [[NSMutableArray alloc] initWithCapacity:12];
    self.moreGridTitleArray = [[NSMutableArray alloc]initWithCapacity:12];
    self.moreGridImageArray = [[NSMutableArray alloc]initWithCapacity:12];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    isSelected = NO;
    
    NSMutableArray *titleArr = [PTSingletonManager shareInstance].showGridArray;
    NSMutableArray *imageArr = [PTSingletonManager shareInstance].showImageGridArray;
    NSMutableArray *idArr = [PTSingletonManager shareInstance].showGridIDArray;
    _showGridArray = [[NSMutableArray alloc]initWithArray:titleArr];
    _showGridImageArray = [[NSMutableArray alloc]initWithArray:imageArr];
    _showGridIDArray = [[NSMutableArray alloc]initWithArray:idArr];
    
    [myScrollView removeFromSuperview];
    [self creatMyScrollView];
}

- (void)creatMyScrollView
{
#pragma mark - 可拖动的按钮
    normalImage = [UIImage imageNamed:@"app_item_bg"];
    highlightedImage = [UIImage imageNamed:@"app_item_bg"];
    deleteIconImage = [UIImage imageNamed:@"app_item_plus"];
    
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    myScrollView.contentInset = UIEdgeInsetsMake(0, 0, ScreenHeight*2, 0);
    myScrollView.backgroundColor = [UIColor clearColor];
    myScrollView.delegate = self;
    [self.view addSubview:myScrollView];
    
    _gridListView = [[UIView alloc] init];
    [_gridListView setFrame:CGRectMake(0, 0, ScreenWidth, GridHeight * PerColumGridCount)];
    [_gridListView setBackgroundColor:[UIColor whiteColor]];
    
    [myScrollView addSubview:_gridListView];
    
    [self.gridListArray removeAllObjects];
    for (NSInteger index = 0; index < [_showGridArray count]; index++)
    {
        NSString *gridTitle = _showGridArray[index];
        NSString *gridImage = _showGridImageArray[index];
        NSInteger gridID = [self.showGridIDArray[index] integerValue];
        BOOL isAddDelete = YES;
        if ([gridTitle isEqualToString:@"更多"]) {
            isAddDelete = NO;
        }
        CustomGrid *gridItem = [[CustomGrid alloc] initWithFrame:CGRectZero title:gridTitle normalImage:normalImage highlightedImage:highlightedImage gridId:gridID atIndex:index isAddDelete:isAddDelete deleteIcon:deleteIconImage  withIconImage:gridImage];
        gridItem.delegate = self;
        gridItem.gridTitle = gridTitle;
        gridItem.gridImageString = gridImage;
        gridItem.gridId = gridID;
        
        [self.gridListView addSubview:gridItem];
        [self.gridListArray addObject:gridItem];
        
    }
    
    //for test print out
    for (NSInteger i = 0; i < _gridListArray.count; i++) {
        CustomGrid *gridItem = _gridListArray[i];
        gridItem.gridCenterPoint = gridItem.center;
    }
    
    //更新页面
    [self getNewData];
}

#pragma mark --- 更新页面
-(void)getNewData
{
    NSInteger gridHeight;
    if (self.showGridArray.count % 3 == 0) {
        gridHeight = 123 * self.showGridArray.count/3;
    }
    else{
        gridHeight = 123 * (self.showGridArray.count/3+1);
    }
    myScrollView.contentInset = UIEdgeInsetsMake(0, 0, gridHeight, 0);
}

#pragma mark - 可拖动按钮
#pragma mark - 点击格子
- (void)gridItemDidClicked:(CustomGrid *)gridItem
{
    NSLog(@"您点击的格子Tag是：%ld", (long)gridItem.gridId);
    isSkip = YES;
    
    //查看是否有选中的格子，并且比较点击的格子是否就是选中的格子
    for (NSInteger i = 0; i < [_gridListArray count]; i++) {
        CustomGrid *item = _gridListArray[i];
        if (item.isChecked) {
            item.isChecked = NO;
            item.isMove = NO;
            isSelected = NO;
            isSkip = NO;
            
            //隐藏删除图标
            UIButton *removeBtn = (UIButton *)[self.gridListView viewWithTag:item.gridId];
            removeBtn.hidden = YES;
            [item setBackgroundImage:normalImage forState:UIControlStateNormal];
            
            if (gridItem.gridId == 0) {
                isSkip = YES;
            }
            //            break;
        }
        //        else if (item.isChecked && item.gridId == gridItem.gridId) {
        //            item.isChecked = NO;
        //            item.isMove = NO;
        //            isSelected = NO;
        //            isSkip = NO;
        //
        //            //隐藏删除图标
        //            UIButton *removeBtn = (UIButton *)[self.gridListView viewWithTag:gridItem.gridId];
        //            removeBtn.hidden = YES;
        //            [item setBackgroundImage:normalImage forState:UIControlStateNormal];
        //
        //            if (gridItem.gridId == 0) {
        //                isSkip = YES;
        //            }
        //        }
    }
    
    if (isSkip) {
        [self itemAction:gridItem.gridTitle];
    }
}

#pragma mark - 删除格子
- (void)gridItemDidDeleteClicked:(UIButton *)deleteButton
{
    NSLog(@"您删除的格子是GridId：%ld", (long)deleteButton.tag);
    
    for (NSInteger i = 0; i < _gridListArray.count; i++) {
        CustomGrid *removeGrid = _gridListArray[i];
        if (removeGrid.gridId == deleteButton.tag) {
            [removeGrid removeFromSuperview];
            NSInteger count = _gridListArray.count - 1;
            for (NSInteger index = removeGrid.gridIndex; index < count; index++) {
                CustomGrid *preGrid = _gridListArray[index];
                CustomGrid *nextGrid = _gridListArray[index+1];
                [UIView animateWithDuration:0.5 animations:^{
                    nextGrid.center = preGrid.gridCenterPoint;
                }];
                nextGrid.gridIndex = index;
            }
            //排列格子顺序和更新格子坐标信息
            [self sortGridList];
            
            [_gridListArray removeObjectAtIndex:removeGrid.gridIndex];
            
            NSString *gridTitle = removeGrid.gridTitle;
            NSString *gridImage = removeGrid.gridImageString;
            NSString *gridID = [NSString stringWithFormat:@"%ld", (long)removeGrid.gridId];
            //删除的应用添加到更多应用数组
            [_moreGridTitleArray addObject:gridTitle];
            [_moreGridImageArray addObject:gridImage];
            [_moreGridIdArray addObject:gridID];
            
            [_showGridArray removeObject:gridTitle];
            [_showGridImageArray removeObject:gridImage];
            [_showGridIDArray removeObject:gridID];
        }
    }
    // 保存更新后数组
    [self saveArray];
    
    //更新页面
    [self getNewData];
}

#pragma mark - 长按格子
- (void)pressGestureStateBegan:(UILongPressGestureRecognizer *)longPressGesture withGridItem:(CustomGrid *) grid
{
    NSLog(@"长按.........");
    NSLog(@"isSelected: %d", isSelected);
    
    //判断格子是否已经被选中并且是否可移动状态,如果选中就加一个放大的特效
    if (isSelected && grid.isChecked) {
        grid.transform = CGAffineTransformMakeScale(1.1, 1.1);
    }
    
    //没有一个格子选中的时候
    if (!isSelected) {
        
        NSLog(@"没有一个格子选中............");
        grid.isChecked = YES;
        grid.isMove = YES;
        isSelected = YES;
        
        //选中格子的时候显示删除图标
        UIButton *removeBtn = (UIButton *)[longPressGesture.view viewWithTag:grid.gridId];
        removeBtn.hidden = NO;
        
        //获取移动格子的起始位置
        startPoint = [longPressGesture locationInView:longPressGesture.view];
        //获取移动格子的起始位置中心点
        originPoint = grid.center;
        
        //给选中的格子添加放大的特效
        [UIView animateWithDuration:0.5 animations:^{
            grid.transform = CGAffineTransformMakeScale(1.1, 1.1);
            grid.alpha = 1;
            [grid setBackgroundImage:highlightedImage forState:UIControlStateNormal];
        }];
    }
}

#pragma mark --- 拖动位置
- (void)pressGestureStateChangedWithPoint:(CGPoint) gridPoint gridItem:(CustomGrid *) gridItem
{
    if (isSelected && gridItem.isChecked) {
        //        NSLog(@"UIGestureRecognizerStateChanged.........");
        
        [_gridListView bringSubviewToFront:gridItem];
        //应用移动后的X坐标
        CGFloat deltaX = gridPoint.x - startPoint.x;
        //应用移动后的Y坐标
        CGFloat deltaY = gridPoint.y - startPoint.y;
        //拖动的应用跟随手势移动
        gridItem.center = CGPointMake(gridItem.center.x + deltaX, gridItem.center.y + deltaY);
        
        //移动的格子索引下标
        NSInteger fromIndex = gridItem.gridIndex;
        //移动到目标格子的索引下标
        NSInteger toIndex = [CustomGrid indexOfPoint:gridItem.center withButton:gridItem gridArray:_gridListArray];
        
        NSInteger borderIndex = [_showGridIDArray indexOfObject:@"0"];
        NSLog(@"borderIndex: %ld", (long)borderIndex);
        
        if (toIndex < 0 || toIndex >= borderIndex) {
            contain = NO;
        }else{
            //获取移动到目标格子
            CustomGrid *targetGrid = _gridListArray[toIndex];
            gridItem.center = targetGrid.gridCenterPoint;
            originPoint = targetGrid.gridCenterPoint;
            gridItem.gridIndex = toIndex;
            
            //判断格子的移动方向，是从后往前还是从前往后拖动
            if ((fromIndex - toIndex) > 0) {
                //                NSLog(@"从后往前拖动格子.......");
                //从移动格子的位置开始，始终获取最后一个格子的索引位置
                NSInteger lastGridIndex = fromIndex;
                for (NSInteger i = toIndex; i < fromIndex; i++) {
                    CustomGrid *lastGrid = _gridListArray[lastGridIndex];
                    CustomGrid *preGrid = _gridListArray[lastGridIndex-1];
                    [UIView animateWithDuration:0.5 animations:^{
                        preGrid.center = lastGrid.gridCenterPoint;
                    }];
                    //实时更新格子的索引下标
                    preGrid.gridIndex = lastGridIndex;
                    lastGridIndex--;
                }
                //排列格子顺序和更新格子坐标信息
                [self sortGridList];
                
            }else if((fromIndex - toIndex) < 0){
                //从前往后拖动格子
                //                NSLog(@"从前往后拖动格子.......");
                //从移动格子到目标格子之间的所有格子向前移动一格
                for (NSInteger i = fromIndex; i < toIndex; i++) {
                    CustomGrid *topOneGrid = _gridListArray[i];
                    CustomGrid *nextGrid = _gridListArray[i+1];
                    //实时更新格子的索引下标
                    nextGrid.gridIndex = i;
                    [UIView animateWithDuration:0.5 animations:^{
                        nextGrid.center = topOneGrid.gridCenterPoint;
                    }];
                }
                //排列格子顺序和更新格子坐标信息
                [self sortGridList];
            }
        }
    }
}

#pragma mark - 拖动格子结束
- (void)pressGestureStateEnded:(CustomGrid *) gridItem
{
    //    NSLog(@"拖动格子结束.........");
    if (isSelected && gridItem.isChecked) {
        //撤销格子的放大特效
        [UIView animateWithDuration:0.5 animations:^{
            gridItem.transform = CGAffineTransformIdentity;
            gridItem.alpha = 1.0;
            isSelected = NO;
            if (!contain) {
                gridItem.center = originPoint;
            }
        }];
        
        //排列格子顺序和更新格子坐标信息
        [self sortGridList];
    }
}

- (void)sortGridList
{
    //重新排列数组中存放的格子顺序
    [_gridListArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        CustomGrid *tempGrid1 = (CustomGrid *)obj1;
        CustomGrid *tempGrid2 = (CustomGrid *)obj2;
        return tempGrid1.gridIndex > tempGrid2.gridIndex;
    }];
    
    //更新所有格子的中心点坐标信息
    for (NSInteger i = 0; i < _gridListArray.count; i++) {
        CustomGrid *gridItem = _gridListArray[i];
        gridItem.gridCenterPoint = gridItem.center;
    }
    
    // 保存更新后数组
    [self saveArray];
}

#pragma mark - 保存更新后数组
-(void)saveArray
{
    // 保存更新后数组
    NSMutableArray * array1 = [[NSMutableArray alloc]init];
    NSMutableArray * array2 = [[NSMutableArray alloc]init];
    NSMutableArray * array3 = [[NSMutableArray alloc]init];
    for (int i = 0; i < _gridListArray.count; i++) {
        CustomGrid * grid = _gridListArray[i];
        [array1 addObject:grid.gridTitle];
        [array2 addObject:grid.gridImageString];
        [array3 addObject:[NSString stringWithFormat:@"%ld",(long)grid.gridId]];
    }
    NSArray * titleArray = [array1 copy];
    NSArray * imageArray = [array2 copy];
    NSArray * idArray = [array3 copy];
    
    [PTSingletonManager shareInstance].showGridArray = [[NSMutableArray alloc]initWithArray:titleArray];
    [PTSingletonManager shareInstance].showImageGridArray = [[NSMutableArray alloc]initWithArray:imageArray];
    [PTSingletonManager shareInstance].showGridIDArray = [[NSMutableArray alloc]initWithArray:idArray];
    
    //主页中的版块更改
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"title"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"image"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"gridID"];
    
    [[NSUserDefaults standardUserDefaults] setObject:titleArray forKey:@"title"];
    [[NSUserDefaults standardUserDefaults] setObject:imageArray forKey:@"image"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] setObject:idArray forKey:@"gridID"];
    
    //更多页面中的版块存储
    // 保存更新后数组
    NSMutableArray * moreTitleArray = [PTSingletonManager shareInstance].moreshowGridArray;
    NSMutableArray * moreImageArray = [PTSingletonManager shareInstance].moreshowImageGridArray;
    NSMutableArray * moreIdArray = [PTSingletonManager shareInstance].moreshowGridIDArray;
    for (int i = 0; i < self.moreGridTitleArray.count; i++) {
        [moreTitleArray addObject:self.moreGridTitleArray[i]];
        [moreImageArray addObject:self.moreGridImageArray[i]];
        [moreIdArray addObject:self.moreGridIdArray[i]];
    }
    [self.moreGridTitleArray removeAllObjects];
    [self.moreGridImageArray removeAllObjects];
    [self.moreGridIdArray removeAllObjects];
    
    [PTSingletonManager shareInstance].moreshowGridArray = [[NSMutableArray alloc]initWithArray:moreTitleArray];
    [PTSingletonManager shareInstance].moreshowImageGridArray = [[NSMutableArray alloc]initWithArray:moreImageArray];
    [PTSingletonManager shareInstance].moreshowGridIDArray = [[NSMutableArray alloc]initWithArray:moreIdArray];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"moretitle"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"moreimage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"moregridID"];
    
    [[NSUserDefaults standardUserDefaults] setObject:moreTitleArray forKey:@"moretitle"];
    [[NSUserDefaults standardUserDefaults] setObject:moreImageArray forKey:@"moreimage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] setObject:moreIdArray forKey:@"moregridID"];
    
    NSLog(@"更新后titleArray = %@",titleArray);
    NSLog(@"更新后imageArray = %@",imageArray);
    
    NSInteger gridHeight;
    gridHeight = 123 * (self.showGridArray.count/3);
    
    myScrollView.contentInset = UIEdgeInsetsMake(0, 0, gridHeight + 123, 0);
}

#pragma mark 点击 按钮
- (void)itemAction:(NSString *)title
{
    if ([title isEqualToString:@"更多"])
    {
        MoreViewController *otherView = [[MoreViewController alloc] init];
        otherView.showMoreGridIdArray = self.moreGridIdArray;
        otherView.showMoreGridTitleArray = self.moreGridTitleArray;
        otherView.showMoreGridImageArray = self.moreGridImageArray;
        [self.navigationController pushViewController:otherView animated:YES];
    }
    else {
        NSLog(@"点击了%@格子",title);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
