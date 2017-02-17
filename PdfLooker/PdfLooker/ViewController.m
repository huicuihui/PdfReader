//
//  ViewController.m
//  PdfLooker
//
//  Created by apple on 2016/12/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ViewController.h"
#import "PDFView.h"
@interface ViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>
@property (nonatomic, strong)UIPageViewController *pageVC;
@property (nonatomic, strong)NSMutableArray *pdfArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"第三页" style:UIBarButtonItemStyleDone target:self action:@selector(jumpToControllerAtIndex)];
    self.pdfArr = [NSMutableArray array];
    NSDictionary *options = [NSDictionary  dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey:UIPageViewControllerOptionSpineLocationKey];
    self.pageVC = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    _pageVC.view.frame = self.view.bounds;
    _pageVC.delegate = self;
    _pageVC.dataSource = self;
    [self addChildViewController:_pageVC];
    
    PDFView *testPdf = [[PDFView alloc]initWithFrame:self.view.frame atPage:1 andFileName:@"Reader"];
    CGPDFDocumentRef pdfRef = [testPdf createPDFFromExistFile];
    size_t count = CGPDFDocumentGetNumberOfPages(pdfRef);//这个位置主要是获取pdf页码数；
    
    for (int i = 0; i < count; i++) {
        UIViewController *pdfVC = [[UIViewController alloc] init];
        PDFView *pdfView = [[PDFView alloc] initWithFrame:self.view.frame atPage:(i+1) andFileName:@"Reader"];
        [pdfVC.view addSubview:pdfView];
        
        [_pdfArr addObject:pdfVC];
    }
    
    
    [_pageVC setViewControllers:[NSArray arrayWithObject:_pdfArr[0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [self.view addSubview:_pageVC.view];
    
}
- (void)jumpToControllerAtIndex {
    NSInteger index = 2;
    UIViewController *controller = [self viewControllerAtIndex:index];
    [_pageVC setViewControllers:@[controller] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}
//委托方法；
- (UIViewController *)viewControllerAtIndex:(NSInteger)index
{
    //Create a new view controller and pass suitable data.
    
    if (([_pdfArr count] == 0 )|| (index > [_pdfArr count]) ) {
        return nil;
    }
    
    
    NSLog(@"index = %ld",(long)index);
    
    return (UIViewController *)_pdfArr[index];
}


- (NSUInteger) indexOfViewController:(UIViewController *)viewController
{
    return [self.pdfArr indexOfObject:viewController];
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(UIViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    
    if (index == [_pdfArr count]){
        return  nil;
    }
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(UIViewController *)viewController];
    if ((index == 0 ) || (index == NSNotFound)){
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
