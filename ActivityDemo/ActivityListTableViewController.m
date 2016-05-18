//
//  ActivityListTableViewController.m
//  ActivityDemo
//
//  Created by Кравченко Максим on 5/18/16.
//  Copyright © 2016 Кравченко Максим. All rights reserved.
//

#import "ActivityListTableViewController.h"
#import "ActivityTableViewCell.h"
#import "AppDelegate.h"
#import "EditorTableViewController.h"

enum : NSInteger
{
	kActivitySectionOutdated = 0,
	kActivitySectionActual,
	kActivitySectionCompleted,
	kActivitySectionCount
};

static NSString * const kEditSegueId = @"editSegue";
static NSString * const kTableViewCellReusableId = @"Cell";

@interface ActivityListTableViewController ()

@property (nonatomic) NSMutableArray *outdatedActivities;
@property (nonatomic) NSMutableArray *actualActivities;
@property (nonatomic) NSMutableArray *completedActivities;

@end

@implementation ActivityListTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.tableView.estimatedRowHeight = 50.0;
	self.tableView.rowHeight = UITableViewAutomaticDimension;

	self.navigationItem.hidesBackButton = YES;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self updateActivitiesLists];
}

- (void)updateActivitiesLists
{
	NSManagedObjectContext *managedObjectContext = [self appDelegate].managedObjectContext;
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:kActivityKey];
	NSArray *allActivities = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
	
	self.outdatedActivities = [NSMutableArray new];
	self.actualActivities = [NSMutableArray new];
	self.completedActivities = [NSMutableArray new];

	for (NSManagedObject *activity in allActivities)
	{
		ActivityStatus status = [[activity valueForKey:@"status"] integerValue];
		switch (status)
		{
			case kActivityStatusOutdated:
			{
				[self.outdatedActivities addObject:activity];
				break;
			}
			case kActivityStatusActual:
			{
				NSDate *date = (NSDate *)[activity valueForKey:@"date"];
				if ([date laterDate:[NSDate date]] == date)
				{
					[self.actualActivities addObject:activity];
				}
				else
				{
					[self.outdatedActivities addObject:activity];
				}
				break;
			}
			case kActivityStatusCompleted:
			{
				[self.completedActivities addObject:activity];
				break;
			}
			default:
				break;
		}
	}
	
	[self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (AppDelegate *)appDelegate
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return kActivitySectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger result = self.outdatedActivities.count;
	if (section == kActivitySectionActual)
	{
		result = self.actualActivities.count;
	}
	else if (section == kActivityStatusCompleted)
	{
		result = self.completedActivities.count;
	}

    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellReusableId forIndexPath:indexPath];
	NSInteger section = indexPath.section;
	NSInteger row = indexPath.row;
	NSManagedObject *activity = nil;

	switch (section)
	{
		case kActivitySectionOutdated:
		{
			activity = self.outdatedActivities[row];
			break;
		}
		case kActivitySectionActual:
		{
			activity = self.actualActivities[row];
			break;
		}
		case kActivitySectionCompleted:
		{
			activity = self.completedActivities[row];
			break;
		}
		default:
		{
			NSAssert(activity == nil, @"activity can't be nil when fill table view");
			break;
		}
	}
	
	cell.typeLabel.text = [self getTypeStringForActivity:activity];
	cell.dateLabel.text = [self getDateStringForActivity:activity];
	cell.noteTextView.text = [activity valueForKey:@"note"];
	
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString *result = @"";
	if (section == kActivitySectionOutdated && self.outdatedActivities.count > 0)
	{
		result = NSLocalizedString(@"Outdated", @"");
	}
	else if (section == kActivitySectionActual && self.actualActivities.count > 0)
	{
		result = NSLocalizedString(@"Actual", @"");
	}
	else if (section == kActivityStatusCompleted && self.completedActivities.count > 0)
	{
		result = NSLocalizedString(@"Completed", @"");
	}
	return result;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSManagedObject *activity = [self getActivityFor:indexPath];

	[self presentAlertSheetForActivity:activity forIndexPath:indexPath];
}

