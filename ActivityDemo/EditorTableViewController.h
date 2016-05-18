//
//  EditorTableViewController.h
//  ActivityDemo
//
//  Created by Maksym Kravchenko on 5/18/16.
//  Copyright © 2016 Кравченко Максим. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NSManagedObject;

@interface EditorTableViewController : UITableViewController

@property (nonatomic, nullable) NSManagedObject *selectedActivity;


@end
