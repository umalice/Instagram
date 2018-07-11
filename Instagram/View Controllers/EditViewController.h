//
//  EditViewController.h
//  Instagram
//
//  Created by Alice Park on 7/10/18.
//  Copyright © 2018 Alice Park. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface EditViewController : UIViewController

@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, strong) PFUser *currUser;

@end
