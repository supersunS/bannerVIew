//
//  ViewController.m
//  sun_bannerView
//
//  Created by sundaoran on 16/9/29.
//  Copyright © 2016年 sundaoran. All rights reserved.
//

#import "ViewController.h"
#import "sz_bannerHead.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;


@end

@implementation ViewController
{
    likes_bannerView *_bannerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    NSArray *tempArray=[[NSArray alloc]initWithObjects:
                        @{@"image":@"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1287797417,808697024&fm=116&gp=0.jpg"},
                        @{@"image":@"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=509018236,2116050944&fm=116&gp=0.jpg"},
                        @{@"image":@"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=72854971,1442321265&fm=116&gp=0.jpg"},
                        @{@"image":@"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=2389323131,1530511915&fm=21&gp=0.jpg"},
                        @{@"image":@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=213681810,3435096827&fm=21&gp=0.jpg"},
                        @{@"image":@"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=2602211632,244480247&fm=21&gp=0.jpg"},nil];
    
    self.tableView.tableHeaderView=[self creatBannerView:tempArray];
}



-(UIView *)creatBannerView:(NSArray *)array
{
    if(!_bannerView)
    {
        _bannerView=[[likes_bannerView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width/375*186)];
        _bannerView.imageArray=[[NSMutableArray alloc]initWithArray:array];
        [_bannerView changeSelectImage:^(id selectObject) {
            NSDictionary *infoDict=((likes_bannerObject *)selectObject).bannerExtend;
            
        }];
    }
    else
    {
        _bannerView.imageArray=[[NSMutableArray alloc]initWithArray:array];
        [_bannerView reloadBannerView];
    }
    return _bannerView;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
