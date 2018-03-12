#import "JavaScriptAlertOfUIWebView.h"

@implementation UIWebView(JavaScriptAlertOfUIWebView)

static BOOL diagStat = NO;
static BOOL confirmDiagHidden = NO;

- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id *)frame {
    
    
    UIAlertView* customAlert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self  cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [customAlert show];
    confirmDiagHidden = NO;
    while (!confirmDiagHidden){
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01f]];
    }
    
}
- (BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(id *)frame
{
    
    UIAlertView *confirmDiag = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:NSLocalizedString(@"确定", @"确定") otherButtonTitles:NSLocalizedString(@"取消", @"取消"), nil];
    
    [confirmDiag show];
    confirmDiagHidden = NO;
    while (!confirmDiagHidden){
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01f]];
    }
    
    NSLog(@"confirmDiag%@,%@",confirmDiag.superview,confirmDiag.hidden?@"YES":@"NO");
    
    
    return diagStat;
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //index 0 : YES , 1 : NO
    
    
    if (buttonIndex == 0){
        
        //return YES;
        
        diagStat = YES;
        
    } else if (buttonIndex == 1) {
        
        //return NO;
        
        diagStat = NO;
        
    }
    confirmDiagHidden = YES;
    
    
}
@end