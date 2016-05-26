//
//  AppDelegate.m
//  MoveButton
//
//  Created by fuzheng on 16-5-26.
//  Copyright © 2016年 付正. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "PTSingletonManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    if([UINavigationBar conformsToProtocol:@protocol(UIAppearanceContainer)]) {
        [UINavigationBar appearance].tintColor = [UIColor whiteColor];
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName : [UIColor whiteColor]}];
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:(51)/255.f green:(171)/255.f blue:(160)/255.f alpha:1.f]];
        [[UINavigationBar appearance] setTranslucent:NO];
    }
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    ViewController *vc = [[ViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = navigationController;
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self createData];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(void)createData
{
    // 如果数组有改变
    NSArray * titleArray = [[NSArray alloc]init];
    NSArray * imageArray = [[NSArray alloc]init];
    NSArray * idArray = [[NSArray alloc]init];
    titleArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"title"];
    imageArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"image"];
    idArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"gridID"];
    NSLog(@"array = %@",titleArray);
    
    NSArray * moretitleArray = [[NSArray alloc]init];
    NSArray * moreimageArray = [[NSArray alloc]init];
    NSArray * moreidArray = [[NSArray alloc]init];
    moretitleArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"moretitle"];
    moreimageArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"moreimage"];
    moreidArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"moregridID"];
    
    // Home按钮数组 体验账号
    [PTSingletonManager shareInstance].showGridArray = [[NSMutableArray alloc]initWithCapacity:12];
    [PTSingletonManager shareInstance].showImageGridArray = [[NSMutableArray alloc]initWithCapacity:12];
    
    [PTSingletonManager shareInstance].showGridArray = [NSMutableArray arrayWithObjects:@"收银台",@"结算",@"分享", @"T+0", @"中心",@"D+1", @"商店",@"P2P", @"开通", @"充值", @"转账", @"扫码", @"记录" , @"快捷支付", @"明细", @"收款",@"更多", nil];
    
    [PTSingletonManager shareInstance].showImageGridArray =
    [NSMutableArray arrayWithObjects:
     @"more_icon_Transaction_flow",@"more_icon_cancle_deal", @"more_icon_Search",
     @"more_icon_t0",@"more_icon_shouyin" ,@"more_icon_d1",
     @"more_icon_Settlement",@"more_icon_Mall", @"more_icon_gift",
     @"more_icon_licai",@"more_icon_-transfer",@"more_icon_Recharge" ,
     @"more_icon_Transfer-" , @"more_icon_Credit-card-",@"more_icon_Manager",@"work-order",@"add_businesses", nil];
    
    [PTSingletonManager shareInstance].showGridIDArray =
    [NSMutableArray arrayWithObjects:
     @"1000",@"1001", @"1002",
     @"1003",@"1004",@"1005" ,@"1006",
     @"1007",@"1008", @"1009",
     @"1010",@"1011",@"1012" ,
     @"1013" , @"1014",@"1015",@"0", nil];
    
    // 对比数组
    NSMutableString * defaString = [[NSMutableString alloc]init];
    NSMutableString * localString = [[NSMutableString alloc]init];
    
    // 默认
    for (int i = 0; i< [PTSingletonManager shareInstance].showGridArray.count; i++) {
        [defaString appendString:[PTSingletonManager shareInstance].showGridArray[i]];
        //        NSLog(@"defaString = %@",defaString);
    }
    // 本地
    for (int i = 0; i< titleArray.count; i++) {
        [localString appendString:titleArray[i]];
        //        NSLog(@"localString = %@",localString);
    }
    
    // 如果本地数组有改变
    if (![localString isEqualToString:defaString] && localString.length>2) {
        [PTSingletonManager shareInstance].showGridArray = [[NSMutableArray alloc]initWithArray:titleArray];
        [PTSingletonManager shareInstance].showImageGridArray = [[NSMutableArray alloc]initWithArray:imageArray];
        [PTSingletonManager shareInstance].showGridIDArray = [[NSMutableArray alloc]initWithArray:idArray];
        
        [PTSingletonManager shareInstance].moreshowGridArray = [[NSMutableArray alloc]initWithArray:moretitleArray];
        [PTSingletonManager shareInstance].moreshowImageGridArray = [[NSMutableArray alloc]initWithArray:moreimageArray];
        [PTSingletonManager shareInstance].moreshowGridIDArray = [[NSMutableArray alloc]initWithArray:moreidArray];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
