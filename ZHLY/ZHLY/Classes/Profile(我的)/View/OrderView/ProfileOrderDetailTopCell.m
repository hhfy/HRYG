//
//  ProfileOrderDetailTopCell.m
//  ZHLY
//
//  Created by Moussirou Serge Alain on 2018/3/5.
//  Copyright © 2018年 Mr LAI. All rights reserved.
//

#import "ProfileOrderDetailTopCell.h"
#import <CoreImage/CoreImage.h>
#import "Profile.h"

@interface ProfileOrderDetailTopCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;

@end

@implementation ProfileOrderDetailTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setOrderInfo:(ProfileOrderInfo *)orderInfo {
    _orderInfo = orderInfo;
    self.codeLabel.text = (orderInfo.biz_check_code.length>0) ? [NSString stringWithFormat:@"验证码：%@",orderInfo.biz_check_code] : @"--";
    self.codeLabel.layer.borderColor = SetupColor(227, 227, 227).CGColor;
    self.imgView.layer.borderColor = SetupColor(227, 227, 227).CGColor;
    if(orderInfo.biz_check_code.length>0){
        CIImage *ciImage = [self getImageByString:orderInfo.biz_check_code];
        self.imgView.image = [self excludeFuzzyImageFromCIImage:ciImage size:150];
    }
}

- (CIImage *)getImageByString:(NSString *)dataString {
    //首先判断字符串是否合理！
    if (!dataString || dataString == nil || [dataString isEqualToString:@""]){
        return nil;
    }
    //实例化一个滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //1、设置filter的默认值，防止之前的设置对本次转化有影响
    [filter setDefaults];
    //2、将传入的字符串转换为NSData
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    //3、将NSData传递给滤镜（通过KVC的方式，设置inputMessage）
    [filter setValue:data forKey:@"inputMessage"];
    //4、由filter对象输出图像
    CIImage *outputImage = [filter outputImage];
    //5、返回二维码图像
    return outputImage;
}
#pragma mark -- 对图像进行清晰处理，很关键！
- (UIImage *)excludeFuzzyImageFromCIImage: (CIImage *)image size: (CGFloat)size {
    CGRect extent = CGRectIntegral(image.extent);
    //通过比例计算，让最终的图像大小合理（正方形是我们想要的）
    CGFloat scale = MIN(size / CGRectGetWidth(extent), size / CGRectGetHeight(extent));
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext * context = [CIContext contextWithOptions: nil];
    CGImageRef bitmapImage = [context createCGImage: image fromRect: extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    //切记ARC模式下是不会对CoreFoundation框架的对象进行自动释放的，所以要我们手动释放
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    CGColorSpaceRelease(colorSpace);
    return [UIImage imageWithCGImage: scaledImage];
}

@end
