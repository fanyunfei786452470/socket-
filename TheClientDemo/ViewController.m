//
//  ViewController.m
//  TheClientDemo
//
//  Created by 范云飞 on 2017/10/13.
//  Copyright © 2017年 范云飞. All rights reserved.
//

#import "ViewController.h"

#import "GCDASYncSocket.h"

@interface ViewController ()<GCDAsyncSocketDelegate>
@property (strong, nonatomic) IBOutlet UITextField *IPTextField;
@property (strong, nonatomic) IBOutlet UITextField *PortTextField;
@property (strong, nonatomic) IBOutlet UITextField *sendTextField;
@property (strong, nonatomic) IBOutlet UIButton *ConnectBtn;
@property (strong, nonatomic) IBOutlet UIButton *SendBtn;
@property (strong, nonatomic) IBOutlet UIButton *ReceiveBtn;
@property (strong, nonatomic) IBOutlet UITextView *ResultTextView;

@property (nonatomic) GCDAsyncSocket * clinetSocket;/* 客户端socket */
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.ResultTextView.editable = NO;
    /* 初始化 */
    self.clinetSocket= [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    self.IPTextField.text = @"169.254.242.36";
    self.PortTextField.text = @"8080";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - GCDAsynSocket Delegate

- (void)socket:(GCDAsyncSocket*)sock didConnectToHost:(NSString*)host port:(uint16_t)port
{
    [self showMessageWithStr:@"链接成功"];
    [self showMessageWithStr:[NSString stringWithFormat:@"服务器IP：%@", host]];
    [self.clinetSocket readDataWithTimeout:-1 tag:0];
}

/* 收到消息 */
- (void)socket:(GCDAsyncSocket*)sock didReadData:(NSData*)data withTag:(long)tag
{
    NSString*text = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    [self showMessageWithStr:text];
    [self.clinetSocket readDataWithTimeout:-1 tag:0];
}

/* 开始连接 */
- (IBAction)Cnnect:(id)sender
{
    /* 连接服务器 */
    [self.clinetSocket connectToHost:self.IPTextField.text onPort:self.PortTextField.text.integerValue withTimeout:-1 error:nil];
}

/* 发送消息 */
- (IBAction)sendMessage:(id)sender {
    NSData*data = [self.sendTextField.text dataUsingEncoding:NSUTF8StringEncoding];
    //withTimeout -1 :无穷大
    //tag：消息标记
    [self.clinetSocket writeData:data withTimeout:-1 tag:0];
}

/* 接收消息 */
- (IBAction)receiveMessage:(id)sender
{
    [self.clinetSocket readDataWithTimeout:11 tag:0];
}

/* 断开连接 */
- (IBAction)disConnect:(id)sender
{
    [self.clinetSocket disconnect];
}

- (void)showMessageWithStr:(NSString*)str
{
    self.ResultTextView.text= [self.ResultTextView.text stringByAppendingFormat:@"%@\n", str];
}


@end
