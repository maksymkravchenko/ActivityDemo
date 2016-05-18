//
//  EditorTableViewController.m
//  ActivityDemo
//
//  Created by Maksym Kravchenko on 5/18/16.
//  Copyright © 2016 Кравченко Максим. All rights reserved.
//

#import "EditorTableViewController.h"

//static const NSInteger kRowsCount = 3;

@interface EditorTableViewController ()

@property (weak, nonatomic) IBOutlet UITextView *noteTextView;

@end

@implementation EditorTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.noteTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -

- (IBAction)onSaveAction:(id)sender
{
}

- (IBAction)onCallTypeAction:(id)sender
{
}

- (IBAction)onMeetingTypeAction:(id)sender
{
}

- (IBAction)onTaskTypeAction:(id)sender
{
}

- (IBAction)onDateSelected:(UIDatePicker *)sender
{
//	sender.date
	NSLog(@"selected date");
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
