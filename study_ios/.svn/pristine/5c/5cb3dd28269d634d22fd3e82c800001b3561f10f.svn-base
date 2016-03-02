//
//  AddCardViewController.m
//  study
//
//  Created by mijibao on 16/2/1.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "AddCardViewController.h"

@interface AddCardViewController ()<UIAlertViewDelegate, UITextFieldDelegate>

@end

@implementation AddCardViewController
{
    UIView *_firstView;//第一步页面
    UIView *_secondView;//第二步页面
    UIButton *_nextBtn;
    UITextField *_totalTextField;
    NSMutableArray *_classTextField;
    BOOL isSecondStepView;//判断是否已进入第二步页面
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNavgation];
    [self creatUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)creatNavgation
{
    self.title = @"添加银行卡";
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)creatUI
{
    _firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, Main_Height)];
    [self.view addSubview:_firstView];
    UILabel *signLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, Main_Width, 30)];
    [self setStatusOfLabel:signLabel title:@"请输入支付密码，以验证身份" fontSize:13 color:UIColorFromRGB(0x656565) textAligement:NSTextAlignmentCenter];
    [_firstView addSubview:signLabel];
    
    _totalTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, Main_Width, Main_Height)];
    _totalTextField.hidden = YES;
    _totalTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_totalTextField addTarget:self action:@selector(insertPassWord) forControlEvents:UIControlEventEditingChanged];
    [_firstView addSubview:_totalTextField];
    [_totalTextField becomeFirstResponder];
    _classTextField = [[NSMutableArray alloc] init];
    for (int i = 0; i < 6; i++)
    {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake((Main_Width - 240) * 0.5 + i * 40, 100, 40, 40)];
        textField.layer.borderColor = [UIColor redColor].CGColor;
        textField.enabled = NO;
        textField.textAlignment = NSTextAlignmentCenter;//居中
        textField.secureTextEntry = YES;//设置密码模式
        textField.layer.borderWidth = 1;
        [_firstView addSubview:textField];
        [_classTextField addObject:textField];
    }
}

- (void)insertPassWord
{
    NSString *insertString = _totalTextField.text;
    if (insertString.length == 6) {
        if ([insertString isEqualToString:@"123456"]) {
            NSLog(@"验证成功，跳转至下一个界面");
            [_firstView removeFromSuperview];
            [self creatSecondView];
        }else{
            [_totalTextField resignFirstResponder];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付密码错误，请重试" message:nil delegate:self cancelButtonTitle:@"重试" otherButtonTitles:@"忘记密码", nil];
            [alert show];
        }
    }
    for (int i = 0; i < insertString.length; i ++) {
        UITextField *textField = [_classTextField objectAtIndex:i];
        NSString *classString = [insertString substringWithRange:NSMakeRange(i, 1)];
        textField.text = classString;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {//点击重试
        _totalTextField.text = nil;
        for (int i = 0; i < 6; i ++){
            UITextField *textField = [_classTextField objectAtIndex:i];
            textField.text = nil;
        }
        [_totalTextField becomeFirstResponder];
    }else{//点击忘记密码
        NSLog(@"点击的是忘记密码");
    }
}

- (void)creatSecondView
{
    _secondView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, Main_Height)];
    [self.view addSubview:_secondView];
    UILabel *signLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, Main_Width, 30)];
    [self setStatusOfLabel:signLabel title:@"请绑定持卡人本人的银行卡号" fontSize:13 color:UIColorFromRGB(0x656565) textAligement:NSTextAlignmentLeft];
    _secondView.userInteractionEnabled = YES;
    [_secondView addSubview:signLabel];
    UIView *insertView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(signLabel) + 5, Main_Width, 81)];
    insertView.backgroundColor = [UIColor whiteColor];
    insertView.userInteractionEnabled = YES;
    [_secondView addSubview:insertView];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 40, Main_Width - 20, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xe2e2e2);
    [insertView addSubview:lineView];
    NSArray *array = @[@"持卡人", @"卡号"];
    NSArray *imageArray = @[@"AddCard_Namer",@"AddCard_Photo"];
    for (int i = 0; i < 2; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, i * 41, 60, 40)];
        [self setStatusOfLabel:label title:array[i] fontSize:13 color:UIColorFromRGB(0x656565) textAligement:NSTextAlignmentLeft];
        [insertView addSubview:label];
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(MaxX(label), MinY(label), Main_Width - MaxX(label) - 40, 40)];
        if (i == 0) {
            textField.text = @"Jackson";
            textField.userInteractionEnabled = NO;
        }else{
            textField.placeholder = @"请输入银行卡号";
            textField.keyboardType = UIKeyboardTypeNumberPad;
            [textField addTarget:self action:@selector(cardInsertChanged:) forControlEvents:UIControlEventEditingChanged];
        }
        textField.font = [UIFont systemFontOfSize:13];
        textField.textColor = UIColorFromRGB(0x656565);
        textField.tag = 100 + i;
        textField.textAlignment = NSTextAlignmentLeft;
        textField.delegate = self;
        [insertView addSubview:textField];
        UIImage *image = [UIImage imageNamed:imageArray[i]];
        UIImageView *leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(MaxX(textField), 13 + i * 40, 14, 14)];;
        leftImage.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
        [leftImage setImage:[UIImage imageNamed:imageArray[i]]];
        leftImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedLeftBtn:)];
        leftImage.tag = 1000 + i;
        [leftImage addGestureRecognizer:gesture];
        [insertView addSubview:leftImage];
    }
    _nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, MaxY(insertView) + 10, Main_Width, 40)];
    [self setBtnStatus:_nextBtn WithBackColor:UIColorFromRGB(0xff7949) withTitle:@"下一步" withTitleColor:[UIColor whiteColor] withFont:16];
    _nextBtn.enabled = NO;
    _nextBtn.userInteractionEnabled = NO;
    [_nextBtn addTarget:self action:@selector(nextStepClicked) forControlEvents:UIControlEventTouchUpInside];
    [_secondView addSubview:_nextBtn];
}

