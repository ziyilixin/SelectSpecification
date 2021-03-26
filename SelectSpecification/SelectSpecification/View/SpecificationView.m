//
//  SpecificationView.m
//  SelectSpecification
//
//  Created by Mac on 2021/3/26.
//

#import "SpecificationView.h"
#import "Specification.h"
#import "SpecificationCell.h"
#import "SpecificationHeadView.h"

static float const kCollectionViewCellHeight                  = 40;
static float const kCellBtnCenterToBorderMargin               = 20;
static float const kCollectionViewToLeftMargin                = 20;
static float const kCollectionViewToRightMargin               = 20;
static float const kCollectionViewCellsHorizonMargin          = 10;

typedef void(^ISLimitWidth)(BOOL yesORNo, id data);

@interface SpecificationView ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UIImageView *productImageView;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *inventoryLabel;
@property (nonatomic, strong) UILabel *selectLabel;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *buyButton;

@property (nonatomic, assign) NSInteger countNum;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UITextField *countTextField;
@property (nonatomic, strong) UIButton *deleteButton;
@end

static NSString * const cellId = @"SpecificationCell";
static NSString * const headViewId = @"SpecificationHeadView";

@implementation SpecificationView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGB_COLOR(@"#000000", 0.3);
        [self createUI];
        [self loadData];
    }
    return self;
}

- (void)createUI {
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 0.2, SCREEN_WIDTH, SCREEN_HEIGHT * 0.8)];
    backView.backgroundColor = [UIColor whiteColor];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:backView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(6, 6)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = backView.bounds;
    maskLayer.path = maskPath.CGPath;
    backView.layer.mask = maskLayer;
    [self addSubview:backView];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(SCREEN_WIDTH - 30, 15, 20, 20);
    [closeButton setImage:[UIImage imageNamed:@"common_close_black"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(onClickClose:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:closeButton];
    
    UIImageView *productImageView = [[UIImageView alloc] init];
    productImageView.frame = CGRectMake(20, 15, 100, 100);
    productImageView.layer.cornerRadius = 4;
    productImageView.layer.masksToBounds = YES;
    productImageView.contentMode = UIViewContentModeScaleAspectFill;
    productImageView.backgroundColor = [UIColor greenColor];
    [backView addSubview:productImageView];
    self.productImageView = productImageView;
    
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.textColor = RGB_COLOR(@"#FF5403", 1.0);
    priceLabel.font = [UIFont systemFontOfSize:16.0];
    NSString *priceStr = @"￥299.0";
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:priceStr];
    NSRange range = [priceStr rangeOfString:[NSString stringWithFormat:@"￥"]];
    [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:range];
    priceLabel.attributedText = att;
    [backView addSubview:priceLabel];
    self.priceLabel = priceLabel;
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productImageView.mas_right).offset(9);
        make.top.equalTo(self.productImageView).offset(18);
    }];
    
    UILabel *inventoryLabel = [[UILabel alloc] init];
    inventoryLabel.text = [NSString stringWithFormat:@"库存6599件"];
    inventoryLabel.textColor = RGB_COLOR(@"#333333", 1.0);
    inventoryLabel.font = [UIFont systemFontOfSize:12.0];
    [backView addSubview:inventoryLabel];
    self.inventoryLabel = inventoryLabel;
    [self.inventoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLabel);
        make.top.equalTo(self.priceLabel.mas_bottom).offset(8);
    }];
    
    UILabel *selectLabel = [[UILabel alloc] init];
    selectLabel.textColor = RGB_COLOR(@"#333333", 1.0);
    selectLabel.font = [UIFont systemFontOfSize:12.0];
    [backView addSubview:selectLabel];
    self.selectLabel = selectLabel;
    [self.selectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLabel);
        make.top.equalTo(self.inventoryLabel.mas_bottom).offset(8);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB_COLOR(@"#EAEAEA", 1.0);
    [backView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(20);
        make.right.equalTo(backView).offset(-20);
        make.top.equalTo(self.productImageView.mas_bottom).offset(20);
        make.height.mas_equalTo(1.0);
    }];
    
    UICollectionViewLeftAlignedLayout *layout = [[UICollectionViewLeftAlignedLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.contentInset = UIEdgeInsetsMake(0, 0, ShowDiff + 80 + 88, 0);
    collectionView.allowsMultipleSelection = YES;
    [backView addSubview:collectionView];
    self.collectionView = collectionView;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(backView);
        make.top.equalTo(lineView.mas_bottom);
    }];
    
    [self.collectionView registerClass:[SpecificationCell class] forCellWithReuseIdentifier:cellId];
    [self.collectionView registerClass:[SpecificationHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headViewId];
    
    //底部
    UIView *contView = [[UIView alloc] init];
    contView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:contView];
    [contView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(backView);
        make.height.mas_equalTo(ShowDiff + 80 + 88);
    }];
    
    UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyButton setTitle:@"确定" forState:UIControlStateNormal];
    [buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buyButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    buyButton.backgroundColor = RGB_COLOR(@"#FF5403", 1.0);
    buyButton.layer.cornerRadius = 12;
    buyButton.layer.masksToBounds = YES;
    [buyButton addTarget:self action:@selector(submitSpecification) forControlEvents:UIControlEventTouchUpInside];
    [contView addSubview:buyButton];
    self.buyButton = buyButton;
    [self.buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contView).offset(20);
        make.right.equalTo(contView).offset(-20);
        make.bottom.equalTo(contView).offset(-ShowDiff-30);
        make.height.mas_equalTo(40);
    }];
    
    UIView *lineView2 = [[UIView alloc] init];
    lineView2.backgroundColor = RGB_COLOR(@"#EAEAEA", 1.0);
    [contView addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contView).offset(20);
        make.right.equalTo(contView).offset(-20);
        make.top.equalTo(contView);
        make.height.mas_equalTo(1.0);
    }];
    
    UILabel *quantityLabel = [[UILabel alloc] init];
    quantityLabel.text = @"购买数量";
    quantityLabel.textColor = RGB_COLOR(@"#101010", 1.0);
    quantityLabel.font = [UIFont systemFontOfSize:16.0];
    [contView addSubview:quantityLabel];
    [quantityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contView).offset(20);
        make.bottom.equalTo(self.buyButton.mas_top).offset(-30);
    }];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:[UIImage imageNamed:@"shop_add"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addCount) forControlEvents:UIControlEventTouchUpInside];
    [contView addSubview:addButton];
    self.addButton = addButton;
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contView).offset(-20);
        make.centerY.equalTo(quantityLabel);
        make.width.height.mas_equalTo(20);
    }];
    
    self.countNum = 1;
    
    UITextField *countTextField = [[UITextField alloc] init];
    countTextField.textAlignment = NSTextAlignmentCenter;
    countTextField.backgroundColor = [UIColor whiteColor];
    countTextField.textColor = RGB_COLOR(@"#606266", 1.0);
    countTextField.font = [UIFont systemFontOfSize:14.0];
    countTextField.text = [NSString stringWithFormat:@"%zd",self.countNum];
    countTextField.userInteractionEnabled = NO;
    [contView addSubview:countTextField];
    self.countTextField = countTextField;
    [self.countTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.addButton.mas_left);
        make.centerY.equalTo(quantityLabel);
        make.width.mas_equalTo(60);
        make.height.equalTo(self.addButton);
    }];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setImage:[UIImage imageNamed:@"shop_delete"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteCount) forControlEvents:UIControlEventTouchUpInside];
    [contView addSubview:deleteButton];
    self.deleteButton = deleteButton;
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.countTextField.mas_left);
        make.centerY.equalTo(quantityLabel);
        make.width.height.equalTo(self.addButton);
    }];
    
}

