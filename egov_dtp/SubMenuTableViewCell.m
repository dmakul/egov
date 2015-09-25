#import "SubMenuTableViewCell.h"
@implementation SubMenuTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(!self){
        return nil;
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor clearColor];
    
    CGSize imageSize = CGSizeMake(70, 70);
    self.image = [[UIImageView alloc] init];
    self.image.contentMode = UIViewContentModeScaleAspectFill;
    self.image.layer.cornerRadius = 35;
    self.image.clipsToBounds = YES;
    [self.contentView addSubview:self.image];
    
    UIEdgeInsets imagePadding = UIEdgeInsetsMake(5, 10, 5, 10);
    [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(imagePadding.top);
        make.left.equalTo(self.mas_left).with.offset(imagePadding.left);
        make.bottom.equalTo(self.mas_bottom).with.offset(-imagePadding.bottom);
        make.width.equalTo(@(imageSize.width));
        make.height.equalTo(@(imageSize.height));
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.nameLabel];
    self.nameLabel.font = [UIFont fontWithName:FontMedium size:[UIFont subHeaderFont]];
    UIEdgeInsets nameLabelPadding = UIEdgeInsetsMake(20, 15, 10, 20);
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.image.mas_right).with.offset(nameLabelPadding.left);
        make.top.equalTo(self.mas_top).with.offset(nameLabelPadding.top);
        make.width.equalTo(@(SCREEN_WIDTH-115));
    }];
    
    self.priceLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.priceLabel];
    self.priceLabel.textAlignment = NSTextAlignmentLeft;
    self.priceLabel.font = [UIFont fontWithName:FontMedium size:[UIFont fontForSmallText]];
    self.priceLabel.textColor = [UIColor grayColor];
    
    UIEdgeInsets priceLabelPadding = UIEdgeInsetsMake(10, 2, 5, 5);
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.image.mas_right).with.offset(nameLabelPadding.left);
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(priceLabelPadding.top);
        make.width.equalTo(@(SCREEN_WIDTH-115));
    }];
    
    self.viewsLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.viewsLabel];
    self.viewsLabel.textAlignment = NSTextAlignmentLeft;
    self.viewsLabel.font = [UIFont fontWithName:FontMedium size:[UIFont fontForSmallText]];
    self.viewsLabel.textColor = [UIColor lightGrayColor];
    
    UIEdgeInsets viewsLabelPadding = UIEdgeInsetsMake(0, 5, 10, 10);
    [self.viewsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(viewsLabelPadding.top);
        make.left.equalTo(self.image.mas_right).with.offset(viewsLabelPadding.left);
    }];
    
    CGSize viewsImageSize = CGSizeMake(15, 8.5);
    self.viewsImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.viewsImageView];
    self.viewsImageView.contentMode = UIViewContentModeScaleToFill;
    
    [self.viewsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.viewsLabel.mas_centerY);
        make.left.equalTo(self.viewsLabel.mas_right).with.offset(priceLabelPadding.left);
        make.height.equalTo(@(viewsImageSize.height));
        make.width.equalTo(@(viewsImageSize.width));
    }];
    
    return self;
}
@end