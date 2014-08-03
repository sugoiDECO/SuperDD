//
//  SDDUser.h
//  SuperDD
//
//  Created by Shiro Nohara on 2014/08/01.
//  Copyright (c) 2014年 Georepublic. All rights reserved.
//

#import "SRSimpleRemoteObject.h"

@interface SDDUser : SRSimpleRemoteObject

@property (nonatomic, strong) NSString *login;
@property (nonatomic, strong) NSString *firstname;
@property (nonatomic, strong) NSString *lastname;

@end
