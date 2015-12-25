//
//  Person.m
//  coreData
//
//  Created by admin on 15/8/12.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "Person.h"


@implementation Person

@dynamic name;
@dynamic age;
-(NSString *)description
{
    
    return [NSString stringWithFormat:@"%p-name:%@,age:%@",self,self.name,self.age];
}

@end
