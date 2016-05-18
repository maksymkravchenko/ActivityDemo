//
//  ActivityTableViewCell.h
//  ActivityDemo
//
//  Created by Maksym Kravchenko on 5/18/16.
//  Copyright © 2016 Кравченко Максим. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *noteTextView;

@end
