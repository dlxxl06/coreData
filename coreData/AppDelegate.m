//
//  AppDelegate.m
//  coreData
//
//  Created by admin on 15/8/12.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "AppDelegate.h"



@interface AppDelegate ()

@end

@implementation AppDelegate
//-(NSManagedObjectContext *)sharedManageObject
//{
//    return self.managedObjectContext;
//
//}

#pragma mark sqlist 插入数据
-(void)insertNewObject
{
    
    //创建一个获取请求
    
    //请求绑定实体
    
    @try {
        //创建实体
        Person *person =[NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
        //插入数据操作
        if (person!=nil) {
            person.name = @"赵六";
            person.age = @(28);
        }
        //保存数据
        //[self.managedObjectContext save:nil];
        [self.managedObjectContext insertObject:person];
        NSLog(@"insert Section successfully");
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}

#pragma mark 查找数据
-(void)queryObjects
{
    
   
    @try
    {
        //创建请求
        NSFetchRequest *fr = [[NSFetchRequest alloc]init];
        
        //创建实体
        NSEntityDescription *ent = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
        
        //绑定实体
        [fr setEntity:ent];
        //排序
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:YES];
        [fr setSortDescriptors:@[sort]];
        //执行请求，遍历请求的结果
     NSArray *resArr = [self.managedObjectContext executeFetchRequest:fr error:nil];
        if (resArr!=nil)
        {
            for (Person *p in resArr)
            {
                NSLog(@"%@",p.description);
            }
        }
        
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@",exception);
    }

}
#pragma mark 修改数据
-(void)updateObjects
{
    
    @try {
        //创建请求
        NSFetchRequest *fr = [[NSFetchRequest alloc]init];
        
        //创建实体
        NSEntityDescription *ent = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
        
        //绑定实体
        [fr setEntity:ent];
        
        //创建查询条件
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"name CONTAINS[c]%@",@"张三"];
        
        [fr setPredicate:pre];
        
        NSArray *resArr = [ self.managedObjectContext executeFetchRequest:fr error:nil];
        
        if (resArr!=nil)
        {
            for (Person *p in resArr)
            {
                p.age = @(35);
            }
            
             //更新数据
            [self.managedObjectContext save:nil];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }

}
#pragma mark 删除数据
-(void)deleteObjects
{
    @try {
        //获取请求
        NSFetchRequest *fr = [[NSFetchRequest alloc]init];
        
        
        //创建实体
        NSEntityDescription *ent = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
        //绑定实体
        [fr setEntity:ent];
        //创建谓词
        
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"name CONTAINS[c]%@",@"三"];
        //对数据进行筛选
        [fr setPredicate:pre];
        NSArray *resArr = [self.managedObjectContext executeFetchRequest:fr error:nil];
        //删除指定的数据
        for (Person *p in resArr) {
            [self.managedObjectContext deleteObject:p];
        }
        //更新数据
        [self.managedObjectContext save:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    

}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //[self insertNewObject];
    //[self updateObject];
    [self deleteObjects];
    [self queryObjects];
    
    return YES;
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
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.LJL.coreData" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"coreData" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"coreData.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
