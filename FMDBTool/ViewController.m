//
//  ViewController.m
//  FMDBTool
//
//  Created by chengdonghai on 15/5/16.
//  Copyright (c) 2015年 天翼文化. All rights reserved.
//

#import "ViewController.h"
#import "CellModel.h"
#import "DAO.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSArray *tableArray;;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DAO *dao = [DAO new];
    self.tableArray = [dao queryData];
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    // Do any additional setup after loading the view, typically from a nib.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell_identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    NSInteger row = indexPath.row;
    if (row < [self.tableArray count]) {
        CellModel *cellModel = [self.tableArray objectAtIndex:row];
        cell.textLabel.text = cellModel.title;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%li time:%@", (long)cellModel.count, cellModel.curTime];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, CGRectGetWidth(tableView.frame), 30)];
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"新增" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addNewRow:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

-(void)addNewRow:(id)sender
{
    [[DAO new] insert:[NSString stringWithFormat:@"title:%li",(long)self.tableArray.count] count:self.tableArray.count];
    self.tableArray = [[DAO new] queryData];
    [self.tableView reloadData];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[DAO new] delete:((CellModel *)self.tableArray[indexPath.row]).tid];
        self.tableArray = [[DAO new] queryData];
        [self.tableView reloadData];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