- (void)loadData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Specification" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    id info = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    self.dataArray = [Specification mj_objectArrayWithKeyValuesArray:info];
    NSMutableArray *specificationArray = [NSMutableArray array];
    for (int i = 0; i < self.dataArray.count; i++) {
        Specification *specification = self.dataArray[i];
        [specificationArray addObject:specification.name];
    }
    NSString *specificationStr = [[specificationArray copy] componentsJoinedByString:@"、"];
    self.selectLabel.text = [NSString stringWithFormat:@"请选择: %@",specificationStr];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    Specification *specification = self.dataArray[section];
    return specification.value.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SpecificationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    Specification *specification = self.dataArray[indexPath.section];
    cell.titleLabel.text = specification.value[indexPath.item];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqual:UICollectionElementKindSectionHeader]) {
        SpecificationHeadView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headViewId forIndexPath:indexPath];
        Specification *specification = self.dataArray[indexPath.section];
        headView.titleLabel.text = specification.name;
        return headView;
    }
    else {
        return nil;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    Specification *specification = self.dataArray[indexPath.section];
    float cellWidth = [self collectionCellWidthText:specification.value[indexPath.item]];
    return CGSizeMake(cellWidth, kCollectionViewCellHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return kCollectionViewCellsHorizonMargin;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SCREEN_WIDTH, 50);
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *indexPathsArray = [self.collectionView indexPathsForSelectedItems];
    for (NSIndexPath *index in indexPathsArray) {
        if (index.section == indexPath.section) {
            [self.collectionView deselectItemAtIndexPath:index animated:YES];
            [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
}

- (float)collectionCellWidthText:(NSString *)text{
    float cellWidth;
    CGSize size = [text sizeWithAttributes:
                   @{NSFontAttributeName:
                         [UIFont systemFontOfSize:14.0]}];
    cellWidth = ceilf(size.width) + kCellBtnCenterToBorderMargin;
    cellWidth = [self cellLimitWidth:cellWidth
                         limitMargin:0
                        isLimitWidth:nil];
    return cellWidth;
}

- (float)cellLimitWidth:(float)cellWidth
            limitMargin:(CGFloat)limitMargin
           isLimitWidth:(ISLimitWidth)isLimitWidth {
    float limitWidth = (CGRectGetWidth(self.collectionView.frame) - kCollectionViewToLeftMargin - kCollectionViewToRightMargin - limitMargin);
    if (cellWidth >= limitWidth) {
        cellWidth = limitWidth;
        isLimitWidth ? isLimitWidth(YES, @(cellWidth)) : nil;
        return cellWidth;
    }
    isLimitWidth ? isLimitWidth(NO, @(cellWidth)) : nil;
    return cellWidth;
}

#pragma mark - Event

- (void)onClickClose:(UIButton *)button {
    [self removeFromSuperview];
}

- (void)addCount {
    self.countNum += 1;
    self.countTextField.text = [NSString stringWithFormat:@"%zd",self.countNum];
}

- (void)deleteCount {
    if (self.countNum == 1) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"最小数量为1件";
        [hud hideAnimated:YES afterDelay:2.f];
        return;
    }
    self.countNum -= 1;
    self.countTextField.text = [NSString stringWithFormat:@"%zd",self.countNum];
}

- (void)submitSpecification {
    NSLog(@"提交");
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

@end
