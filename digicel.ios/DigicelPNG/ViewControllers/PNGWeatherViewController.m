//
//  PNGWeatherViewController.m
//  DigicelPNG
//
//  Created by Shane Henderson on 17/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGWeatherViewController.h"
#import "MBProgressHUD.h"

@interface PNGWeatherViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *webViewBackButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *webViewCancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *webViewNextButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *webViewRefreshButton;
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSURLRequest *webViewRequest;

@end

@implementation PNGWeatherViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:PNGStoryboardImageNavigationLogo]];
    
    NSURL *url = [NSURL URLWithString:@"http://www.weather-new-zealand.com/Auckland/"];
    self.webViewRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:self.webViewRequest];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [self refreshNavigationToolBar:YES];
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self refreshNavigationToolBar:NO];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self refreshNavigationToolBar:NO];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self refreshNavigationToolBar:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}


#pragma mark - IBActions

- (IBAction)backPage:(id)sender
{
    [self.webView goBack];
}

- (IBAction)cancelLoading:(id)sender
{
    [self.webView stopLoading];
}

- (IBAction)nextPage:(id)sender
{
    [self.webView goForward];
}

- (IBAction)openInSafari:(id)sender
{
    [[UIApplication sharedApplication] openURL:self.webView.request.URL];
}

- (IBAction)refreshWebView:(id)sender
{
    [self.webView reload];
}


#pragma mark - Private Methods

- (void)refreshNavigationToolBar:(BOOL)loading
{
    self.webViewBackButton.enabled = self.webView.canGoBack;
    self.webViewNextButton.enabled = self.webView.canGoForward;
    self.webViewRefreshButton.enabled = !loading;
    self.webViewCancelButton.enabled = loading;
}

@end
