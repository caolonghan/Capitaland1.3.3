//
//  LocalActionSheetPicker.h
//  ActionSheetPicker
//
//  Created by dwolf on 16/8/9.
//
//

#import "ActionSheetPicker.h"
@protocol UnionSelectActionSheetPickerDelegate<NSObject>
@optional

// returns width of column and height of row for each component.
- (NSArray*)loadUnionData:(NSDictionary *)dic index:(int)index;
@end

#define UNION_SELECT_MSG_UPDATE @"UNION_SELECT_MSG_UPDATE"
@interface UnionSelectActionSheetPicker : AbstractActionSheetPicker<UIPickerViewDelegate, UIPickerViewDataSource>
/**
 *  Create and display an action sheet picker.
 *
 *  @param title             Title label for picker
 *  @param data              is an array of strings to use for the picker's available selection choices
 *  @param index             is used to establish the initially selected row;
 *  @param target            must not be empty.  It should respond to "onSuccess" actions.
 *  @param successAction
 *  @param cancelActionOrNil cancelAction
 *  @param origin            must not be empty.  It can be either an originating container view or a UIBarButtonItem to use with a popover arrow.
 *
 *  @return  return instance of picker
 */
+ (instancetype)showPickerWithTitle:(NSString *)title pickeCount:(int)pickeCount rows:(NSArray *)data initialSelection:(NSArray *)indexes target:(id)target successAction:(SEL)successAction cancelAction:(SEL)cancelActionOrNil origin:(id)origin delegate:(id) delegate;

// Create an action sheet picker, but don't display until a subsequent call to "showActionPicker".  Receiver must release the picker when ready. */
- (instancetype)initWithTitle:(NSString *)title pickeCount:(int)pickeCount  rows:(NSArray *)data initialSelection:(NSArray *)indexes target:(id)target successAction:(SEL)successAction cancelAction:(SEL)cancelActionOrNil origin:(id)origin;




+ (instancetype)showPickerWithTitle:(NSString *)title pickeCount:(int)pickeCount rows:(NSArray *)strings initialSelection:(NSArray *)indexes doneBlock:(ActionStringDoneBlock)doneBlock cancelBlock:(ActionStringCancelBlock)cancelBlockOrNil origin:(id)origin delegate:(id) delegate;

- (instancetype)initWithTitle:(NSString *)title pickeCount:(int)pickeCount rows:(NSArray *)strings initialSelection:(NSArray *)indexes doneBlock:(ActionStringDoneBlock)doneBlock cancelBlock:(ActionStringCancelBlock)cancelBlockOrNil origin:(id)origin;

@property (nonatomic, copy) ActionStringDoneBlock onActionSheetDone;
@property (nonatomic, copy) ActionStringCancelBlock onActionSheetCancel;
@property id<UnionSelectActionSheetPickerDelegate> delegate;
@end
