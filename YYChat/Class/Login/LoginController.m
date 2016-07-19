//
//  LoginController.m
//  YYChat
//
//  Created by apple on 16/6/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LoginController.h"
#import "AppDelegate.h"
#import "UerOperation.h"
#import "XmppTools.h"
#import "UIViewController+HUD.h"
#import "NetworkingHelper.h"
#import "UserInfo.h"



@interface LoginController ()

@property (weak, nonatomic) IBOutlet UITextField *userCountTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordTextField;

- (IBAction)loginAction:(id)sender;

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UserOperation *loginUser = [UserOperation shareduser];

    self.userCountTextField.text = loginUser.telephone;
    self.userPasswordTextField.text = loginUser.password;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self.view addGestureRecognizer:tap];
}


#pragma mark - Action

- (void)tapClick:(UIGestureRecognizer *)tap {

    [self.view endEditing:YES];
}

- (IBAction)loginAction:(id)sender {
    
    NSString *userName = [self trim:self.userCountTextField.text];
    NSString *password = [self trim:self.userPasswordTextField.text];
    

    
    //显示旋转框
    [self showHudInView:self.view hint:@"登录中..."];
    
    [self.view endEditing:YES];
    
    
#warning - 先用PHP接口登录，登录成功后再用解析得到的数据登录Openfire
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:userName forKey:@"phone"];
    [params setObject:password forKey:@"password"];
    
    __weak typeof(self) weakSelf = self;

    [[NetworkingHelper shareHelper] loginWithPath:@"http://10.1.125.63:6080/weiyuan/user/api/login?" params:params completion:^(id data, NSError *error) {
        
        if (data) { //返回登录数据
            
            NSDictionary *userInfo = [data objectForKey:@"data"];
            
            //用NSUserDefaults保存登录用户的用户名和密码
            
            UserOperation *loginUser = [UserOperation shareduser];
            loginUser.userName = [userInfo objectForKey:@"uid"];
            loginUser.password = [userInfo objectForKey:@"password"];
            loginUser.telephone = [userInfo objectForKey:@"phone"];

            //用归档来保存登录用户的个人相关的所有信息
            NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *doucuments = [array objectAtIndex:0];
            NSString *path = [doucuments stringByAppendingString:@"/user.archive"];
            UserInfo *user = [UserInfo yy_modelWithJSON:userInfo];
            
            [NSKeyedArchiver archiveRootObject:user toFile:path];

            NSLog(@"user: %@  path: %@",user, path);
            
            XmppTools *xmppTool = [XmppTools sharedxmpp];
            xmppTool.registerOperation = NO;  //是否为注册
            [xmppTool login:^(XMPPResultType xmppType) {
                [weakSelf handleLoginResult:xmppType];
            }];
        }else {
        
            [self hideHud];
            [self showHint:@"后台登录出错!"];
        }
    }];
  
}


- (void)handleLoginResult:(XMPPResultType)xmppType {

    //记得回到主线程， 因为代理在子线程调用
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self hideHud];
        switch (xmppType) {
            case XMPPResultSuccess: {
                [self showHint:@"登录成功"];
                [self changeToRootTabViewController];
                break;
            }
            case XMPPResultFaiture: {
                [self showHint:@"用户名或密码错误"];
                break;
            }
            case XMPPResultNetworkErr: {
                [self showHint:@"网络不给力"];

                break;
            }
            case XMPPResultRegisterSuccess: {
                break;
            }

            case XMPPResultRegisterFailture: {
                break;
            }

  
        }

    });

}

#pragma mark 登录成功后进入主界面

- (void)changeToRootTabViewController {
    
    UserOperation *user=[UserOperation shareduser];
    user.loginStatus=YES; //登录成功保存登录状态
    
    [UserOperation loginByStatus];
}

#pragma mark 截取字符串空格的方法
- (NSString *)trim:(NSString *)str {

    str=[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
     //转成小写
    return [str lowercaseString];
}


- (void)dealloc {

    NSLog(@"LoginControllerdealloc");
}
@end
