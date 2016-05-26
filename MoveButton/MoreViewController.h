//
//  MoreViewController.h
//  MoveGrid
//
//  Created by fuzheng on 16-5-26.
//  Copyright © 2016年 付正. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreViewController : UIViewController

//显示格子的GridId
@property(nonatomic, strong)NSMutableArray *showMoreGridIdArray;
@property(nonatomic, strong)NSMutableArray *showMoreGridTitleArray;
@property(nonatomic, strong)NSMutableArray *showMoreGridImageArray;

@property(nonatomic, strong)NSMutableArray *showGridArray; //title
@property(nonatomic, strong)NSMutableArray *showImageGridArray;//image
@property(nonatomic, strong)NSMutableArray *showGridIDArray;//gridId

//首页显示应用
@property(nonatomic, strong)NSMutableArray *addGridTitleArray;
@property(nonatomic, strong)NSMutableArray *addGridIdArray;
@property(nonatomic, strong)NSMutableArray *addImageGridArray;//image

@end