#pragma mark - util methods

- (void)presentAlertSheetForActivity:(nonnull NSManagedObject *)activity forIndexPath:(NSIndexPath *)indexPath
{
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Modify activity", @"") message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
	
	UIAlertAction *cancelAction = [UIAlertAction
								   actionWithTitle:NSLocalizedString(@"Cancel", @"")
								   style:UIAlertActionStyleCancel
								   handler:^(UIAlertAction *action)
								   {
								   }];
	
	
	NSManagedObjectContext *context = [[self appDelegate] managedObjectContext];

	
	UIAlertAction *editAction = [UIAlertAction
							   actionWithTitle:NSLocalizedString(@"Edit", @"")
							   style:UIAlertActionStyleDefault
							   handler:^(UIAlertAction *action)
							   {
							   }];
	
	UIAlertAction *deleteAction = [UIAlertAction
								 actionWithTitle:NSLocalizedString(@"Delete", @"")
								 style:UIAlertActionStyleDefault
								 handler:^(UIAlertAction *action)
								 {
									 [context deleteObject:activity];
									 
									 NSError *error = nil;
									 if ([context save:&error])
									 {
										 [[self getActivityArrayFor:indexPath] removeObject:activity];
									 }
									 else
									 {
										 NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
									 }
									 
									 [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
								 }];
	
	UIAlertAction *completeAction = [UIAlertAction
								 actionWithTitle:NSLocalizedString(@"Complete", @"")
								 style:UIAlertActionStyleDefault
								 handler:^(UIAlertAction *action)
								 {
									 [[self getActivityArrayFor:indexPath] setValue:@(kActivityStatusCompleted) forKey:@"status"];
									
									 NSError *error = nil;
									 if (![context save:&error])
									 {
										 NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
									 }

									 [self updateActivitiesLists];
								 }];
	
	[alertController addAction:cancelAction];
	[alertController addAction:editAction];
	[alertController addAction:deleteAction];
	[alertController addAction:completeAction];
	
	[self presentViewController:alertController animated:YES completion:nil];
}

- (NSManagedObject *)getActivityFor:(NSIndexPath *)indexPath
{
	NSManagedObject *activity = nil;
	
	NSInteger row = indexPath.row;
	switch (indexPath.section)
	{
		case kActivitySectionOutdated:
		{
			activity = self.outdatedActivities[row];
			break;
		}
		case kActivitySectionActual:
		{
			activity = self.actualActivities[row];
			break;
		}
		case kActivitySectionCompleted:
		{
			activity = self.completedActivities[row];
			break;
		}
		default:
		{
			NSAssert(activity == nil, @"activity can't be nil when fill table view");
			break;
		}
	}
	return activity;
}

- (NSMutableArray *)getActivityArrayFor:(NSIndexPath *)indexPath
{
	NSMutableArray *targetArray = nil;
	
	switch (indexPath.section)
	{
		case kActivitySectionOutdated:
		{
			targetArray = self.outdatedActivities;
			break;
		}
		case kActivitySectionActual:
		{
			targetArray = self.actualActivities;
			break;
		}
		case kActivitySectionCompleted:
		{
			targetArray = self.completedActivities;
			break;
		}
		default:
		{
			NSAssert(targetArray == nil, @"activity can't be nil when fill table view");
			break;
		}
	}
	return targetArray;
}

- (NSString *)getTypeStringForActivity:(NSManagedObject *)activity
{
	NSString *result = @"Call";

	NSInteger type = [[activity valueForKey:@"type"] integerValue];
	if (type == kActivityTypeMeeting)
	{
		result = @"Meeting";
	}
	else if (type == kActivityTypeTask)
	{
		result = @"Task";
	}
	return result;
}

- (NSString *)getDateStringForActivity:(NSManagedObject *)activity
{
	NSDate *date = (NSDate *)[activity valueForKey:@"date"];
	NSDateFormatter *formatter = [NSDateFormatter new];
	[formatter setDateFormat: @"MM-dd HH:mm"];
	
	NSString *result = [formatter stringFromDate:date];
	return result;
}

@end
