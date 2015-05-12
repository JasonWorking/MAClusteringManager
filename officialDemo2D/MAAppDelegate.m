//
//  MAAppDelegate.m
//  officialDemo2D
//
//  Created by 刘博 on 13-9-6.
//  Copyright (c) 2013年 AutoNavi. All rights reserved.
//

#import "MAAppDelegate.h"


#import "AnnotationViewController.h"
#import "APIKey.h"
#import <MAMapKit/MAMapKit.h>

@implementation MAAppDelegate

- (void)configureAPIKey
{
    if ([APIKey length] == 0)
    {
        NSString *reason = [NSString stringWithFormat:@"apiKey为空，请检查key是否正确设置。"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:reason delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    [MAMapServices sharedServices].apiKey = (NSString *)APIKey;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    [self configureAPIKey];
    
    AnnotationViewController *mainViewController = [[AnnotationViewController alloc] init];
    
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}


@end
