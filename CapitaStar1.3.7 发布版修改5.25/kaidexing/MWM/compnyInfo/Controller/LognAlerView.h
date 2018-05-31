//
//  LognAlerView.h
//  Community
//
//  Created by 未来社区 on 16/8/6.
//  Copyright © 2016年 李江. All rights reserved.
//

#import <UIKit/UIKit.h>



@class LognAlerView;

@protocol LognAlerViewdelegate<NSObject>

- (void)clickindex:(int)index ;

@end



@interface LognAlerView : UIView{

        UIView *_maskView;

}

@property(nonatomic,assign)id<LognAlerViewdelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *enter;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tLabel2;

@property (weak, nonatomic) IBOutlet UIButton *imgName;

- (IBAction)cance:(id)sender;

- (instancetype)initWithTitle:(NSString *)title
                       title2:(NSString *)title2
                     delegate:(id<LognAlerViewdelegate>)delgate;

- (void)show;
- (void)dismiss;





@end
