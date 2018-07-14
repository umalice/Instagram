//
//  CommentViewController.m
//  Instagram
//
//  Created by Alice Park on 7/12/18.
//  Copyright © 2018 Alice Park. All rights reserved.
//

#import "CommentViewController.h"
#import "ParseUI.h"
#import "Comment.h"
#import "CommentCell.h"

@interface CommentViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet PFImageView *myProfilePic;
@property (weak, nonatomic) IBOutlet UITextField *commentField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *comments;
@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (assign, nonatomic) BOOL done;

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self refresh];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refresh) userInfo:nil repeats:true];
    
    self.myProfilePic.layer.cornerRadius = self.myProfilePic.frame.size.width / 2;
    PFUser *myUser = [PFUser currentUser];
    self.myProfilePic.file = myUser[@"pic"];
    [self.myProfilePic loadInBackground];
    
    
    UITapGestureRecognizer *hideTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKB)];
    [self.view addGestureRecognizer:hideTapGestureRecognizer];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKB {
    
    [self.commentField resignFirstResponder];
    if(!self.done) {
        [UIView animateWithDuration:0.2 animations:^{
            
            CGRect newFrame = self.commentView.frame;
            newFrame.origin.y += 166;
            self.commentView.frame = newFrame;
            
        }];
        self.done = YES;
    }
    
    
}

- (void)refresh {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Comment"];
    [query orderByAscending:@"createdAt"];
    [query includeKey:@"commenter"];
    [query includeKey:@"post"];
    
    [query whereKey:@"post" equalTo:self.post];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.comments = (NSMutableArray *)posts;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    
}

- (nonnull UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    
    [cell setComment:self.comments[indexPath.row]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.comments count];
}

- (IBAction)didTapPost:(id)sender {
    
    [self.commentField resignFirstResponder];
    self.done = YES;
    [UIView animateWithDuration:0.2 animations:^{
        
        CGRect newFrame = self.commentView.frame;
        newFrame.origin.y += 166;
        self.commentView.frame = newFrame;
        
    }];
    
    [Comment postComment:self.post withCommenter:[PFUser currentUser] withcomment:self.commentField.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        
        if(succeeded) {
            NSLog(@"Posted comment!");
        } else {
            NSLog(@"Error posting comment: %@", error.localizedDescription);
        }
    }];
    
    self.commentField.text = @"";
    
}

- (IBAction)didBeginEditing:(id)sender {
    
    self.done = NO;
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect newFrame = self.commentView.frame;
        newFrame.origin.y -= 166;
        self.commentView.frame = newFrame;
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
