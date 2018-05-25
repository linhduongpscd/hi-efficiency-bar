//
//  TouchHelper.h
//  Hi-Efficiency Bar
//
//  Created by QTS Coder on 23/05/2018.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TouchHelper : NSObject
+ (BOOL) isBiometricIDAvailable;
+ (BOOL) isTouchIDAvailable;
+ (BOOL) supportFaceID;
+ (BOOL) isFaceIDAvailable;
@end
