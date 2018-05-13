//
//  LocalActionSheetPicker.m
//  ActionSheetPicker
//
//  Created by dwolf on 16/8/9.
//
//

#import "UnionSelectActionSheetPicker.h"
#import "Const.h"

@interface UnionSelectActionSheetPicker()
@property (nonatomic,strong) NSArray *data; //Array of string arrays :)
@property (nonatomic,strong) NSMutableArray *initialSelection;
@property (nonatomic,strong) NSMutableArray *selectArr;
@property int pickCount;

@end

@implementation UnionSelectActionSheetPicker{
    @private
    int curSelect;
}
@synthesize delegate;

+ (instancetype)showPickerWithTitle:(NSString *)title pickeCount:(int)pickeCount rows:(NSArray *)strings initialSelection:(NSArray *)indexes doneBlock:(ActionStringDoneBlock)doneBlock cancelBlock:(ActionStringCancelBlock)cancelBlockOrNil origin:(id)origin delegate:(id) delegate{
    UnionSelectActionSheetPicker * picker = [[UnionSelectActionSheetPicker alloc] initWithTitle:title pickeCount:pickeCount rows:strings initialSelection:indexes doneBlock:doneBlock cancelBlock:cancelBlockOrNil origin:origin];
    picker.delegate = delegate;
    [picker showActionSheetPicker];
    return picker;
}

- (instancetype)initWithTitle:(NSString *)title pickeCount:(int)pickeCount  rows:(NSArray *)strings initialSelection:(NSArray *)indexes doneBlock:(ActionStringDoneBlock)doneBlock cancelBlock:(ActionStringCancelBlock)cancelBlockOrNil origin:(id)origin {
    self = [self initWithTitle:title  pickeCount:pickeCount  rows:strings  initialSelection:indexes target:nil successAction:nil cancelAction:nil origin:origin];
    if (self) {
        self.onActionSheetDone = doneBlock;
        self.onActionSheetCancel = cancelBlockOrNil;
    }
    return self;
}

+ (instancetype)showPickerWithTitle:(NSString *)title  pickeCount:(int)pickeCount  rows:(NSArray *)data initialSelection:(NSArray *)indexes target:(id)target successAction:(SEL)successAction cancelAction:(SEL)cancelActionOrNil origin:(id)origin delegate:(id) delegate{
    UnionSelectActionSheetPicker *picker = [[UnionSelectActionSheetPicker alloc] initWithTitle:title  pickeCount:pickeCount rows:data initialSelection:indexes target:target successAction:successAction cancelAction:cancelActionOrNil origin:origin];
    picker.delegate = delegate;
    [picker showActionSheetPicker];
    return picker;
}

- (instancetype)initWithTitle:(NSString *)title pickeCount:(int)pickeCount  rows:(NSArray *)data initialSelection:(NSArray *)indexes target:(id)target successAction:(SEL)successAction cancelAction:(SEL)cancelActionOrNil origin:(id)origin {
    self = [self initWithTarget:target  successAction:successAction cancelAction:cancelActionOrNil origin:origin];
    
    //注册数据变化消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePicker:) name:UNION_SELECT_MSG_UPDATE object:self.delegate];
    if (self) {
        self.data = data;
        self.pickCount = pickeCount;
        self.initialSelection = [[NSMutableArray alloc ] initWithArray:indexes];
        self.title = title;
        self.selectArr = [[NSMutableArray alloc] init];
        [self initData];
    }
    return self;
}

-(void) updatePicker:(NSNotification*) aNotification
{
    //通知的数据
    NSDictionary* dic =  [aNotification object];
    int component = curSelect;
    NSArray* retArr = dic[@"data"];
    for(int i =component+1; i < self.pickCount; i ++){
        [self.selectArr replaceObjectAtIndex:i withObject:retArr[i]];
        UIPickerView* pickView = (UIPickerView*)self.pickerView;
        
       
        [pickView reloadComponent:i];
         [pickView selectRow: 0 inComponent:i animated:NO];
    }
}

- (UIView *)configuredPickerView {
    if (!self.data)
        return nil;
    CGRect pickerFrame = CGRectMake(0, 40, self.viewSize.width, 216);
    UIPickerView *stringPicker = [[UIPickerView alloc] initWithFrame:pickerFrame];
    stringPicker.delegate = self;
    stringPicker.dataSource = self;
    
    [self performInitialSelectionInPickerView:stringPicker];
    
    if (self.data.count == 0) {
        stringPicker.showsSelectionIndicator = NO;
        stringPicker.userInteractionEnabled = NO;
    } else {
        stringPicker.showsSelectionIndicator = YES;
        stringPicker.userInteractionEnabled = YES;
    }
    
    //need to keep a reference to the picker so we can clear the DataSource / Delegate when dismissing
    self.pickerView = stringPicker;
    
    return stringPicker;
}

