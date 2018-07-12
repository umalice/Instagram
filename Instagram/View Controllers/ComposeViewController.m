//
//  ComposeViewController.m
//  Instagram
//
//  Created by Alice Park on 7/9/18.
//  Copyright © 2018 Alice Park. All rights reserved.
//

#import "ComposeViewController.h"
#import "AppDelegate.h"
#import "HomeViewController.h"
#import "UIKit/UIKit.h"
#import "Post.h"
#import "MBProgressHUD.h"

@interface ComposeViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *cameraView;
@property (weak, nonatomic) IBOutlet UITextField *captionField;


@end

@implementation ComposeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UITapGestureRecognizer *cameraTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectPicture:)];

    [self.cameraView addGestureRecognizer:cameraTapGestureRecognizer];
    [self.cameraView setUserInteractionEnabled:YES];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didCancel:(id)sender {
    
    [self performSegueWithIdentifier:@"homeSegue" sender:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {

    //UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    UIImage *resizedImage = [self resizeImage:editedImage withSize:CGSizeMake(1024, 768)];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    self.photo = resizedImage;
    [self.cameraView setImage:self.photo];
    
    [self.captionField becomeFirstResponder];
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

- (void)selectPicture:(UITapGestureRecognizer *)sender{
    
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    UIAlertController *pictureViewController = [UIAlertController alertControllerWithTitle:@"Compose" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
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

- (IBAction)didPost:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Post postUserImage:self.photo withCaption:self.captionField.text withCompletion:^(BOOL succeeded, NSError  * _Nullable error) {
        if (succeeded) {
            NSLog(@"Shared photo!");
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self performSegueWithIdentifier:@"homeSegue" sender:nil];
        } else {
            NSLog(@"Error sharing photo: %@", error.localizedDescription);
        }
    }];
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
