//
//  PNGClassifiedsViewController.m
//  DigicelPNG
//
//  Created by Shane Henderson on 17/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGClassifiedsViewController.h"
#import "MBProgressHUD.h"

#define kRenderKey      @"render=mobile_app"

@interface PNGClassifiedsViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *webViewBackButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *webViewCancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *webViewNextButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *webViewRefreshButton;
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSURLRequest *webViewRequest;

@end

@implementation PNGClassifiedsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenName = @"Classifieds";
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:PNGStoryboardImageNavigationLogo]];
    NSURL *url;
    if(self.url) {
        NSString *urlString;
        if ([self.url hasPrefix:@"https://"]) {
            urlString = [NSString stringWithFormat:@"%@",self.url];
        }else{
            urlString = [NSString stringWithFormat:@"%@%@",kBaseUrl,self.url];
        }
        url = [NSURL URLWithString:[self addHeaderRenderKey:urlString]];
    } else {
        NSString *urlString = [NSString stringWithFormat:@"%@my-classifieds/?cookie=%@&%@",kBaseUrl,[[NSUserDefaults standardUserDefaults] valueForKey:kAuthCookie],kRenderKey];
        urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
        url = [NSURL URLWithString:urlString];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - WebView Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *url = request.URL.absoluteString;
    if([url rangeOfString:[NSString stringWithFormat:@"%@classifieds/",kBaseUrl]].location != NSNotFound) {
        if([url rangeOfString:kRenderKey].location == NSNotFound) {
            url = [self addHeaderRenderKey:url];
            [self performSelector:@selector(loadNewUrl:) withObject:url afterDelay:0.01];
            return NO;
        }
    }
    [self refreshNavigationToolBar:YES];
    return YES;
}

//  Adding required header value for hiding header and footer in website.
- (NSString *)addHeaderRenderKey:(NSString *)url {
    if([url rangeOfString:@"?"].location == NSNotFound) {
        url = [NSString stringWithFormat:@"%@?%@",url,kRenderKey];
    } else {
        url = [NSString stringWithFormat:@"%@&%@",url,kRenderKey];
    }
    return url;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self refreshNavigationToolBar:NO];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self refreshNavigationToolBar:NO];
    [MBProgressHUD hideAllHUDsForView:self.webView animated:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self refreshNavigationToolBar:YES];
    [MBProgressHUD showHUDAddedTo:self.webView animated:YES];
}

- (void)loadNewUrl:(NSString *)url {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [_webView loadRequest:request];
}

#pragma mark - IBActions

- (IBAction)backPage:(id)sender {
    [self.webView goBack];
}

- (IBAction)cancelLoading:(id)sender {
    [MBProgressHUD hideAllHUDsForView:self.webView animated:YES];
    [self.webView stopLoading];
}

- (IBAction)nextPage:(id)sender {
    [self.webView goForward];
}

- (IBAction)openInSafari:(id)sender {
    [[UIApplication sharedApplication] openURL:self.webView.request.URL];
}

- (IBAction)refreshWebView:(id)sender {
    [self.webView reload];
}


#pragma mark - Private Methods

- (void)refreshNavigationToolBar:(BOOL)loading {
    self.webViewBackButton.enabled = self.webView.canGoBack;
    self.webViewNextButton.enabled = self.webView.canGoForward;
    self.webViewRefreshButton.enabled = !loading;
    self.webViewCancelButton.enabled = loading;
}
@end