-(void) initData{
    for(int i = 0; i < _pickCount; i++){
        [_selectArr addObject: self.data[i]];
    }
}


- (void)notifyTarget:(id)target didSucceedWithAction:(SEL)successAction origin:(id)origin {
    if (self.onActionSheetDone) {
        _onActionSheetDone(self, [self selectedIndexes], [self selection]);
        return;
    }
    else if (target && [target respondsToSelector:successAction]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [target performSelector:successAction withObject:self.selectedIndexes withObject:origin];
#pragma clang diagnostic pop
        return;
    }
    NSLog(@"Invalid target/action ( %s / %s ) combination used for ActionSheetPicker and done block is nil.", object_getClassName(target), sel_getName(successAction));
}

- (void)notifyTarget:(id)target didCancelWithAction:(SEL)cancelAction origin:(id)origin {
    if (self.onActionSheetCancel) {
        _onActionSheetCancel(self);
        return;
    }
    else if (target && cancelAction && [target respondsToSelector:cancelAction]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [target performSelector:cancelAction withObject:origin];
#pragma clang diagnostic pop
    }
}

#pragma mark - UIPickerViewDelegate / DataSource

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    curSelect = component;
    self.initialSelection[component] =  (self.selectArr)[component][row][@"name"];
    [self.delegate loadUnionData:(self.selectArr)[component][row] index:component+1];
    
    return;
    
            
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.pickCount;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return ((NSArray *)self.selectArr[component]).count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    id obj = (self.selectArr)[component][row];
    
    // return the object if it is already a NSString,
    // otherwise, return the description, just like the toString() method in Java
    // else, return nil to prevent exception
    
    if ([obj isKindOfClass:[NSString class]])
        return obj;
    if([obj isKindOfClass:[NSDictionary class]]){
        return obj[@"name"];
    }
    if ([obj respondsToSelector:@selector(description)])
        return [obj performSelector:@selector(description)];
    
    return nil;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    id obj = (self.selectArr)[component][row];
//
//    // return the object if it is already a NSString,
//    // otherwise, return the description, just like the toString() method in Java
//    // else, return nil to prevent exception
//    
    if ([obj isKindOfClass:[NSString class]])
        return [[NSAttributedString alloc] initWithString:obj attributes:self.titleTextAttributes];
    if([obj isKindOfClass:[NSDictionary class]]){
        return [[NSAttributedString alloc] initWithString: obj[@"name"] attributes:self.titleTextAttributes];
    }
    if ([obj respondsToSelector:@selector(description)])
        return [[NSAttributedString alloc] initWithString:[obj performSelector:@selector(description)] attributes:self.titleTextAttributes];
    
    return nil;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.minimumFontSize = 8.0;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)performInitialSelectionInPickerView:(UIPickerView *)pickerView {
    for (int i = 0; i < self.selectedIndexes.count; i++) {
        int count = 0;
        [pickerView selectRow:0 inComponent:i animated:NO];
        for(NSDictionary* dic in self.selectArr[i]){
            if(self.initialSelection.count > i && [dic[@"name"] isEqualToString:self.initialSelection[i]]){
               [pickerView selectRow:count inComponent:i animated:NO];
                break;
            }
            count ++;
        }
        
    }
}

- (NSArray *)selection {
    NSMutableArray * array = [NSMutableArray array];
    for (int i = 0; i < self.pickCount; i++) {
        int row = [(UIPickerView *)self.pickerView selectedRowInComponent:(NSInteger)i];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc ] initWithDictionary: self.selectArr[i][row] ];
        [array addObject: dic];
    }
    return [array copy];
}

- (NSArray *)selectedIndexes {
    NSMutableArray * indexes = [NSMutableArray array];
    for (int i = 0; i < self.pickCount; i++) {
        if(((NSArray*)self.selectArr[i]).count <= 0){
            continue;
        }
        int row = [(UIPickerView *)self.pickerView selectedRowInComponent:(NSInteger)i];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc ] initWithDictionary: self.selectArr[i][row] ];
        [indexes addObject: dic];
    }
    return [indexes copy];
}

@end
