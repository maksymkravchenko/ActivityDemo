//
//  EditorTableViewController.m
//  ActivityDemo
//
//  Created by Maksym Kravchenko on 5/18/16.
//  Copyright © 2016 Кравченко Максим. All rights reserved.
//

#import "EditorTableViewController.h"
#import "AppDelegate.h"

//static const NSInteger kRowsCount = 3;

@interface EditorTableViewController ()

@property (weak, nonatomic) IBOutlet UITextView *noteTextView;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIButton *meetingButton;
@property (weak, nonatomic) IBOutlet UIButton *taskButton;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) ActivityType selectedActivityType;

@end

@implementation EditorTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.noteTextView becomeFirstResponder];
	self.callButton.selected = YES;
	self.selectedActivityType = kActivityTypeCall;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (IBAction)onCancelAction:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onSaveAction:(id)sender
{
	NSManagedObjectContext *context = self.managedObjectContext;
	

	NSManagedObject *newActivity = [NSEntityDescription insertNewObjectForEntityForName:@"Activity" inManagedObjectContext:context];
	
	[newActivity setValue:@(kActivityStatusActual) forKey:@"status"];
	[newActivity setValue:@(self.selectedActivityType) forKey:@"type"];
	[newActivity setValue:self.noteTextView.text forKey:@"note"];
	[newActivity setValue:self.datePicker.date forKey:@"date"];
	
	NSError *error = nil;
	if (![context save:&error])
	{
		NSLog(@"Activity not saved! %@ %@", error, [error localizedDescription]);
	}
	
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onCallTypeAction:(UIButton *)sender
{
	self.selectedActivityType = kActivityTypeCall;
	self.callButton.selected = YES;
	self.meetingButton.selected = NO;
	self.taskButton.selected = NO;
}

- (IBAction)onMeetingTypeAction:(UIButton *)sender
{
	self.selectedActivityType = kActivityTypeMeeting;
	self.callButton.selected = NO;
	self.meetingButton.selected = YES;
	self.taskButton.selected = NO;
}

- (IBAction)onTaskTypeAction:(UIButton *)sender
{
	self.selectedActivityType = kActivityTypeTask;
	self.callButton.selected = NO;
	self.meetingButton.selected = NO;
	self.taskButton.selected = YES;
}

- (IBAction)onDateSelected:(UIDatePicker *)sender
{
//	sender.date
	NSLog(@"selected date");
}

#pragma makr -

- (AppDelegate *)appDelegate
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (NSManagedObjectContext *)managedObjectContext
{
	if (_managedObjectContext == nil)
	{
		NSPersistentStoreCoordinator *coordinator = self.appDelegate.persistentStoreCoordinator;
		if (coordinator != nil)
		{
			_managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
			_managedObjectContext.persistentStoreCoordinator = coordinator;
		}
	}
	return _managedObjectContext;
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
