//
//  ViewController.m
//  SelectSpecification
//
//  Created by Mac on 2021/3/26.
//

#import "ViewController.h"
#import "SpecificationView.h"

@interface ViewController ()
@property (nonatomic, strong) SpecificationView *specificationView;
@property (nonatomic, strong) UIButton *selectButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectButton setTitle:@"选择规格" forState:UIControlStateNormal];
    [selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    selectButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    selectButton.frame = CGRectMake(0, 0, 200, 40);
    selectButton.center = self.view.center;
    [selectButton addTarget:self action:@selector(selectSpecification:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectButton];
    self.selectButton = selectButton;
}

- (void)selectSpecification:(UIButton *)button {
    if (self.specificationView) {
        [self.specificationView removeFromSuperview];
        self.specificationView = nil;
    }
    
    self.specificationView = [[SpecificationView alloc] init];
    self.specificationView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    WeakSelf;
    self.specificationView.block = ^(NSString * _Nonnull specification, NSString * _Nonnull count) {
        [weakSelf.specificationView removeFromSuperview];
        weakSelf.specificationView = nil;
        [weakSelf.selectButton setTitle:[NSString stringWithFormat:@"规格:%@ 数量:%@",specification,count] forState:UIControlStateNormal];
    };
    [self.view addSubview:self.specificationView];
}


@end
