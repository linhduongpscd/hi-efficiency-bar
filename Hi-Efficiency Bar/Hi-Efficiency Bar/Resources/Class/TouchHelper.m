//
//  TouchHelper.m
//  Hi-Efficiency Bar
//
//  Created by QTS Coder on 23/05/2018.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

#import "TouchHelper.h"
#import <UIKit/UIKit.h>
#import <LocalAuthentication/LocalAuthentication.h>
@implementation TouchHelper

typedef NS_ENUM(NSUInteger, BPDeviceType) {
    BPDeviceTypeUnknown,
    BPDeviceTypeiPhone4,
    BPDeviceTypeiPhone5,
    BPDeviceTypeiPhone6,
    BPDeviceTypeiPhone6Plus,
    BPDeviceTypeiPhone7,
    BPDeviceTypeiPhone7Plus,
    BPDeviceTypeiPhoneX,
    BPDeviceTypeiPad
};

+ (BPDeviceType)getDeviceType {
    double screenHeight = [[UIScreen mainScreen] bounds].size.height;
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        return BPDeviceTypeiPad;
        
    } else if (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPhone)
    {
        if (@available(iOS 11, *)) {
            UIEdgeInsets insets = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
            if (insets.top > 0) {
                return BPDeviceTypeiPhoneX;
            }
        }
        
        if(screenHeight == 480) {
            return BPDeviceTypeiPhone4;
        } else if (screenHeight == 568) {
            return BPDeviceTypeiPhone5;
        } else if (screenHeight == 667) {
            return BPDeviceTypeiPhone6;
        } else if (screenHeight == 736) {
            return BPDeviceTypeiPhone6Plus;
        }
    }
    return BPDeviceTypeUnknown;
}

+ (BOOL) isBiometricIDAvailable {
    if (![LAContext class]) return NO;
    
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    if (![myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        NSLog(@"%@", [authError localizedDescription]);
        return NO;
    }
    return YES;
}

+ (BOOL) isTouchIDAvailable {
    if (![LAContext class]) return NO;
    
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    if (![myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        NSLog(@"%@", [authError localizedDescription]);
        return NO;
        // if (authError.code == LAErrorTouchIDNotAvailable) {}
    }
    
    if (@available(iOS 11.0, *)) {
        if (myContext.biometryType == LABiometryTypeTouchID){
            return YES;
        } else {
            return NO;
        }
    } else {
        return YES;
    }
}

+ (BOOL) supportFaceID {
    return [self getDeviceType] == BPDeviceTypeiPhoneX;
}

+ (BOOL) isFaceIDAvailable {
    if (![LAContext class]) return NO;
    
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    if (![myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        NSLog(@"%@", [authError localizedDescription]);
        return NO;
    }
    
    if (@available(iOS 11.0, *)) {
        if (myContext.biometryType == LABiometryTypeFaceID){
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}
@end
