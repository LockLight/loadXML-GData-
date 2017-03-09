//
//  ViewController.m
//  XML解析(GData方式)
//
//  Created by locklight on 17/3/9.
//  Copyright © 2017年 LockLight. All rights reserved.
//

#import "ViewController.h"
#import "Video.h"
#import "GDataXMLNode.h"

@interface ViewController ()

@end

@implementation ViewController{
    NSMutableArray<Video *> *_modelList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _modelList = [NSMutableArray array];
    
    [self loadData];
}

- (void)loadData{
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/videos02.xml"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil){
            NSLog(@"error =%@",error);
            return;
        }
        
        //GData创建XML文档树
        GDataXMLDocument *doc = [[GDataXMLDocument alloc]initWithData:data error:NULL];
        
        //遍历主干子节点
        for (GDataXMLElement *videoEle in doc.rootElement.children) {
            Video *model = [Video new];
            //遍历子节点的值
            for (GDataXMLElement *element in videoEle.children) {
                [model setValue:element.stringValue forKey:element.name];
            }
            //遍历子节点的属性
            for (GDataXMLNode * node in videoEle.attributes ) {
                [model setValue:node.stringValue forKey:node.name];
            }
            [_modelList addObject:model];
        }
        NSLog(@"%@",_modelList);
    }]resume];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
