//
//  APDContentStreamCell.m
//  appodeal_ios_demo_app
//
//  Created by Lozhkin Ilya on 6/20/16.
//  Copyright © 2016 Lozhkin Ilya. All rights reserved.
//

#import "APDContentStreamCell.h"
#import "Masonry.h"
#import "Haneke.h"

@interface APDContentStreamCell ()

@property (nonatomic, strong) UIImageView* iconView;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* descriptionLabel;
@property (nonatomic, strong) APDMediaView* mediaView;
@property (nonatomic, strong) UILabel* callToActionLabel;
@property (nonatomic, strong) UILabel* adBadgeLabel;

@property (nonatomic, strong) APDNativeAd* nativeAd;

@end

@implementation APDContentStreamCell

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.nativeAd detachFromView];
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeConstrain];
        
        self.layer.borderWidth = 1.0;
        self.layer.cornerRadius = 2.0;
        self.layer.borderColor = UIColor.lightGrayColor.CGColor;
    }
    return self;
}

#pragma mark --- PUBLICK

- (void) setNativeAd:(APDNativeAd *)nativeAd fromViewController:(UIViewController *)controller{
    self.nativeAd = nativeAd;
    [self.nativeAd attachToView:self.contentView viewController:controller];
    
    [self.mediaView setNativeAd:self.nativeAd rootViewController:controller];
    
    if (![[self.nativeAd.iconImage.url absoluteString] containsString:@"file://"]) {
        [self.iconView hnk_setImageFromURL:self.nativeAd.iconImage.url placeholder:nil];
    }else{
        [self.iconView setImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:[self.nativeAd.iconImage.url absoluteString]]]];
    }
    
    self.titleLabel.text = self.nativeAd.title;
    self.descriptionLabel.text = self.nativeAd.descriptionText;
    self.callToActionLabel.text = self.nativeAd.callToActionText;
}

#pragma mark --- CONSTRAIN

- (void) makeConstrain {

    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.top.and.left.equalTo(self.contentView).with.offset(5);
    }];
    [self.adBadgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(5);
        make.right.equalTo(self.contentView).with.offset(-5);
        make.width.lessThanOrEqualTo(@24);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconView);
        make.left.equalTo(self.iconView.mas_right).with.offset(5);
        make.right.equalTo(self.adBadgeLabel.mas_left).with.offset(-5);
    }];
    
    [self.mediaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.contentView);
        make.top.equalTo(self.iconView.mas_bottom).with.offset(5);
    }];
    
    [self.callToActionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(120, 30));
        make.top.equalTo(self.mediaView.mas_bottom).with.offset(5);
        make.bottom.and.right.equalTo(self.contentView).with.offset(-5);
    }];
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(5);
        make.right.equalTo(self.callToActionLabel.mas_left).with.offset(-5);
        make.centerY.equalTo(self.callToActionLabel);
        make.height.lessThanOrEqualTo(@40);
    }];
}

#pragma mark --- PROPERTY

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _iconView.layer.cornerRadius = 5;
        _iconView.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconView];
    }
    return _iconView;
}

- (APDMediaView *)mediaView {
    if (!_mediaView) {
        _mediaView = [[APDMediaView alloc] initWithFrame:CGRectMake(0, 0, 300, 120)];
        [self.contentView addSubview:_mediaView];
    }
    return _mediaView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = [UIColor darkTextColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)descriptionLabel {
    if (!_descriptionLabel){
        _descriptionLabel = [UILabel new];
        _descriptionLabel.font = [UIFont systemFontOfSize:12];
        _descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _descriptionLabel.numberOfLines = 3;
        _descriptionLabel.textAlignment = NSTextAlignmentCenter;
        _descriptionLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_descriptionLabel];
    }
    return _descriptionLabel;
}

- (UILabel *)adBadgeLabel {
    if (!_adBadgeLabel){
        _adBadgeLabel = [UILabel new];
        _adBadgeLabel.backgroundColor = [UIColor darkGrayColor];
        _adBadgeLabel.text = @"Ad";
        _adBadgeLabel.textColor = [UIColor whiteColor];
        _adBadgeLabel.textAlignment = NSTextAlignmentCenter;
        _adBadgeLabel.font = [UIFont systemFontOfSize:10];
        _adBadgeLabel.layer.cornerRadius = 2.0f;
        [self.contentView addSubview:_adBadgeLabel];
    }
    return _adBadgeLabel;
}

- (UILabel *)callToActionLabel{
    if (!_callToActionLabel){
        _callToActionLabel = [UILabel new];
        _callToActionLabel.textColor = [UIColor darkGrayColor];
        _callToActionLabel.textAlignment = NSTextAlignmentCenter;
        _callToActionLabel.font = [UIFont systemFontOfSize:12];
        _callToActionLabel.layer.cornerRadius = 5.0f;
        _callToActionLabel.layer.borderWidth = 1.0f;
        _callToActionLabel.layer.borderColor = [UIColor darkGrayColor].CGColor;
        [self.contentView addSubview:_callToActionLabel];
    }
    return _callToActionLabel;
}

@end
