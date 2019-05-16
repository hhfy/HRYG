
//
//  TravelsTrafficGuideSetcionHeaderView.m
//  ZHLY
//
//  Created by LTWL on 2017/11/30.
//  Copyright © 2017年 LTWL. All rights reserved.
//

#import "TravelsTrafficGuideSetcionHeaderView.h"
#import "Travels.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface TravelsTrafficGuideSetcionHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *navigationBtn;
@property (nonatomic, strong) CLGeocoder *geocoder;
@end

@implementation TravelsTrafficGuideSetcionHeaderView

- (CLGeocoder *)geocoder
{
    if (_geocoder == nil)
    {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.navigationBtn.titleLabel.font = self.addressLabel.font = IconFont(14);
    [self.navigationBtn setTitle:[NSString stringWithFormat:@"%@ 导航", NavigationIconUnicode] forState:UIControlStateNormal];
}

- (void)setTrafficAddress:(TravelTrafficAddress *)trafficAddress {
    _trafficAddress = trafficAddress;
    self.addressLabel.text = [NSString stringWithFormat:@"%@ %@", LocationIconUnicode2, trafficAddress.info];
}

- (IBAction)navigationBtnTap:(UIButton *)button {
//    [self.geocoder geocodeAddressString:self.trafficAddress.info completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//        if (!error) {
//            // placemarks地标数组，存在着地标，每一个地标包含了该位置的经纬度以及城市区域，国家代码，邮编等等信息
//            CLPlacemark *placeMark = [placemarks firstObject];
//            [self lineNavigationWithcLLocationCoordinate2D:CLLocationCoordinate2DMake(placeMark.location.coordinate.latitude , placeMark.location.coordinate.longitude)];
//        }
//        else{
//            [SVProgressHUD showError:@"输入有误"];
//            NSLog(@"error--%@",[error localizedDescription]);
//        }
//    }];
    [self lineNavigationWithcLLocationCoordinate2D:CLLocationCoordinate2DMake(self.trafficAddress.lat , self.trafficAddress.lon)];
}

- (void)lineNavigationWithcLLocationCoordinate2D:(CLLocationCoordinate2D)cLLocationCoordinate2D {
    CLLocationCoordinate2D loc = cLLocationCoordinate2D;
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:loc addressDictionary:nil]];
    [MKMapItem openMapsWithItems:@[currentLocation, toLocation] launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                                                                MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
}


@end
