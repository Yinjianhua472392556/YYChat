//
//  ContactGroup.h
//  YYChat
//
//  Created by apple on 16/6/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

@interface ContactGroup : NSObject<YYModel>

@property (nonatomic, strong) NSArray *userList; /**<存放当前组所有的联系人信息 ContactGroupList类型*/

@property (nonatomic, copy) NSString *groupid; /**<组ID */

@property (nonatomic, copy) NSString *groupname; /**<组名 */

@property (nonatomic, copy) NSString *size; //联系人数组大小

@property (nonatomic, assign,getter=isOpen) BOOL open; /*<记录当前组时候打开 */

@end
