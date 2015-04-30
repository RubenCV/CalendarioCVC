//
//  NoticiaViewController.m
//  CeldasMedida
//
//  Created by Ruben Cantu on 4/24/15.
//  Copyright (c) 2015 A00814298. All rights reserved.
//

#import "NoticiaViewController.h"

@interface NoticiaViewController () <UIWebViewDelegate>

@end

@implementation NoticiaViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *fullURL = [@"https://cvc.itesm.mx/egresados/plsql/NoticiasPortalOr.NPO_Inicio?l_noticia=" stringByAppendingString: _idNoticia];
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [_viewWeb loadRequest:requestObj];
    // Para evitar Links
    [_viewWeb setDelegate: self];
    // Para evitar resize.
    _viewWeb.scrollView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    // Hago esto para que si clickean en un link no pase nada.
    if(navigationType == UIWebViewNavigationTypeLinkClicked) {
        return NO;
    }
    return YES;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // Hago esto para que si hacen doble tap no cambie el tamaño.
    return nil;
}

@end