- (void)clickedLeftBtn:(UITapGestureRecognizer *)gesture
{
    if (gesture.view.tag == 1000) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"持卡人说明" message:@"为了您的账户安全，只能绑定持卡人本人的银行卡" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];

    }else{
        NSLog(@"跳转至银行卡扫描页面");
    }
}

#pragma mark 限制银行卡输入长度
- (void)cardInsertChanged:(UITextField *)textField
{//当输入的银行卡号少于14位时，不可以点击下一步按钮
    if (textField.text.length >= 14) {
        _nextBtn.enabled = YES;
        _nextBtn.userInteractionEnabled = YES;
    }else{
        _nextBtn.enabled = NO;
        _nextBtn.userInteractionEnabled = NO;
    }
}

- (void)nextStepClicked
{
   UITextField *cardTextField = (UITextField *)[self.view viewWithTag:101];
    if ([self checkCardNo:cardTextField.text]){//在前端对手机号进行简单点校验，如果通过则跳转至下一页
        NSLog(@"跳转至下一页");
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的银行卡号" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)setBtnStatus:(UIButton *)btn WithBackColor:(UIColor *)backcolor withTitle:(NSString *)title withTitleColor:(UIColor *)titlecolor withFont:(NSInteger)fontsize
{
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundColor:backcolor];
    [btn setTitleFont:[UIFont systemFontOfSize:fontsize]];
    [btn setTitleColor:titlecolor forState:UIControlStateNormal];
}

- (void)setStatusOfLabel:(UILabel *)label
                   title:(NSString *)text
                fontSize:(CGFloat)size
                   color:(UIColor *)color
           textAligement:(NSTextAlignment)aligement
{
    label.text = text;
    label.textColor = color;
    label.textAlignment = aligement;
    label.font = [UIFont systemFontOfSize:size];

}

#pragma mark 银行卡校验
- (BOOL) checkCardNo:(NSString*) cardNo{
    int oddsum = 0;     //奇数求和
    int evensum = 0;    //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[cardNo length];
    int lastNum = [[cardNo substringFromIndex:cardNoLength-1] intValue];
    cardNo = [cardNo substringToIndex:cardNoLength - 1];
    for (int i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1, 1)];
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 ==1 ) {
            if((i % 2) == 0){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0)
        return YES;
    else
        return NO;
}

@end
