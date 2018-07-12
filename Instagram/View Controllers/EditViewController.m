//
//  EditViewController.m
//  Instagram
//
//  Created by Alice Park on 7/10/18.
//  Copyright © 2018 Alice Park. All rights reserved.
//

#import "EditViewController.h"
#import "ProfileViewController.h"
#import "ParseUI.h"
#import <UIKit/UIKit.h>

@interface EditViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet PFImageView *profilePic;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *bioField;

@end

@implementation EditViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if(self.currUser[@"pic"] == nil) {
        NSData *placeholderImageData = UIImagePNGRepresentation([UIImage imageNamed:@"profile_tab"]);
        self.currUser[@"pic"] = [PFFile fileWithName:@"pic.png" data:placeholderImageData];
    }
    
    self.profilePic.file = self.currUser[@"pic"];
    
    self.nameField.placeholder = self.currUser[@"name"];
    self.bioField.placeholder = self.currUser[@"bio"];
    
    [self.nameField becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (IBAction)changePicButton:(id)sender {
    
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    UIAlertController *pictureViewController = [UIAlertController alertControllerWithTitle:@"Change profile picture" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Take photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
        
    }];
    
    UIAlertAction *galleryAction = [UIAlertAction actionWithTitle:@"Choose from gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
        
    }];
    
    [pictureViewController addAction:cameraAction];
    [pictureViewController addAction:galleryAction];
    
    [self presentViewController:pictureViewController animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {

    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    UIImage *resizedImage = [self resizeImage:editedImage withSize:CGSizeMake(1024, 768)];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    self.photo = resizedImage;
    [self.profilePic setImage:resizedImage];
    
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (IBAction)didSave:(id)sender {
    
    if(! [self.nameField.text isEqualToString:@""]) {
        self.currUser[@"name"] = self.nameField.text;
    }
    
    if(! [self.bioField.text isEqualToString:@""]) {
        self.currUser[@"bio"] = self.bioField.text;
    }
    
    if(self.photo != nil) {
        NSData *imageData = UIImagePNGRepresentation(self.photo);
        self.currUser[@"pic"] = [PFFile fileWithName:@"profile.png" data:imageData];
    }
    
    [self.currUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded) {
            NSLog(@"Saved edits!");
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (IBAction)didCancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
