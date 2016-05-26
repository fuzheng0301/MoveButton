//
//  CustomGrid.h
//  MoveGrid
//
//  Created by fuzheng on 16-5-26.
//  Copyright © 2016年 付正. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//每个格子的高度
#define GridHeight 123
//每行显示格子的列数
#define PerRowGridCount 3
//每列显示格子的行数
#define PerColumGridCount 6
//每个格子的宽度
#define GridWidth (ScreenWidth/PerRowGridCount)
//每个格子的X轴间隔
#define PaddingX 0
//每个格子的Y轴间隔
#define PaddingY 0

@protocol CustomGridDelegate;

@interface CustomGrid : UIButton
//格子的ID
@property(nonatomic, assign)NSInteger gridId;

//格子的title
@property(nonatomic, strong)NSString *gridTitle;
//格子的图片
@property(nonatomic, strong)NSString *gridImageString;

//格子的选中状态
@property(nonatomic, assign)BOOL      isChecked;
//格子的移动状态
@property(nonatomic, assign)BOOL      isMove;
//格子的排列索引位置
@property(nonatomic, assign)NSInteger gridIndex;
//格子的位置坐标
@property(nonatomic, assign)CGPoint   gridCenterPoint;
//代理方法
@property(nonatomic, weak)id<CustomGridDelegate> delegate;

/**
 * 创建格子
 * @param pointX   格子所在位置的X坐标
 * @param pointY   格子所在位置的Y坐标
 * @param gridId   格子的ID
 * @param index    格子所在位置的索引下标
 * @param isDelete 是否增加删除图标
 */
- (id)initWithFrame:(CGRect)frame
              title:(NSString *)title
        normalImage:(UIImage *)normalImage
   highlightedImage:(UIImage *)highlightedImage
             gridId:(NSInteger)gridId
            atIndex:(NSInteger)index
        isAddDelete:(BOOL)isAddDelete
         deleteIcon:(UIImage *)deleteIcon
      withIconImage:(NSString *)imageString;

//根据格子的坐标计算格子的索引位置
+ (NSInteger)indexOfPoint:(CGPoint)point
               withButton:(UIButton *)btn
                gridArray:(NSMutableArray *)gridListArray;

@end

@protocol CustomGridDelegate <NSObject>

//响应格子的点击事件
- (void)gridItemDidClicked:(CustomGrid *)clickItem;

//响应格子删除事件
- (void)gridItemDidDeleteClicked:(UIButton *)deleteButton;

//响应格子的长安手势事件
- (void)pressGestureStateBegan:(UILongPressGestureRecognizer *)longPressGesture withGridItem:(CustomGrid *) grid;

- (void)pressGestureStateChangedWithPoint:(CGPoint) gridPoint gridItem:(CustomGrid *) gridItem;

- (void)pressGestureStateEnded:(CustomGrid *) gridItem;

@end


